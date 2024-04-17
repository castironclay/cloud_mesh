provider "google" {
  project     = var.GCP_PROJECT
  credentials = var.GCP_CREDS
}
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.24.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
  }
}
