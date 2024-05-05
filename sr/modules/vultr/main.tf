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
    "ams", # Amsterdam, Netherlands
    "atl", # Atlanta, United States
    "blr", # Bangalore, India
    "bom", # Mumbai, India
    "cdg", # Paris, France
    "del", # Delhi, India
    "dfw", # Dallas/Fort Worth, United States
    "ewr", # Newark, United States
    "fra", # Frankfurt, Germany
    "hnl", # Honolulu, United States
    "icn", # Seoul, South Korea
    "itm", # Osaka, Japan
    "jnb", # Johannesburg, South Africa
    "lax", # Los Angeles, United States
    "lhr", # London Heathrow, United Kingdom
    "mad", # Madrid, Spain
    "man", # Manchester, United Kingdom
    "mel", # Melbourne, Australia
    "mex", # Mexico City, Mexico
    "mia", # Miami, United States
    "nrt", # Tokyo Narita, Japan
    "ord", # Chicago O'Hare, United States
    "sao", # São Paulo, Brazil
    "scl", # Santiago, Chile
    "sea", # Seattle, United States
    "sgp", # Singapore
    "sjc", # San Jose, United States
    "sto", # Stockholm, Sweden
    "syd", # Sydney, Australia
    "tlv", # Tel Aviv, Israel
    "waw", # Warsaw, Poland
    "yto", # Toronto, Canada
  ]
  result_count = 1
}

