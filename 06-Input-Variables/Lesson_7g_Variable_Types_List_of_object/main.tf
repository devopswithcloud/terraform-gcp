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

resource "google_compute_instance" "vm1" {
  name         = var.vm_list[0].name
  machine_type = var.vm_list[0].machine_type
  zone         = var.vm_list[0].zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.tf_subnet.id
    access_config {}
  }

  tags = var.vm_list[0].tags
}

resource "google_compute_instance" "vm2" {
  name         = var.vm_list[1].name
  machine_type = var.vm_list[1].machine_type
  zone         = var.vm_list[1].zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.tf_subnet.id
    access_config {}
  }

  tags = var.vm_list[1].tags
}