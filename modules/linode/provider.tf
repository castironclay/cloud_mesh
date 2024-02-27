provider "linode" {
  token = var.LINODE_TOKEN
}
terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "2.15.0"
    }
  }
}
