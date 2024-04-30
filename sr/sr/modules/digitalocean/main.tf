resource "digitalocean_droplet" "droplet" {
  depends_on = [digitalocean_ssh_key.key]
  name       = var.name
  size       = "s-1vcpu-1gb"
  image      = "debian-12-x64"
  region     = random_shuffle.regions.result[0]
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

resource "random_shuffle" "regions" {
  input = [
    "nyc1", # NYC1 - New York City, United States
    "nyc3", # NYC3 - New York City, United States
    "ams3", # AMS3 - Amsterdam, the Netherlands
    "sfo2", # SFO2 - San Francisco, United States
    "sfo3", # SFO3 - San Francisco, United States
    "sgp1", # SGP1 - Singapore
    "lon1", # LON1 - London, United Kingdom
    "fra1", # FRA1 - Frankfurt, Germany
    "tor1", # TOR1 - Toronto, Canada
    "blr1", # BLR1 - Bangalore, India
    "syd1", # SYD1 - Sydney, Australia
  ]
  result_count = 1
}

