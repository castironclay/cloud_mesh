terraform {
  required_providers {
    exoscale = {
      source  = "exoscale/exoscale"
      version = "0.55.0"
    }
  }
}

provider "exoscale" {
  key    = var.EXOSCALE_KEY
  secret = var.EXOSCALE_SECRET
}

