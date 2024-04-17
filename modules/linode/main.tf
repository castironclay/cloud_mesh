resource "linode_instance" "host" {
  region          = random_shuffle.regions.result[0]
  label           = var.linode_label
  image           = var.linode_image
  type            = var.linode_type
  authorized_keys = [linode_sshkey.host_key.ssh_key]
  depends_on      = [linode_sshkey.host_key]
  provisioner "remote-exec" {
    inline = ["echo 'Im alive!'"]

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file(var.private_keyname)
      host        = linode_instance.host.ip_address
    }
  }
}

resource "linode_sshkey" "host_key" {
  label   = var.key_name
  ssh_key = chomp(file(var.public_keyname))
}

resource "random_shuffle" "regions" {
  input = [
    "us-iad",       # Washington, DC
    "us-ord",       # Chicago, IL
    "ca-central",   # Toronto, CA
    "ap-southeast", # Sydney, AU
    "fr-par",       # Paris, FR
    "us-sea",       # Seattle, WA
    "br-gru",       # Sao Paulo, BR
    "nl-ams",       # Amsterdam, NL
    "se-sto",       # Stockholm, SE
    "es-mad",       # Madrid, ES
    "in-maa",       # Chennai, IN
    "jp-osa",       # Osaka, JP
    "it-mil",       # Milan, IT
    "us-mia",       # Miami, FL
    "id-cgk",       # Jakarta, ID
    "us-lax",       # Los Angeles, CA
    "us-central",   # Dallas, TX
    "us-west",      # Fremont, CA
    "us-southeast", # Atlanta, GA
    "us-east",      # Newark, NJ
    "eu-west",      # London, UK
    "ap-south",     # Singapore, SG
    "eu-central",   # Frankfurt, DE
    "ap-northeast"  # Tokyo, JP
  ]
  result_count = 1
}
