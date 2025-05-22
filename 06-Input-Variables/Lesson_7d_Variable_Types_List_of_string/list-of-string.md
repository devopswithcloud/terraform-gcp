# Terraform Variables – Type: `list(string)`

This example demonstrates how to use a list of strings in Terraform — ideal for passing multiple network tags.

---
## What is a `list(string)` Variable?

A **list of strings** is a collection of multiple string values enclosed in square brackets.

### Example:

```hcl
["http", "https", "ssh"]
```

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

variable "vm_name" {
  type        = string
  default     = "i27-webserver"
}

variable "machine_type" {
  type        = string
  default     = "e2-micro"
}

variable "enable_startup_script" {
  type        = bool
  default     = false
}

variable "vm_tags" {
  type        = list(string)
  description = "Network tags for the GCE instance"
  default     = ["i27-ssh-network-tag", "i27-webserver-network-tag"]
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

  metadata_startup_script = var.enable_startup_script ? file("${path.module}/startup.sh") : null

  tags = var.vm_tags
}
```

---

## `terraform.tfvars`

```hcl
project_id = "silver-tempo-455118-a5"
vm_tags    = ["i27-ssh-network-tag", "i27-webserver-network-tag", "https-server"]
```

## Common Use Cases for `list(string)`

| Purpose             | Example                           |
| ------------------- | --------------------------------- |
| Open multiple ports | `["22", "80", "443"]`             |
| Multiple regions    | `["us-central1", "europe-west1"]` |
| GCE instance tags   | `["web", "ssh", "monitoring"]`    |
| Subnets to create   | `["subnet-a", "subnet-b"]`        |

---

## Common Mistakes

* ❌ Using numbers instead of strings:

  ```hcl
  [22, 80]  # WRONG
  ```

  ✅ Correct:

  ```hcl
  ["22", "80"]
  ```

* ❌ Forgetting square brackets:

  ```hcl
  "22"  # Single string, not a list
  ```