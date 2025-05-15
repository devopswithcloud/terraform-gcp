
# Terraform Meta-Argument: `provider` with Aliases (Multiple GCP Projects)

Terraform allows you to use **multiple provider configurations** to manage resources across **different GCP projects or regions**. This is done using the **`provider` meta-argument** along with **provider aliases**.

---

## Why Use `provider` Meta-Argument with Aliases?

- Manage infrastructure across **multiple GCP projects** in a single Terraform setup.
- Explicitly control which provider configuration is used for which resource.
- Keep configurations clean, reusable, and manageable.

---

## Terraform Configuration Breakdown

### 1. Terraform Settings Block

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

### 2. Provider Block (Default and Aliased)

```hcl
# Default provider for Project A
provider "google" {
  project = "noted-runway-429202-q4"
  region  = "us-central1"
}

# Aliased provider for Project B
provider "google" {
  alias   = "project_b"
  project = "devproject-430303"
  region  = "europe-west1"
}
```

You define an alias using `alias = "project_b"` and reference it in resources as `google.project_b`.

---

### 3. Create VPC and Subnet in Project A (Default Provider)

```hcl
resource "google_compute_network" "vpc_project_a" {
  name                    = "vpc-project-a"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet_project_a" {
  name          = "subnet-project-a"
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc_project_a.id
}
```

---

### 4. Create VPC and Subnet in Project B (Aliased Provider)

```hcl
resource "google_compute_network" "vpc_project_b" {
  provider = google.project_b
  name     = "vpc-project-b"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet_project_b" {
  provider      = google.project_b
  name          = "subnet-project-b"
  ip_cidr_range = "10.1.0.0/16"
  region        = "europe-west1"
  network       = google_compute_network.vpc_project_b.id
}
```

---

### 5. Create GCE VMs in Each Project

```hcl
# In Project A (Default)
resource "google_compute_instance" "vm_project_a" {
  name         = "vm-project-a"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet_project_a.id
    access_config {}
  }
}

# In Project B (Aliased)
resource "google_compute_instance" "vm_project_b" {
  provider     = google.project_b
  name         = "vm-project-b"
  machine_type = "e2-medium"
  zone         = "europe-west1-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet_project_b.id
    access_config {}
  }
}
```

---

### 6. Output Block

```hcl
output "vm_instances" {
  value = {
    project_a = google_compute_instance.vm_project_a.self_link
    project_b = google_compute_instance.vm_project_b.self_link
  }
}
```

---

## Summary

| Feature        | What It Does |
|----------------|--------------|
| `provider`     | Specifies which provider configuration to use |
| `alias`        | Allows defining multiple configurations of the same provider |
| `google.<alias>` | Targets specific resources to the intended GCP project |

This approach helps you **manage multi-project GCP infrastructure cleanly** using the `provider` meta-argument.

---

📌 This is especially useful in enterprise setups or environments like Dev, Stage, and Prod managed under different GCP projects.
