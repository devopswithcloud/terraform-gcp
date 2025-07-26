# Terraform Variables – Type: `map(string)`

This example shows how to use a key-value map to dynamically configure values, such as machine types based on environment.

---

## What is a `map(string)`?

A `map(string)` is a **collection of key-value pairs**, where **both the key and value are strings**.

### Example:

```hcl
{
  "env"     = "dev"
  "owner"   = "siva"
  "project" = "i27academy"
}
```

Used when you want to define labeled configurations or settings.

---

## `variables.tf`

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

variable "environment" {
  type        = string
  default     = "dev"
}

variable "machine_types" {
  type = map(string)
  default = {
    dev   = "e2-micro"
    stage = "e2-small"
    prod  = "e2-medium"
  }
}

variable "enable_startup_script" {
  type    = bool
  default = false
}

variable "vm_tags" {
  type    = list(string)
  default = ["i27-ssh-network-tag", "i27-webserver-network-tag"]
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
  priority      = 1000
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
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  target_tags = ["i27-webserver-network-tag"]
}

resource "google_compute_instance" "tf_gce_vm" {
  name         = "i27-${var.environment}-vm"
  machine_type = var.machine_types[var.environment]
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

  #metadata_startup_script = var.enable_startup_script ? file("${path.module}/startup.sh") : null

  tags = var.vm_tags
}
```

---

## `terraform.tfvars`

```hcl
project_id   = ""
environment  = "stage"
```

