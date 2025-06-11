
# Terraform for_each Meta-Argument – Full Infrastructure Guide

---

## What is `for_each`?

The `for_each` meta-argument allows you to dynamically create resources from a **map** or **set/list**, giving each resource a **unique identity** based on a key.

This is useful when:
- You want **named resources** (e.g., per region or per team)
- You want to **control updates precisely** (unlike with `count`)

---

## Simple Analogy

Imagine Terraform as a robot:

- 🧍‍♂️ “Create one for each name in this list” → `for_each = toset(["vm1", "vm2"])`
- 🧩 “Use this key and value from a map” → `for_each = var.subnet_map`
- 🔐 “Tag each resource differently” → `each.key`, `each.value`

---

## `count` vs `for_each` – Comparison

| Feature              | `count`                                | `for_each`                                |
|----------------------|-----------------------------------------|--------------------------------------------|
| Input type           | Number                                  | List or Map                                |
| Resource referencing | By index (`resource[0]`)                | By key (`resource["name"]`)                |
| Ideal for            | Identical resources                     | Named/uniquely identified resources        |
| Index/key access     | `count.index`                           | `each.key`, `each.value`                   |
| Resource tracking    | Less stable                             | More stable (when using consistent keys)   |

---

## ⚠️ Common Gotchas

| Mistake                                | Why it Happens                                 | Solution                                   |
|----------------------------------------|------------------------------------------------|--------------------------------------------|
| Using both `count` and `for_each`      | Not allowed in the same resource               | Use only one                               |
| Changing keys in `for_each` map        | Destroys and recreates resources               | Use stable keys like names or IDs          |
| Referencing `each.key` in a list       | Lists don’t have keys                          | Use `toset()` or switch to a map           |
| Unclear error messages from duplicates | `for_each` values must be unique               | Always use `toset()` with lists            |

---

## 📘 Terraform Settings and Provider

```hcl
terraform {
  required_version = ">= 1.9.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
```

### Variables

```hcl
variable "project_id" {
  type    = string
  default = "******"
}

variable "region" {
  type    = string
  default = "us-central1"
}
```

---

## VPC

```hcl
resource "google_compute_network" "i27_vpc" {
  name                    = "i27-vpc"
  auto_create_subnetworks = false
  description             = "Terraform-managed VPC"
}
```

---

## Subnets using for_each (Map)

### Subnet Variable

```hcl
variable "subnets" {
  type = map(object({
    cidr_block = string
    region     = string
  }))
  default = {
    "us-central1-subnet" = { cidr_block = "10.10.0.0/16", region = "us-central1" }
    "us-east1-subnet"    = { cidr_block = "10.20.0.0/16", region = "us-east1" }
  }
}
```

### Resource

```hcl
resource "google_compute_subnetwork" "i27_subnet" {
  for_each      = var.subnets
  name          = each.key
  ip_cidr_range = each.value.cidr_block
  region        = each.value.region
  network       = google_compute_network.i27_vpc.id
}
```

---

## Firewalls

### SSH

```hcl
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.i27_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh-tag"]
}
```

### HTTP

```hcl
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = google_compute_network.i27_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-tag"]
}
```

---

## GCE VMs using for_each (List)

### VM Variable

```hcl
variable "vm_names" {
  type    = list(string)
  default = ["i27-vm-1", "i27-vm-2"]
}
```

### Resource

```hcl
resource "google_compute_instance" "webserver" {
  for_each     = toset(var.vm_names)
  name         = each.key
  machine_type = "e2-micro"
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork    = google_compute_subnetwork["us-central1-subnet"].id
    access_config {}
  }

  metadata_startup_script = file("${path.module}/startup.sh")
  tags = ["ssh-tag", "http-tag"]
}
```

---

## Outputs

```hcl
output "subnet_names" {
  value = [for s in google_compute_subnetwork.i27_subnet : s.name]
}

output "vm_names" {
  value = [for vm in google_compute_instance.webserver : vm.name]
}
```

---

## Summary

Use `for_each` when:
- You need **logical names** for resources
- Working with **maps or sets**
- You want **readable Terraform plans**
