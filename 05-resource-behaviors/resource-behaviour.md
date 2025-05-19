# Terraform Resource Behavior with Complete Infrastructure Setup

* This document provides examples of Terraform resource behavior, including creating, updating in place, stopping to update, destroying and recreating, and fully destroying resources. 
* Each example includes a full infrastructure setup with a VPC, subnet, firewall, and Google Compute Engine instance to ensure the infrastructure is self-contained and can be cleanly destroyed after each example.

## Scope
  * `Creation`: Demonstrates creating a complete infrastructure (VPC, subnet, firewall, GCE instance).
  * `Update in Place`: Shows how to update existing resources (e.g., tags on an instance) without destroying them.
  * `Stop and Update`: Illustrates stopping an instance to update its machine type.
  * `Destroy and Recreate`: Covers scenarios requiring the destruction and recreation of resources (e.g., changing zones).
  * `Destruction`: Explains how to destroy the entire infrastructure cleanly.

---

## Example 1: Create a Resource

This example creates a complete infrastructure, including a VPC, subnet, firewall rule, and a Google Compute Engine instance.

```hcl
```hcl
provider "google" {
  project = "mention-your-project-id"
  region  = "us-central1"
}

resource "google_compute_network" "tf_vpc" {
  name                    = "i27-vpc"
  auto_create_subnetworks = false
  description             = "Creating a VPC from terraform"
}

resource "google_compute_subnetwork" "tf_subnet" {
  name          = "i27-subnet"
  region        = "us-central1"
  ip_cidr_range = "10.6.0.0/16"
  network       = google_compute_network.tf_vpc.id
}

resource "google_compute_firewall" "tf_ssh" {
  name    = "i27-allow-ssh-22"
  network = google_compute_network.tf_vpc.id
  direction = "INGRESS"
  priority  = 1000
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["i27-ssh-network-tag", "i27-ssh-network-tag-other"]
}

resource "google_compute_firewall" "tf_http" {
  name    = "fwrule-allow-http80"
  network = google_compute_network.tf_vpc.id
  direction = "INGRESS"
  priority  = 1000
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["i27-webserver-network-tag"]
}

resource "google_compute_instance" "tf_gce_vm" {
  name         = "i27-webserver"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork    = google_compute_subnetwork.tf_subnet.id
    access_config {}
  }

  metadata_startup_script = file("${path.module}/startup.sh")

  tags = [
    tolist(google_compute_firewall.tf_ssh.target_tags)[1],
    tolist(google_compute_firewall.tf_http.target_tags)[0],
    tolist(google_compute_firewall.tf_ssh.target_tags)[0]
  ]
}
```

## Example 2: Update in Place
This example demonstrates `updating the tags` on the instance, which can be done in place without destroying the resource.
```hcl
resource "google_compute_instance" "tf_gce_vm" {
  name         = "i27-webserver"
  machine_type = "e2-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork    = google_compute_subnetwork.tf_subnet.id
    access_config {}
  }

  metadata_startup_script = file("${path.module}/startup.sh")

  # Adding an additional tag
  tags = [
    tolist(google_compute_firewall.tf_ssh.target_tags)[1],
    tolist(google_compute_firewall.tf_http.target_tags)[0],
    tolist(google_compute_firewall.tf_ssh.target_tags)[0],
    "i27-extra-tag"
  ]
}
```
* `Behavior`: Running terraform apply will update the instance tags in place without replacing the VM.

## Example 3: Stop and Update with `allow_stopping_for_update`
* This example changes the machine type of the instance. By setting  `allow_stopping_for_update = true`, Terraform will stop the instance and update it in place instead of destroying it.
```hcl
resource "google_compute_instance" "tf_gce_vm" {
  name         = "i27-webserver"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork    = google_compute_subnetwork.tf_subnet.id
    access_config {}
  }

  metadata_startup_script = file("${path.module}/startup.sh")
  allow_stopping_for_update = true

  tags = [
    tolist(google_compute_firewall.tf_ssh.target_tags)[1],
    tolist(google_compute_firewall.tf_http.target_tags)[0],
    tolist(google_compute_firewall.tf_ssh.target_tags)[0]
  ]
}


```
* `Behavior`: Running terraform apply will stop the instance and update the machine type without recreating it.

## Example 4: Destroy and Recreate a Resource
* This example changes the zone, which requires Terraform to destroy and recreate the instance in the new zone.
```hcl
resource "google_compute_instance" "tf_gce_vm" {
  name         = "i27-webserver"
  machine_type = "e2-medium"
  zone         = "us-central1-b"  # Changed from us-central1-a

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork    = google_compute_subnetwork.tf_subnet.id
    access_config {}
  }

  metadata_startup_script = file("${path.module}/startup.sh")

  tags = [
    tolist(google_compute_firewall.tf_ssh.target_tags)[1],
    tolist(google_compute_firewall.tf_http.target_tags)[0],
    tolist(google_compute_firewall.tf_ssh.target_tags)[0]
  ]
}


```
* `Behavior`: Running terraform apply will destroy the instance in us-central1-a and create a new instance in us-central1-b.

## Example 5: Destroy all Resources
* You can destroy the entire infrastructure using the following command:
```bash
terraform destroy
```
* `Behaviour`: This command will remove all resources created in the previous examples, including the VPC, subnet, firewall rule, and instance.