# Get all available regions
data "digitalocean_regions" "available" {
  filter {
    key    = "available"
    values = ["true"]
  }
}

# Produce random number between 1 and the length of the available regions
resource "random_integer" "region_number" {
  depends_on = [data.digitalocean_regions.available]
  min        = 1
  max        = length(data.digitalocean_regions.available.regions)
}

resource "digitalocean_droplet" "droplet" {
  depends_on = [digitalocean_ssh_key.key]
  name       = var.name
  size       = "s-1vcpu-1gb"
  image      = "debian-12-x64"
  # Pick region from list of regions at random index and use region slug of proper value for region
  region   = element(data.digitalocean_regions.available.regions, random_integer.region_number.result).slug
  ssh_keys = [digitalocean_ssh_key.key.fingerprint]

  provisioner "remote-exec" {
    inline = ["echo 'Im alive!'"]

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file(var.private_keyname)
      host        = digitalocean_droplet.droplet.ipv4_address
    }
  }
}

resource "digitalocean_ssh_key" "key" {
  name       = var.name
  public_key = file(var.public_keyname)

}

resource "digitalocean_firewall" "firewall" {
  depends_on = [digitalocean_droplet.droplet]
  name       = var.name

  droplet_ids = [digitalocean_droplet.droplet.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]
  }
}


