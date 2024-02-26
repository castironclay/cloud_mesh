provider "google" {
  project = var.GOOGLE_PROJECT
}

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
    # Blank access_config = ephemeral IP not static
    access_config {}
  }
  provisioner "remote-exec" {
    inline = ["echo 'Im alive!'"]

    connection {
      type        = "ssh"
      user        = var.gce_user
      private_key = file("./id_rsa")
      host        = google_compute_instance.host.network_interface.0.access_config.0.nat_ip
    }
  }
  metadata = {
    ssh-keys = "${var.gce_user}:${file("./id_rsa.pub")}"
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
