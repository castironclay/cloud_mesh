provider "google" {
  project = var.GOOGLE_PROJECT
}
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.18.0"
    }
  }
}
