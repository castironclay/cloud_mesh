data "google_compute_image" "ubuntu_image" {
  family  = "debian-11"
  project = "debian-cloud"
}

resource "google_compute_instance" "host" {
  machine_type = var.type
  name         = var.name
  zone         = "us-east1-b"
  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu_image.self_link
    }
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
