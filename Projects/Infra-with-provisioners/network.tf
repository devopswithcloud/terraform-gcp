# Create a vpc 
resource "google_compute_network" "vpc_network" {
  name = var.vpc_name
  auto_create_subnetworks = false
}

# Create Multiple subnets 
resource "google_compute_subnetwork" "i27-ecommerce-subnets" {
    count = length(var.subnets)
  name = var.subnets[count.index].name
  ip_cidr_range = var.subnets[count.index].ip_cidr_range
  region = var.subnets[count.index].subnet_region
  network = google_compute_network.vpc_network.self_link
}


# Create Firewall Rules
resource "google_compute_firewall" "i27-ecommerce-firewalls" {
  name = var.firewall_name
  network = google_compute_network.vpc_network.self_link
  allow {
    protocol = "tcp"
    ports = ["80", "8080", "22", "9000"]
  }
  #source_ranges = ["0.0.0.0/0", "32.34.56.23/32"]
 source_ranges = var.source_ranges
}





