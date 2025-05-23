# Terraform configuration block
terraform {
  required_version = ">= 1.9.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.42.0"
    }
  }
}

# Provider configuration for Google Cloud
provider "google" {
  project = var.project_id
  region  = var.region
}

#-------------------------------
# VPC 1 Configuration
#-------------------------------

# VPC 1
resource "google_compute_network" "vpc1" {
  name                    = "vpc-network-1"
  auto_create_subnetworks = false
  description             = "First VPC network"
}

# Subnet for VPC 1
resource "google_compute_subnetwork" "subnet_vpc1" {
  name          = "subnet-vpc1"
  region        = var.region
  ip_cidr_range = "10.0.0.0/16"
  network       = google_compute_network.vpc1.self_link
}

# Firewall rule for VPC 1 to allow SSH
resource "google_compute_firewall" "firewall_vpc1_ssh" {
  name    = "firewall-vpc1-allow-ssh"
  network = google_compute_network.vpc1.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Firewall rule for VPC 1 to allow HTTP
resource "google_compute_firewall" "firewall_vpc1_http" {
  name    = "firewall-vpc1-allow-http"
  network = google_compute_network.vpc1.self_link

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Firewall rule for VPC 1 to allow ICMP
resource "google_compute_firewall" "firewall_vpc1_icmp" {
  name    = "firewall-vpc1-allow-icmp"
  network = google_compute_network.vpc1.self_link

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
}


# Create a VM instance in VPC 1
resource "google_compute_instance" "vm_instance_vpc1" {
  name         = "vm-instance-vpc1"
  machine_type = "e2-micro"
  zone         = "us-central1-a"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }
  network_interface {
    network = google_compute_network.vpc1.self_link
    subnetwork = google_compute_subnetwork.subnet_vpc1.self_link
    access_config {
        // Ephemeral IP
    }
  }
  
}

#-------------------------------
# VPC 2 Configuration
#-------------------------------

# VPC 2
resource "google_compute_network" "vpc2" {
  name                    = "vpc-network-2"
  auto_create_subnetworks = false
  description             = "Second VPC network"
}

# Subnet for VPC 2
resource "google_compute_subnetwork" "subnet_vpc2" {
  name          = "subnet-vpc2"
  region        = var.region
  ip_cidr_range = "10.1.0.0/16"
  network       = google_compute_network.vpc2.self_link
}

# Firewall rule for VPC 2 to allow SSH
resource "google_compute_firewall" "firewall_vpc2_ssh" {
  name    = "firewall-vpc2-allow-ssh"
  network = google_compute_network.vpc2.self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Firewall rule for VPC 2 to allow HTTP
resource "google_compute_firewall" "firewall_vpc2_http" {
  name    = "firewall-vpc2-allow-http"
  network = google_compute_network.vpc2.self_link

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# firewall rule for VPC 2 to allow ICMP
resource "google_compute_firewall" "firewall_vpc2_icmp" {
  name    = "firewall-vpc2-allow-icmp"
  network = google_compute_network.vpc2.self_link

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
}

# Create a VM instance in VPC 2

resource "google_compute_instance" "vm_instance_vpc2" {
  name         = "vm-instance-vpc2"
  machine_type = "e2-micro"
  zone         = "us-central1-a"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }
  network_interface {
    network = google_compute_network.vpc2.self_link
    subnetwork = google_compute_subnetwork.subnet_vpc2.self_link
    access_config {
        // Ephemeral IP
    }
  }
}

#-------------------------------
# VPC Peering Configuration
#-------------------------------

# VPC Peering request from VPC 1 to VPC 2
resource "google_compute_network_peering" "vpc1_to_vpc2" {
  name    = "vpc1-to-vpc2-peering"
  network = google_compute_network.vpc1.self_link
  peer_network = google_compute_network.vpc2.self_link
}

# VPC Peering request from VPC 2 to VPC 1
resource "google_compute_network_peering" "vpc2_to_vpc1" {
  name    = "vpc2-to-vpc1-peering"
  network = google_compute_network.vpc2.self_link
  peer_network = google_compute_network.vpc1.self_link
}