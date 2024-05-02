provider "vultr" {
  api_key = var.VULTR_TOKEN
}
terraform {
  required_providers {
    vultr = {
      source  = "vultr/vultr"
      version = "2.19.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
  }
}
