data "google_compute_image" "ubuntu_image" {
  family  = "debian-11"
  project = "debian-cloud"
}

resource "google_compute_instance" "host" {
  machine_type = "e2-micro"
  name         = var.name
  zone         = random_shuffle.regions.result[0]
  boot_disk {
    auto_delete = ture
    initialize_params {
      image = data.google_compute_image.ubuntu_image.self_link
    }
    mode = "READ_WRITE"
  }
  network_interface {
    network = "default"
    access_config {}
  }
  provisioner "remote-exec" {
    inline = ["echo 'Im alive!'"]

    connection {
      type        = "ssh"
      user        = "admin"
      private_key = file(var.private_keyname)
      host        = google_compute_instance.host.network_interface.0.access_config.0.nat_ip
    }
  }
  metadata = {
    ssh-keys = "admin:${file(var.public_keyname)}"
  }
}

resource "google_compute_firewall" "egress" {
  name          = "${var.name}-egress"
  network       = "default"
  source_ranges = ["0.0.0.0/0"]
  direction     = "EGRESS"

  allow {
    protocol = "all"
  }
}

resource "google_compute_firewall" "ingress" {
  name          = "${var.name}-ingress"
  network       = "default"
  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"

  allow {
    protocol = "all"
  }
}
resource "random_shuffle" "regions" {
  input = [
    "europe-north1-a",           # Hamina, Finland, Europe
    "europe-north1-b",           # Hamina, Finland, Europe
    "europe-north1-c",           # Hamina, Finland, Europe
    "europe-central2-a",         # Warsaw, Poland, Europe
    "europe-central2-b",         # Warsaw, Poland, Europe
    "europe-central2-c",         # Warsaw, Poland, Europe
    "europe-southwest1-a",       # Madrid, Spain, Europe
    "europe-southwest1-b",       # Madrid, Spain, Europe
    "europe-southwest1-c",       # Madrid, Spain, Europe
    "europe-west1-b",            # St. Ghislain, Belgium, Europe
    "europe-west1-c",            # St. Ghislain, Belgium, Europe
    "europe-west1-d",            # St. Ghislain, Belgium, Europe
    "europe-west2-a",            # London, England, Europe
    "europe-west2-b",            # London, England, Europe
    "europe-west2-c",            # London, England, Europe
    "europe-west3-a",            # Frankfurt, Germany, Europe
    "europe-west3-b",            # Frankfurt, Germany, Europe
    "europe-west3-c",            # Frankfurt, Germany, Europe
    "europe-west4-a",            # Eemshaven, Netherlands, Europe
    "europe-west4-b",            # Eemshaven, Netherlands, Europe
    "europe-west4-c",            # Eemshaven, Netherlands, Europe
    "europe-west6-a",            # Zurich, Switzerland, Europe
    "europe-west6-b",            # Zurich, Switzerland, Europe
    "europe-west6-c",            # Zurich, Switzerland, Europe
    "europe-west8-a",            # Milan, Italy, Europe
    "europe-west8-b",            # Milan, Italy, Europe
    "europe-west8-c",            # Milan, Italy, Europe
    "europe-west9-a",            # Paris, France, Europe
    "europe-west9-b",            # Paris, France, Europe
    "europe-west9-c",            # Paris, France, Europe
    "europe-west10-a",           # Berlin, Germany, Europe
    "europe-west10-b",           # Berlin, Germany, Europe
    "europe-west10-c",           # Berlin, Germany, Europe
    "europe-west12-a",           # Turin, Italy, Europe
    "europe-west12-b",           # Turin, Italy, Europe
    "europe-west12-c",           # Turin, Italy, Europe
    "northamerica-northeast1-a", # Montréal, Québec, North America
    "northamerica-northeast1-b", # Montréal, Québec, North America
    "northamerica-northeast1-c", # Montréal, Québec, North America
    "northamerica-northeast2-a", # Toronto, Ontario, North America
    "northamerica-northeast2-b", # Toronto, Ontario, North America
    "northamerica-northeast2-c", # Toronto, Ontario, North America
    "us-central1-a",             # Council Bluffs, Iowa, North America
    "us-central1-b",             # Council Bluffs, Iowa, North America
    "us-central1-c",             # Council Bluffs, Iowa, North America
    "us-central1-f",             # Council Bluffs, Iowa, North America
    "us-east1-b",                # Moncks Corner, South Carolina, North America
    "us-east1-c",                # Moncks Corner, South Carolina, North America
    "us-east1-d",                # Moncks Corner, South Carolina, North America
    "us-east4-a",                # Ashburn, Virginia, North America
    "us-east4-b",                # Ashburn, Virginia, North America
    "us-east4-c",                # Ashburn, Virginia, North America
    "us-east5-a",                # Columbus, Ohio, North America
    "us-east5-b",                # Columbus, Ohio, North America
    "us-east5-c",                # Columbus, Ohio, North America
    "us-west1-a",                # The Dalles, Oregon, North America
    "us-west1-b",                # The Dalles, Oregon, North America
    "us-west1-c",                # The Dalles, Oregon, North America
    "us-west2-a",                # Los Angeles, California, North America
    "us-west2-b",                # Los Angeles, California, North America
    "us-west2-c",                # Los Angeles, California, North America
    "us-west3-a",                # Salt Lake City, Utah, North America
    "us-west3-b",                # Salt Lake City, Utah, North America
    "us-west3-c",                # Salt Lake City, Utah, North America
    "us-west4-a",                # Las Vegas, Nevada, North America
    "us-west4-b",                # Las Vegas, Nevada, North America
    "us-west4-c",                # Las Vegas, Nevada, North America
    "us-south1-a",               # Dallas, Texas, North America
    "us-south1-b",               # Dallas, Texas, North America
    "us-south1-c",               # 
  ]
  result_count = 1
}

