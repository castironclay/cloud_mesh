data "exoscale_template" "my_template" {
  zone = random_shuffle.regions.result[0]
  name = "Linux Debian 12 (Bookworm) 64-bit"
}

resource "exoscale_compute_instance" "my_instance" {
  depends_on         = [data.exoscale_template.my_template, exoscale_ssh_key.my_ssh_key]
  zone               = random_shuffle.regions.result[0]
  name               = var.name
  template_id        = data.exoscale_template.my_template.id
  type               = "standard.medium"
  disk_size          = 10
  ssh_key            = exoscale_ssh_key.my_ssh_key.name
  security_group_ids = [exoscale_security_group.security_group.id]
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

resource "exoscale_security_group" "security_group" {
  name = var.name
}

resource "exoscale_security_group_rule" "security_group_rule_tcp" {
  security_group_id = exoscale_security_group.security_group.id
  type              = "INGRESS"
  protocol          = "TCP"
  cidr              = "0.0.0.0/0"
  start_port        = 1
  end_port          = 65535
}

resource "exoscale_security_group_rule" "security_group_rule_udp" {
  security_group_id = exoscale_security_group.security_group.id
  type              = "INGRESS"
  protocol          = "UDP"
  cidr              = "0.0.0.0/0"
  start_port        = 1
  end_port          = 65535
}

resource "exoscale_ssh_key" "my_ssh_key" {
  name       = var.name
  public_key = file(var.public_keyname)
}

resource "random_shuffle" "regions" {
  input = [
    "de-fra-1", # DE-FRA-1 - Frankfurt, Germany
    "de-muc-1", # DE-MUC-1 - Munich, Germany
    "at-vie-1", # AT-VIE-1 - Vienna, Austria
    "at-vie-2", # AT-VIE-2 - Vienna, Austria
    "ch-gva-2", # CH-GVA-2 - Geneva, Switzerland
    "ch-dk-2",  # CH-DK-2 - Zurich, Switzerland
    "bg-sof-1", # BG-SOF-1 - Sofia, Bulgaria
  ]
  result_count = 1
}

