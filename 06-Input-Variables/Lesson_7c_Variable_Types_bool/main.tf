provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_network" "tf_vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "tf_subnet" {
  name          = var.subnet_name
  region        = var.region
  ip_cidr_range = var.subnet_cidr
  network       = google_compute_network.tf_vpc.id
}

resource "google_compute_firewall" "tf_ssh" {
  name          = "i27-allow-ssh"
  network       = google_compute_network.tf_vpc.id
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["i27-ssh-network-tag"]
}

resource "google_compute_firewall" "tf_http" {
  name          = "i27-allow-http"
  network       = google_compute_network.tf_vpc.id
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["i27-webserver-network-tag"]
}

resource "google_compute_instance" "tf_gce_vm" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.tf_subnet.id
    access_config {}
  }

  metadata_startup_script = var.enable_startup_script ? file("${path.module}/startup.sh") : null

  tags = ["i27-ssh-network-tag", "i27-webserver-network-tag"]
}