
# Terraform Meta-Argument: `count`

The `count` meta-argument in Terraform allows you to **create multiple copies** of a resource using a single block of code.

---

## Why Use `count`?

* Create multiple identical or similar resources
* Save time — no need to repeat code
* Conditionally create a resource (`count = 0`)
* Use dynamic naming (`count.index`)

---

## Syntax Overview

```hcl
resource "google_compute_instance" "example" {
  count = 3
  name  = "vm-${count.index}"

  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }
}
```

This creates:

* `vm-0`
* `vm-1`
* `vm-2`

---

## Real Use Case: Create 3 Dev VMs

```hcl
resource "google_compute_instance" "dev_vm" {
  count        = 3
  name         = "dev-vm-${count.index}"
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

  tags = ["dev"]
}
```

---

## Conditional Resource Creation

```hcl
variable "create_vm" {
  type    = bool
  default = false
}

resource "google_compute_instance" "optional_vm" {
  count = var.create_vm ? 1 : 0
  name  = "optional-vm"
  # other config
}
```

Great for **environments where a resource may or may not be created**.

---

## ❗ Common Mistakes & Gotchas

| Mistake                                    | Why It Happens           | How to Fix                                       |
| ------------------------------------------ | ------------------------ | ------------------------------------------------ |
| `google_compute_instance.vm.id` fails      | `count` returns a list   | Use `google_compute_instance.vm[count.index].id` |
| Using both `count` & `for_each`            | Not allowed              | Choose one                                       |
| Assuming index starts at 1                 | It starts at 0           | Use `vm-${count.index}`                          |
| Resources get destroyed on count reduction | Terraform removes excess | Use with caution for critical resources          |

---

## ✅ When to Use `count`

* When resources are **identical or nearly identical**
* When you need **conditional creation**
* When you don’t need **map-like keys** (that’s `for_each`)

---
