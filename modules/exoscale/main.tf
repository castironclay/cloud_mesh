data "exoscale_template" "my_template" {
  zone = element(data.exoscale_zones.example_zones.zones, random_integer.zone.result)
  name = "Linux Debian 12 (Bookworm) 64-bit"
}

resource "exoscale_compute_instance" "my_instance" {
  depends_on         = [data.exoscale_template.my_template]
  zone               = element(data.exoscale_zones.example_zones.zones, random_integer.zone.result)
  name               = var.name
  template_id        = data.exoscale_template.my_template.id
  type               = "standard.medium"
  disk_size          = 10
  ssh_key            = exoscale_ssh_key.my_ssh_key.name
  security_group_ids = [exoscale_security_group.my_security_group.id]
  provisioner "remote-exec" {
    inline = ["echo 'Im alive!'"]

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file(var.private_keyname)
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
  depends_on        = [exoscale_security_group.my_security_group]
}

resource "exoscale_ssh_key" "my_ssh_key" {
  name       = var.name
  public_key = file(var.public_keyname)
}

data "exoscale_zones" "example_zones" {}


resource "random_integer" "zone" {
  depends_on = [data.exoscale_zones.example_zones]
  min        = 1
  max        = length(data.exoscale_zones.example_zones.zones)
}
