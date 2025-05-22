# Terraform Notes: **String Variables with Real Example**

## What is a String Variable?

A **string** in Terraform is a sequence of characters used to define human-readable values such as names, regions, IP ranges, and IDs.

String variables are **declared using the `string` type**, and their values are always wrapped in **double quotes**.

---

## Defining String Variables (from `variables.tf`)

```hcl
variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "vpc_name" {
  type    = string
  default = "i27-vpc"
}

variable "subnet_name" {
  type    = string
  default = "i27-subnet"
}

variable "subnet_cidr" {
  type    = string
  default = "10.6.0.0/16"
}

variable "vm_name" {
  type    = string
  default = "i27-webserver"
}

variable "machine_type" {
  type    = string
  default = "e2-micro"
}
```

---

## Assigning Values Using `terraform.tfvars`

```hcl
project_id     = "your-gcp-project-id"
region         = "us-central1"
zone           = "us-central1-a"
vm_name        = "custom-vm-name"
machine_type   = "e2-medium"
```

---

## Using String Variables in Real Terraform Resources (`main.tf`)

### Provider Block

```hcl
provider "google" {
  project = var.project_id
  region  = var.region
}
```

### VPC and Subnet

```hcl
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
```

### Compute VM Instance

```hcl
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

