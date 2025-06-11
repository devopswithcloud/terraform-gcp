# Try this example after count meta argument

 # ************************************************************************** Advanced **********************************************
 # Provider Block 
provider "google" { 
  region = "us-central"
  project = "silver-tempo-455118-a5"
}


# VPC:
resource "google_compute_network" "tf_vpc" {
  name = "i27-for-vpc"
  auto_create_subnetworks = false
}

# create a subnet 
resource "google_compute_subnetwork" "tf_subnet" {
  name = "i27-for-subnet"
  region = "us-central1"
  ip_cidr_range = "10.4.0.0/16"
  network = google_compute_network.tf_vpc.id
}


variable "vm_name" {
  type = string
  default = "i27-webserver"
}

variable "machine_type" {
  type = string 
  default = "e2-medium"
}

variable "instance_count" {
  type = number
  default = 2
}
resource "google_compute_instance" "tf_gce_vm" {
  count = var.instance_count
  name = "${var.vm_name}-${count.index}"
  machine_type = var.machine_type
  zone = "us-central1-a"
  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20250415"
    }
  }
  network_interface {
    subnetwork = "default "
    access_config {
      // ephemeral ip
    }
  }
}

# advance o/p using for 
# For loop to get all vm names in a list 
output "all_vm_names_list" {
  description = "List of all the VM names"
  value = [for instance in google_compute_instance.tf_gce_vm : instance.name]
}

# For loop to create a map of VM names and there ids
# {for item in list : key => value}
output "vm_name_to_id" {
  value = {
    for instance in google_compute_instance.tf_gce_vm : instance.name => instance.id
  }
}

# Output a complex map of instance details
output "instance_details" {
  description = "A complex map of details for each GCE instance"
  value = {
    for instance in google_compute_instance.tf_gce_vm : instance.name => {
        id = instance.id 
        machine_type = instance.machine_type
        zone = instance.zone
        external_ip = instance.network_interface[0].access_config[0].nat_ip # attributes 
    }
  }
}
