
provider "google" {
  project = "silver-tempo-455118-a5"
  region  = "us-central1"
}

# Example 1: Create VPC (basic infrastructure creation)
resource "google_compute_network" "tf_vpc" {
  name                    = "i27-vpc"
  auto_create_subnetworks = false
  description             = "Creating a VPC from terraform"
}

# Create Subnet
resource "google_compute_subnetwork" "tf_subnet" {
  name          = "i27-subnet"
  region        = "us-central1"
  ip_cidr_range = "10.6.0.0/16"
  network       = google_compute_network.tf_vpc.id
}

# Create SSH Firewall Rule
resource "google_compute_firewall" "tf_ssh" {
  name          = "i27-allow-ssh-22"
  network       = google_compute_network.tf_vpc.id
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags = ["i27-ssh-network-tag", "i27-ssh-network-tag-other"]
}

# Create HTTP Firewall Rule
resource "google_compute_firewall" "tf_http" {
  name          = "fwrule-allow-http80"
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

# Optional: Create Static IP for the instance
resource "google_compute_address" "tf_static_ip" {
  name = "i27-webserver-ip"
}

# Example 2/3/4: Create VM instance with different conditions
resource "google_compute_instance" "tf_gce_vm" {
  name         = "i27-webserver"
  #machine_type = "e2-micro"     
  #machine_type = "e2-medium"    
  machine_type = "e2-medium"     
  zone         = "us-central1-b" # Changed zone triggers destroy & recreate

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.tf_subnet.id
    access_config {
      nat_ip = google_compute_address.tf_static_ip.address  # Attach static IP
    }
  }

  metadata_startup_script = file("${path.module}/startup.sh")

  tags = [
    tolist(google_compute_firewall.tf_ssh.target_tags)[1],
    tolist(google_compute_firewall.tf_http.target_tags)[0],
    tolist(google_compute_firewall.tf_ssh.target_tags)[0],
    "i27-extra-tag"  # For Example 2: Update in Place
  ]

  allow_stopping_for_update = true  # Required for in-place machine_type changes
}


