
# Terraform Variables – Type: `number`

This example demonstrates how to use the `number` variable type in Terraform without using meta-arguments like `count` or `for_each`. We'll apply it to control the **priority** of firewall rules in a GCP infrastructure.

## Why `number`?

In Terraform, use `number` when:
- You need integer-based values (like `priority`, `size`, or `port`)
- You want clear numeric control over resource configuration

## File: `variables.tf`

```hcl
variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  default     = "us-central1"
}

variable "zone" {
  type        = string
  default     = "us-central1-a"
}

variable "vpc_name" {
  type        = string
  default     = "i27-vpc"
}

variable "subnet_name" {
  type        = string
  default     = "i27-subnet"
}

variable "subnet_cidr" {
  type        = string
  default     = "10.6.0.0/16"
}

variable "vm_name" {
  type        = string
  default     = "i27-webserver"
}

variable "machine_type" {
  type        = string
  default     = "e2-micro"
}

variable "ssh_priority" {
  type        = number
  description = "Priority for SSH firewall rule"
  default     = 1000
}

variable "http_priority" {
  type        = number
  description = "Priority for HTTP firewall rule"
  default     = 1000
}
```

---

## `main.tf`

```hcl
provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_network" "tf_vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "tf_subnet" {
  name          = var.subnet_name
  region        = var.region
  ip_cidr_range = var.subnet_cidr
  network       = google_compute_network.tf_vpc.id
}

resource "google_compute_firewall" "tf_ssh" {
  name          = "i27-allow-ssh"
  network       = google_compute_network.tf_vpc.id
  direction     = "INGRESS"
  priority      = var.ssh_priority
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["i27-ssh-network-tag"]
}

resource "google_compute_firewall" "tf_http" {
  name          = "i27-allow-http"
  network       = google_compute_network.tf_vpc.id
  direction     = "INGRESS"
  priority      = var.http_priority
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["i27-webserver-network-tag"]
}

resource "google_compute_instance" "tf_gce_vm" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.tf_subnet.id
    access_config {}
  }

  tags = ["i27-ssh-network-tag", "i27-webserver-network-tag"]
}
```

---

## File: `terraform.tfvars`

```hcl
project_id     = "silver-tempo-455118-a5"
ssh_priority   = 800
http_priority  = 900
region         = "us-central1"
zone           = "us-central1-a"
vm_name        = "custom-vm-name"
machine_type   = "e2-medium"
```
