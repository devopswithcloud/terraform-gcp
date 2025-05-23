provider "google" {
  project = var.project_id
  region  = var.region_1
}

# VPC
resource "google_compute_network" "custom_vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

# Subnet in us-central1
resource "google_compute_subnetwork" "subnet_us" {
  name          = "${var.vpc_name}-subnet-us"
  ip_cidr_range = var.subnet_1_cidr
  region        = var.region_1
  network       = google_compute_network.custom_vpc.id
}

# Subnet in asia-southeast1
resource "google_compute_subnetwork" "subnet_asia" {
  name          = "${var.vpc_name}-subnet-asia"
  ip_cidr_range = var.subnet_2_cidr
  region        = var.region_2
  network       = google_compute_network.custom_vpc.id
}

# Reserve a static external IP
resource "google_compute_address" "static_ip" {
  name   = "${var.vm_name}-ip"
  region = var.region_1
}

# Firewall for HTTP and SSH
resource "google_compute_firewall" "allow_http_ssh" {
  name    = "${var.vpc_name}-allow-http-ssh"
  network = google_compute_network.custom_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web"]
}

# VM Instance
resource "google_compute_instance" "vm_instance" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = "${var.region_1}-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork   = google_compute_subnetwork.subnet_us.name
    access_config {
      nat_ip = google_compute_address.static_ip.address
    }
  }

  metadata_startup_script = var.enable_startup_script ? file("${path.module}/startup.sh") : null

  tags = ["web"]
}