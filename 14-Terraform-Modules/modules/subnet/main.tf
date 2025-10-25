resource "google_compute_subnetwork" "subnet" {
  name = var.subnet_name
  region = var.region
  ip_cidr_range = var.subnet_cidr
  network = var.vpc_id
}


