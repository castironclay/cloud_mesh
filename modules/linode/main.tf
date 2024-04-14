data "linode_regions" "filtered-regions" {
  filter {
    name   = "status"
    values = ["ok"]
  }

  filter {
    name   = "capabilities"
    values = ["Linodes"]
  }
}

resource "random_integer" "region_number" {
  depends_on = [data.linode_regions.filtered-regions]
  min        = 1
  max        = length(data.linode_regions.filtered-regions.regions)
}

resource "linode_instance" "host" {
  region          = element(data.linode_regions.filtered-regions.regions, random_integer.region_number.result).id
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
