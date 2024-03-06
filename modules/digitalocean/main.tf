resource "digitalocean_droplet" "droplet" {
  depends_on = [digitalocean_ssh_key.key]
  name       = var.name
  size       = "s-1vcpu-1gb"
  image      = "debian-12-x64"
  region     = var.region
  ssh_keys   = [digitalocean_ssh_key.key.fingerprint]

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

