module "cf_domain_personal" {
  source     = "./modules/cf_domain"
  domain     = "monosense.io"
  account_id = cloudflare_account.monosense.id

  dns_entries = [
    {
      name  = "ipv4"
      value = local.home_ipv4
    },
    {
      id      = "vpn"
      name    = module.onepassword_item_cloudflare.fields["vpn-subdomain"]
      value   = "ipv4.monosense.io"
      type    = "CNAME"
      proxied = false
    },
    # Generic settings
    {
      name  = "_dmarc"
      value = "v=DMARC1; p=none; rua=mailto:info@monosense.io; ruf=mailto:info@monosense.io; sp=none; adkim=r; aspf=r"
      type  = "TXT"
    },
    # MX Settings
    {
      id       = "zoho_mx_1"
      name     = "@"
      priority = 10
      value    = "mx.zoho.com"
      type     = "MX"
    },
    {
      id       = "zoho_mx_2"
      name     = "@"
      priority = 20
      value    = "mx2.zoho.com"
      type     = "MX"
    },
    {
      id       = "zoho_mx_3"
      name     = "@"
      priority = 50
      value    = "mx3.zoho.com"
      type     = "MX"
    },
    {
      id      = "zoho_dkim"
      name    = "zmail._domainkey"
      value   = "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDbvrOQbW0VAig1orsbYYDQjMIKW2V3WXFKQKjJi8P1zeQBT7f4bxn299cYGweKvRE6IMTKY1Bm3ra2xIS7IDr2U/xLqhGZ510PoyxaI3gFOfRnpOioSoAStg6Ls60z65atb8YiNq3OMfJTS2lExqEOVpgeP65TLwJVh8WAuWFmsQIDAQAB"
      type    = "TXT"
      proxied = false
    },
    {
      id    = "zoho_spf"
      name  = "@"
      value = "v=spf1 include:zoho.com ~all"
      type  = "TXT"
    },
  ]

  waf_custom_rules = [
    {
      enabled     = true
      description = "Allow GitHub flux API"
      expression  = "(ip.geoip.asnum eq 36459 and http.host eq \"flux-receiver-cluster-0.monosense.io\")"
      action      = "skip"
      action_parameters = {
        ruleset = "current"
      }
      logging = {
        enabled = false
      }
    },
    {
      enabled     = true
      description = "Firewall rule to block bots and threats determined by CF"
      expression  = "(cf.client.bot) or (cf.threat_score gt 14)"
      action      = "block"
    },
    {
      enabled     = true
      description = "Firewall rule to block certain countries"
      expression  = "(ip.geoip.country in {\"CN\" \"IN\" \"KP\" \"RU\"})"
      action      = "block"
    },
    {
      enabled     = true
      description = "Block Plex notifications"
      expression  = "(http.host eq \"plex.bjw-s.dev\" and http.request.uri.path contains \"/:/eventsource/notifications\")"
      action      = "block"
    },
  ]
}
