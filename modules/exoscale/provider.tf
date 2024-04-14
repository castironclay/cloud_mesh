terraform {
  required_providers {
    exoscale = {
      source  = "exoscale/exoscale"
      version = "0.57.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
  }
}

provider "exoscale" {
  key    = var.EXOSCALE_ACCESS
  secret = var.EXOSCALE_SECRET
}

