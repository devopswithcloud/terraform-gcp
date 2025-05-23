# Outputs to show the networks and subnets
output "vpc1_self_link" {
  description = "VPC 1 self link"
  value       = google_compute_network.vpc1.self_link
}

output "vpc2_self_link" {
  description = "VPC 2 self link"
  value       = google_compute_network.vpc2.self_link
}

output "vpc1_subnet_self_link" {
  description = "Subnet in VPC 1"
  value       = google_compute_subnetwork.subnet_vpc1.self_link
}

output "vpc2_subnet_self_link" {
  description = "Subnet in VPC 2"
  value       = google_compute_subnetwork.subnet_vpc2.self_link
}

output "vpc_peering_status" {
  description = "VPC peering status between VPC 1 and VPC 2"
  value       = [
    google_compute_network_peering.vpc1_to_vpc2.state,
    google_compute_network_peering.vpc2_to_vpc1.state
  ]
}
