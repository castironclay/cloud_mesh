terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.45.0"
    }
    exoscale = {
      source  = "exoscale/exoscale"
      version = "0.57.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "5.24.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.36.0"
    }
    linode = {
      source  = "linode/linode"
      version = "2.19.0"
    }
    vultr = {
      source  = "vultr/vultr"
      version = "2.19.0"
    }
  }
}
