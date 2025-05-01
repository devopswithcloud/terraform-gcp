# Create a Google VPC
resource "google_compute_network" "tf_vpc" {
  # The name of the VPC network
  name = "i27-vpc"

  # Setting to false to manually define subnetworks instead of automatically creating them
  auto_create_subnetworks = false

  # Description of the VPC network, helpful for identification
  description = "Creating a VPC from terraform"
}

# Create a Subnet
resource "google_compute_subnetwork" "tf_subnet" {
  # The name of the subnet
  name = "i27-subnet"

  # The region where the subnet will be created
  region = "us-central1"

  # The IP range for the subnet, defined in CIDR notation
  ip_cidr_range = "10.6.0.0/16"

  # Associate this subnet with the VPC network created above
  network = google_compute_network.tf_vpc.id
  # Syntax: resource_type.resourcelocal_name.attribute
  # This creates an implicit dependency — no need to write `depends_on`.
}
