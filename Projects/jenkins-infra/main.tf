provider "google" {
  project = var.project
  region  = var.region
  zone    = var.zone
}


resource "google_compute_network" "jenkins_net" {
  name                    = "jenkins-network"
  auto_create_subnetworks = false
}


resource "google_compute_subnetwork" "jenkins_subnet" {
  name          = "jenkins-subnet"
  ip_cidr_range = "10.10.0.0/24"
  region        = var.region
  network       = google_compute_network.jenkins_net.id
}


resource "google_compute_firewall" "jenkins_firewall" {
  name    = "jenkins-allow-ssh-http"
  network = google_compute_network.jenkins_net.name

  allow {
    protocol = "tcp"
    ports    = ["22", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["jenkins-master", "jenkins-slave"]
}


# Create a ssh keypair, combination of public and private key
resource "tls_private_key" "i27-ecommerce-key" {
  algorithm = "RSA"
  rsa_bits = "4096"
}

# Save the private key to local file 
resource "local_file" "i27-ecommerce-key-private" {
  content = tls_private_key.i27-ecommerce-key.private_key_pem
  filename = "${path.module}/id_rsa"
}

# Save the Public key to local file 
resource "local_file" "i27-ecommerce-key-public" {
  content = tls_private_key.i27-ecommerce-key.public_key_openssh
  filename = "${path.module}/id_rsa.pub"
}


locals {
  instances = {
    jenkins-master = {
      tags = ["jenkins-master"]
      script = "${path.module}/jenkins-master.sh"
    }
    jenkins-slave = {
      tags = ["jenkins-slave"]
      script = "${path.module}/jenkins-slave.sh"
    }
  }
}

resource "google_compute_instance" "jenkins_vm" {
  for_each     = local.instances
  name         = each.key
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-minimal-2204-jammy-v20250606"
    }
  }

  network_interface {
    network    = google_compute_network.jenkins_net.id
    subnetwork = google_compute_subnetwork.jenkins_subnet.id
    access_config {}
  }
  metadata = {
    ssh-keys = "${var.vm_user}:${tls_private_key.i27-ecommerce-key.public_key_openssh}"
  }
  connection {
    host = self.network_interface[0].access_config[0].nat_ip
    type = "ssh" # "winrm"
    user = var.vm_user
    private_key = tls_private_key.i27-ecommerce-key.private_key_pem
    #password = 
  }

  provisioner "remote-exec" {
    inline = [ 
        each.key == "jenkins-slave" ? "mkdir -p /home/${var.vm_user}/jenkins" : "echo 'Not an slave vm'"
     ]
  }
  metadata_startup_script = file(each.value.script)
  tags                    = each.value.tags
  
}

