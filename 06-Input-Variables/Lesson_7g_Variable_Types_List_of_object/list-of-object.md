# Terraform Variable Type: `list(object)`

---

## What is `list(object)` in Terraform?

Think of `list(object)` as a **list of forms** — like filling the same application for multiple employees or VMs.

* `object` = one item with multiple fields
* `list(object)` = a group of such items

---

## Think of it like...

> You're creating 3 employees in a system.
> Each employee has:
>
> * Name
> * ID
> * Email

If `object` is 1 employee’s info,
then `list(object)` is a **list of all employees**.

---

## Why Use `list(object)`?

### Without list(object):

```hcl
variable "vm1_name" {}
variable "vm2_name" {}
...
```

Gets messy and repetitive.

---

### With list(object):

```hcl
variable "vm_list" {
  type = list(object({
    name         = string
    machine_type = string
    zone         = string
    tags         = list(string)
  }))
}
```

Now you can handle **many VMs at once** in a neat way.

---

## Real-World Use Case: Create Multiple VMs

Say you want 2 VMs:

* One in `us-central1-a`, type `e2-micro`
* Another in `us-central1-b`, type `e2-small`

---

## Step-by-Step Implementation

---

### `variables.tf`

```hcl
variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
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

variable "vm_list" {
  description = "List of VMs to create"
  type = list(object({
    name         = string
    machine_type = string
    zone         = string
    tags         = list(string)
  }))
}
```

---

### `terraform.tfvars`

```hcl
project_id = ""

vm_list = [
  {
    name         = "i27-vm-1"
    machine_type = "e2-micro"
    zone         = "us-central1-a"
    tags         = ["ssh", "web"]
  },
  {
    name         = "i27-vm-2"
    machine_type = "e2-small"
    zone         = "us-central1-b"
    tags         = ["ssh"]
  }
]
```

---

###  `main.tf` (Manual access without `for_each`)

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

resource "google_compute_instance" "vm1" {
  name         = var.vm_list[0].name
  machine_type = var.vm_list[0].machine_type
  zone         = var.vm_list[0].zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.tf_subnet.id
    access_config {}
  }

  tags = var.vm_list[0].tags
}

resource "google_compute_instance" "vm2" {
  name         = var.vm_list[1].name
  machine_type = var.vm_list[1].machine_type
  zone         = var.vm_list[1].zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.tf_subnet.id
    access_config {}
  }

  tags = var.vm_list[1].tags
}
```

---

## Summary Table

| Concept        | Purpose                               |
| -------------- | ------------------------------------- |
| `object`       | One item with multiple fields         |
| `list(object)` | Many such items, like a group of VMs  |
| Why use it?    | Reusability, fewer variables, scaling |

---