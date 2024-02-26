provider "vultr" {
  api_key = var.VULTR_TOKEN
}

resource "vultr_instance" "my_instance" {
  plan   = "vc2-1c-1gb"
  region = "ord" # Chicago
  os_id  = "477" # Debian 11
}

