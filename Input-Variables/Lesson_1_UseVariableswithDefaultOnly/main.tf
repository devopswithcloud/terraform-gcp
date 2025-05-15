provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_instance" "example_vm" {
  name         = "default-vm"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}


