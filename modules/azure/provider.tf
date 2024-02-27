provider "azurerm" {
  tenant_id       = var.AZ_TENANT
  client_secret   = var.AZ_SECRET
  subscription_id = var.AZ_SUB_ID
  client_id       = var.AZ_APP_ID
  features {}
}
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.93.0"
    }
  }
}
