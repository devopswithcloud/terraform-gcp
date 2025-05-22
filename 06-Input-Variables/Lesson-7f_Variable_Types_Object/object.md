# Terraform Variables – Type: `object`


## What is an `object` in Terraform?

### Think of it like a **form** or **group of fields**.

Just like how you might fill a form with:

* Your name
* Your age
* Your email

In Terraform, an object lets you group related values together — like the name of a VM, its machine type, and zone.

Think of an `object` like a **form** with multiple related fields grouped together.

---

## Without `object`

You might define these **separately**:

```hcl
variable "vm_name" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "zone" {
  type = string
}
```

When you write `.tfvars`, you'd have:

```hcl
vm_name      = "webserver"
machine_type = "e2-micro"
zone         = "us-central1-a"
```

✅ Works, but it gets messy if you have many such values.

---

## ✅ With `object` (Clean Style)

```hcl
variable "vm_config" {
  type = object({
    name         = string
    machine_type = string
    zone         = string
    tags         = list(string)
  })

  default = {
    name         = "i27-webserver"
    machine_type = "e2-micro"
    zone         = "us-central1-a"
    tags         = ["i27-ssh-network-tag", "i27-webserver-network-tag"]
  }
}
```

In `terraform.tfvars`:

```hcl
vm_config = {
  name         = "i27-stage-vm"
  machine_type = "e2-small"
  zone         = "us-central1-b"
  tags         = ["ssh", "https", "stage"]
}
```

---

## Using `object` values

In your Terraform resource, you can now do:

```hcl
resource "google_compute_instance" "vm" {
  name         = var.vm_config.name
  machine_type = var.vm_config.machine_type
  zone         = var.vm_config.zone
  tags         = var.vm_config.tags
}
```

Each part of the object is accessed using dot (`.`) notation:

* `var.vm_config.name`
* `var.vm_config.zone`

---

## Why this is useful

| Without `object`            | With `object`              |
| --------------------------- | -------------------------- |
| Too many separate variables | Clean single grouped input |
| Harder to pass to modules   | Easier to reuse            |
| Repetitive `.tfvars` lines  | One neat block             |

---

## Final Analogy

If variables were **groceries**, `object` is like putting them all into **one bag** labeled "VM Config".

Instead of carrying:

* Apple 
* Banana 
* Bread 

You're carrying:

* Bag of groceries `{ apple, banana, bread }`

---

## Complete Terraform Code Using `object`

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

# object
variable "vm_config" {
  type = object({
    name         = string
    machine_type = string
    zone         = string
    tags         = list(string)
  })

  default = {
    name         = "i27-webserver"
    machine_type = "e2-micro"
    zone         = "us-central1-a"
    tags         = ["i27-ssh-network-tag", "i27-webserver-network-tag"]
  }
}
```

---

### `main.tf`

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
  name    = "i27-allow-ssh"
  network = google_compute_network.tf_vpc.id
  direction = "INGRESS"
  priority  = 1000
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = ["i27-ssh-network-tag"]
}

resource "google_compute_firewall" "tf_http" {
  name    = "i27-allow-http"
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
  name         = var.vm_config.name
  machine_type = var.vm_config.machine_type
  zone         = var.vm_config.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.tf_subnet.id
    access_config {}
  }

  tags = var.vm_config.tags
}
```

---

### `terraform.tfvars`

```hcl
project_id = ""

vm_config = {
  name         = "i27-stage-vm"
  machine_type = "e2-small"
  zone         = "us-central1-b"
  tags         = ["i27-ssh-network-tag", "i27-webserver-network-tag", "https-server"]
}
```

---

## Summary

| Benefit         | Explanation                            |
|------------------|----------------------------------------|
| Clean Inputs     | Group related fields into one          |
| Easy to Manage   | Pass once instead of 4 variables       |
| Reusable         | Use same object for multiple VMs later |
