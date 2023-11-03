terraform {

  cloud {
    organization = "monosense"

    workspaces {
      name = "home-minio-provisioner"
    }
  }

  required_providers {
    minio = {
      source  = "aminueza/minio"
      version = "1.19.0"
    }
  }
}

module "onepassword_item_minio" {
  source = "github.com/bjw-s/terraform-1password-item?ref=main"
  vault  = "k8s-gitops"
  item   = "minio"
}

provider "minio" {
  minio_server   = module.onepassword_item_minio.fields.server
  minio_user     = module.onepassword_item_minio.fields.username
  minio_password = module.onepassword_item_minio.fields.password
  minio_ssl      = true
}