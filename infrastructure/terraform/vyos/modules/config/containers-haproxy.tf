resource "remote_file" "haproxy-config" {
  provider = remote
  path     = "/config/containers/haproxy/config/haproxy.cfg"
  content = templatefile(
    pathexpand("${path.root}/files/haproxy/config/haproxy.cfg.tftpl"),
    { domains = var.domains }
  )
  permissions = "0775"
  owner       = "0"   # root
  group       = "104" # vyattacfg
}

resource "vyos_config" "haproxy-k8s-api" {
  path = "container name haproxy-k8s-api"
  value = jsonencode({
    "image" = "${var.config.containers.haproxy.image}"
    "network" = {
      "services" = {
        "address" = "${cidrhost(var.networks.services, 2)}"
      }
    }
    "volume" = {
      "config" = {
        "source"      = "/config/containers/haproxy/config/haproxy.cfg"
        "destination" = "/usr/local/etc/haproxy/haproxy.cfg"
      }
    }
  })

  depends_on = [
    vyos_config.container_network-services,
    remote_file.haproxy-config
  ]
}