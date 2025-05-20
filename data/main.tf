terraform {
  required_providers {
    google = {
        source = "hashicorp/google"
        version = "5.42.0"
    }
  }
}


provider "google" {
  project = var.project
  region = var.region
}


variable "project" {
  type = string
  default = "***********************"
}

variable "region" {
  type = string
  default = "us-central1"
}


resource "google_compute_network" "tf_vpc" {
  name = "tf-vpc"
  auto_create_subnetworks = false
}


resource "google_compute_subnetwork" "tf_subnet" {
  name = "tf-subnet"
  ip_cidr_range = "10.4.0.0/16"
  region = var.region
  network = google_compute_network.tf_vpc.id
}



data "google_compute_zones" "available_zones" {
    region = var.region
}


# Create 2 vms across us-central1 region
resource "google_compute_instance" "web_server_instance" {
  count = 2
  name = "web-server-instance-${count.index + 1}"
  machine_type = "e2-medium"
  #zone = "us-central1-a"
  zone = data.google_compute_zones.available_zones.names[count.index]
  network_interface {
    subnetwork = google_compute_subnetwork.tf_subnet.self_link
    access_config {
      
    }
  }
  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-minimal-2204-jammy-v20250424"
    }
  }
}


output "web_server_ips" {
  description = "The External ip addresses of the webserver instances"
  value = [
    for instance in google_compute_instance.web_server_instance :
        instance.network_interface[0].access_config[0].nat_ip
  ]
}
