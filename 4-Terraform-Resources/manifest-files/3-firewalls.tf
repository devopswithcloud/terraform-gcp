# Create a firewall rule for opening SSH port
resource "google_compute_firewall" "tf_ssh" {
  # The name of the firewall rule
  name = "i27-allow-ssh-22"
  
  # Define the protocol and ports allowed by this rule
  allow {
    ports    = ["22"]        # Port 22 for SSH
    protocol = "tcp"         # TCP protocol
  }

  # The direction of traffic the rule applies to (INGRESS means incoming traffic, EGRESS means outgoing traffic)
  direction = "INGRESS"

  # Associate this firewall rule with the VPC network created earlier
  network = google_compute_network.tf_vpc.id

  # The priority of the rule; lower numbers indicate higher priority
  priority = 1000

  # The source IP ranges that are allowed to access; 0.0.0.0/0 means all IPs
  source_ranges = ["0.0.0.0/0"]

  # Target tags used to identify the instances this rule applies to
  target_tags = ["i27-ssh-network-tag", "i27-ssh-network-tag-other"]
}

# Create a firewall rule for opening HTTP port
resource "google_compute_firewall" "tf_http" {
  # The name of the firewall rule
  name = "fwrule-allow-http80"

  # Define the protocol and ports allowed by this rule
  allow {
    ports    = ["80"]        # Port 80 for HTTP
    protocol = "tcp"         # TCP protocol
  }

  # The direction of traffic the rule applies to (INGRESS means incoming traffic)
  direction = "INGRESS"

  # Associate this firewall rule with the VPC network created earlier
  network = google_compute_network.tf_vpc.id

  # The priority of the rule; lower numbers indicate higher priority
  priority = 1000

  # The source IP ranges that are allowed to access; 0.0.0.0/0 means all IPs
  source_ranges = ["0.0.0.0/0"]

  # Target tags used to identify the instances this rule applies to
  target_tags = ["i27-webserver-network-tag"]
}
