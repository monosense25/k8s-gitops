terraform {
  cloud {
    organization = "monosense"

    workspaces {
      name = "home-cloudflare-provisioner"
    }
  }

  required_providers {
    authentik = {
      source  = "goauthentik/authentik"
      version = "2023.8.0"
    }
  }
}

module "secret_authentik" {
  # Remember to export OP_CONNECT_HOST and OP_CONNECT_TOKEN
  source = "github.com/bjw-s/terraform-1password-item?ref=main"
  vault  = "k8s-gitops"
  item   = "authentik"
}

module "secret_immich" {
  source = "github.com/bjw-s/terraform-1password-item?ref=main"
  vault  = "k8s-gitops"
  item   = "immich"
}

module "secret_grafana" {
  source = "github.com/bjw-s/terraform-1password-item?ref=main"
  vault  = "k8s-gitops"
  item   = "grafana"
}

module "secret_proxmox" {
  source = "github.com/bjw-s/terraform-1password-item?ref=main"
  vault  = "k8s-gitops"
  item   = "proxmox"
}

module "secret_nextcloud" {
  source = "github.com/bjw-s/terraform-1password-item?ref=main"
  vault  = "k8s-gitops"
  item   = "nextcloud"
}

module "secret_tandoor" {
  source = "github.com/bjw-s/terraform-1password-item?ref=main"
  vault  = "k8s-gitops"
  item   = "tandoor"
}

provider "authentik" {
  url   = module.secret_authentik.fields["endpoint_url"]
  token = module.secret_authentik.fields["terraform_token"]
}