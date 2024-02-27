resource "linode_instance" "host" {
  region          = var.linode_region
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
      private_key = file("./id_ssh_rsa")
      host        = linode_instance.host.ip_address
    }
  }
}

resource "linode_sshkey" "host_key" {
  label   = var.key_name
  ssh_key = chomp(file("./id_ssh_rsa.pub"))
}

