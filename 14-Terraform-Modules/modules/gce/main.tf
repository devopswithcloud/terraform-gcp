resource "google_compute_instance" "vm" {
  name = var.vm_name
  machine_type = var.machine_type
  zone = var.zone
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }
  network_interface {
    subnetwork = var.subnet_id
    access_config {}
  } 
}


