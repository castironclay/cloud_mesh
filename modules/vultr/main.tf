resource "vultr_instance" "my_instance" {
  plan              = "vc2-1c-1gb"
  region            = "ord" # Chicago
  os_id             = "477" # Debian 11
  backups           = "disabled"
  hostname          = var.name
  activation_email  = false
  ddos_protection   = false
  ssh_key_ids       = [vultr_ssh_key.my_ssh_key.id]
  firewall_group_id = vultr_firewall_group.my_firewallgroup.id
}
resource "vultr_ssh_key" "my_ssh_key" {
  name    = var.name
  ssh_key = file("./id_ssh_rsa.pub")
}

resource "vultr_firewall_group" "my_firewallgroup" {
  description = var.name
}

resource "vultr_firewall_rule" "my_firewallrule" {
  firewall_group_id = vultr_firewall_group.my_firewallgroup.id
  protocol          = "tcp"
  ip_type           = "v4"
  subnet            = "0.0.0.0"
  subnet_size       = 0
  port              = "22"
  notes             = "Allow SSH"
}
