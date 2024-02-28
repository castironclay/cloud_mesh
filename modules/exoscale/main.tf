data "exoscale_template" "my_template" {
  zone = "ch-gva-2"
  name = "Linux Ubuntu 22.04 LTS 64-bit"
}

resource "exoscale_compute_instance" "my_instance" {
  zone = "ch-gva-2"
  name = var.name

  template_id = data.exoscale_template.my_template.id
  type        = "standard.medium"
  disk_size   = 10
  ssh_key     = exoscale_ssh_key.my_ssh_key.name
  provisioner "remote-exec" {
    inline = ["echo 'Im alive!'"]

    connection {
      type        = "ssh"
      user        = "admin"
      private_key = file("./id_ssh_rsa")
      host        = exoscale_compute_instance.my_instance.public_ip_address
    }
  }

}

resource "exoscale_security_group" "my_security_group" {
  name = var.name
}

resource "exoscale_security_group_rule" "my_security_group_rule" {
  security_group_id = exoscale_security_group.my_security_group.id
  type              = "INGRESS"
  protocol          = "TCP"
  cidr              = "0.0.0.0/0"
  start_port        = 22
  end_port          = 22
}

resource "exoscale_ssh_key" "my_ssh_key" {
  name       = var.name
  public_key = file("./id_ssh_rsa.pub")
}

