data "digitalocean_regions" "available" {
  filter {
    key    = "available"
    values = ["true"]
  }
}

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
  region     = element(data.digitalocean_regions.available.regions, random_integer.region_number.result).slug
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
