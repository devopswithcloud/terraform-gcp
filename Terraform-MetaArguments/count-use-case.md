
# Terraform Example Using `count` – Dynamic VPC, Subnets, and VMs

This example demonstrates how to:

* Create a **custom VPC**
* Dynamically provision **multiple subnets**
* Dynamically create **multiple GCE instances**
* Set up **firewall rules** for SSH and HTTP

All using **`count` meta-argument** and **Terraform variables** for full flexibility.

---

## Terraform Settings Block

```hcl
terraform {
  required_version = ">= 1.9.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.42.0"
    }
  }
}
```

---

## Provider Configuration

```hcl
provider "google" {
  region  = var.region
  project = var.project_id
}
```

### Variables Used:

```hcl
variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The region where resources will be created"
  type        = string
}
```

---

## Create a VPC

```hcl
resource "google_compute_network" "tf_vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  description             = "Creating a VPC from terraform"
}
```

###  Variable Used:

```hcl
variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}
```

---

## Create Multiple Subnets using `count`

```hcl
resource "google_compute_subnetwork" "tf_subnet" {
  count         = length(var.subnet_names)
  name          = var.subnet_names[count.index]
  region        = var.region
  ip_cidr_range = var.subnet_cidrs[count.index]
  network       = google_compute_network.tf_vpc.id
}
```

### Variables Used:

```hcl
variable "subnet_names" {
  description = "List of subnet names to be created"
  type        = list(string)
}

variable "subnet_cidrs" {
  description = "List of CIDR blocks for the subnets"
  type        = list(string)
}
```

---

## Create Multiple GCE Instances using `count`

```hcl
resource "google_compute_instance" "tf_gce_vm" {
  count        = var.instance_count
  name         = "${var.vm_name}-${count.index + 1}"
  machine_type = var.machine_type
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork    = google_compute_subnetwork.tf_subnet[count.index].id
    access_config {}
  }

  metadata_startup_script = file("${path.module}/startup.sh")

  tags = [
    tolist(google_compute_firewall.tf_http.target_tags)[0],
    tolist(google_compute_firewall.tf_ssh.target_tags)[0]
  ]
}
```

### Variables Used:

```hcl
variable "vm_name" {
  description = "The base name of the VM instances"
  type        = string
}

variable "machine_type" {
  description = "The machine type for the VM instances"
  type        = string
}

variable "instance_count" {
  description = "Number of GCE instances to create"
  type        = number
}
```

---

## Firewall Rule – SSH

```hcl
resource "google_compute_firewall" "tf_ssh" {
  name    = var.firewall_ssh_name

  allow {
    ports    = ["22"]
    protocol = "tcp"
  }

  direction     = "INGRESS"
  network       = google_compute_network.tf_vpc.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["i27-ssh-network-tag"]
}
```

### Variable Used:

```hcl
variable "firewall_ssh_name" {
  description = "The name of the SSH firewall rule"
  type        = string
}
```

---

## Firewall Rule – HTTP

```hcl
resource "google_compute_firewall" "tf_http" {
  name    = var.firewall_http_name

  allow {
    ports    = ["80"]
    protocol = "tcp"
  }

  direction     = "INGRESS"
  network       = google_compute_network.tf_vpc.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["i27-webserver-network-tag"]
}
```

### Variable Used:

```hcl
variable "firewall_http_name" {
  description = "The name of the HTTP firewall rule"
  type        = string
}
```

---

## Sample `terraform.tfvars`

```hcl
project_id         = "noted-runway-429202-q4"
region             = "us-central1"
vpc_name           = "i27-vpc"

subnet_names       = ["i27-subnet-1", "i27-subnet-2"]
subnet_cidrs       = ["10.6.0.0/16", "10.7.0.0/16"]

vm_name            = "i27-webserver"
machine_type       = "e2-micro"
instance_count     = 2

firewall_ssh_name  = "i27-allow-ssh-22"
firewall_http_name = "fwrule-allow-http80"
```

---

