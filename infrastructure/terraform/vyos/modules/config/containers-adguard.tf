resource "vyos_config" "container-adguard" {
  path = "container name adguard"
  value = jsonencode({
    "image" = "${var.config.containers.adguard.image}"
    "network" = {
      "services" = {
        "address" = "${cidrhost(var.networks.services, 6)}"
      }
    }
    "volume" = {
      "config" = {
        "source"      = "/config/containers/adguard/conf"
        "destination" = "/opt/adguardhome/conf"
      }
      "workdir" = {
        "source"      = "/config/containers/adguard/work"
        "destination" = "/opt/adguardhome/work"
      }
    }
  })

  depends_on = [
    vyos_config.container_network-services
  ]
}