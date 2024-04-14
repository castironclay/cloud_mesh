resource "vultr_instance" "my_instance" {
  plan             = "vc2-1c-1gb"
  region           = random_shuffle.regions.result[0]
  os_id            = "477" # Debian 11
  backups          = "disabled"
  hostname         = var.name
  label            = var.name
  activation_email = false
  ddos_protection  = false
  ssh_key_ids      = [vultr_ssh_key.my_ssh_key.id]
  provisioner "remote-exec" {
    inline = ["echo 'Im alive!'"]

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file(var.private_keyname)
      host        = vultr_instance.my_instance.main_ip
    }
  }
  depends_on = [vultr_ssh_key.my_ssh_key]
}
resource "vultr_ssh_key" "my_ssh_key" {
  name    = var.name
  ssh_key = file(var.public_keyname)
}

resource "random_shuffle" "regions" {
  input = [
    "ams",
    "atl",
    "blr",
    "bom",
    "cdg",
    "del",
    "dfw",
    "ewr",
    "fra",
    "hnl",
    "icn",
    "itm",
    "jnb",
    "lax",
    "lhr",
    "mad",
    "man",
    "mel",
    "mex",
    "mia",
    "nrt",
    "ord",
    "sao",
    "scl",
    "sea",
    "sgp",
    "sjc",
    "sto",
    "syd",
    "tlv",
    "waw",
    "yto"
  ]
  result_count = 1
}

