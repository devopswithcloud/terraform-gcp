
# Terraform Variables via Environment Variables

Terraform supports variable values from:

1. `.tfvars` files
2. CLI flags
3. **Environment variables** (focus of this guide)

---

## Sample Resource Setup

```hcl
provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_instance" "prompt_vm" {
  name         = "prompt-vm"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network       = "default"
    access_config {}
  }
}
```

---

## Required Variables

```hcl
variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "region" {
  type        = string
  description = "The GCP region"
}

variable "zone" {
  type        = string
  description = "The GCP zone"
}

variable "machine_type" {
  type        = string
  description = "The machine type for the VM"
}
```

---

## Setting Variables via Environment Variables

### Terraform Convention

For Terraform to recognize environment variables, they must be **prefixed with `TF_VAR_`**.

So for variable `project_id`, you must use `TF_VAR_project_id`.

---

## Linux/macOS Terminal

### Set variables temporarily (session-only):

```bash
export TF_VAR_project_id="silver-tempo-455118-a5"
export TF_VAR_region="us-central1"
export TF_VAR_zone="us-central1-a"
export TF_VAR_machine_type="e2-micro"
```

### Unset variables:

```bash
unset TF_VAR_project_id
unset TF_VAR_region
unset TF_VAR_zone
unset TF_VAR_machine_type
```

---

## Windows (CMD)

### Set variables:

```cmd
set TF_VAR_project_id=silver-tempo-455118-a5
set TF_VAR_region=us-central1
set TF_VAR_zone=us-central1-a
set TF_VAR_machine_type=e2-micro
```

### Unset variables:

```cmd
set TF_VAR_project_id=
set TF_VAR_region=
set TF_VAR_zone=
set TF_VAR_machine_type=
```

---

## Windows (PowerShell)

### Set variables:

```powershell
$env:TF_VAR_project_id = "silver-tempo-455118-a5"
$env:TF_VAR_region = "us-central1"
$env:TF_VAR_zone = "us-central1-a"
$env:TF_VAR_machine_type = "e2-micro"
```

### Unset variables:

```powershell
Remove-Item Env:TF_VAR_project_id
Remove-Item Env:TF_VAR_region
Remove-Item Env:TF_VAR_zone
Remove-Item Env:TF_VAR_machine_type
```

---

## Verify in Terraform

Run:

```bash
terraform plan
```

If everything is set correctly, Terraform will NOT prompt you for input — it picks values from the environment.

---

## Best Practice Tip

Use env vars:

* When working with secrets (temporary values)
* For automation pipelines (CI/CD)
* When switching between different environments quickly

Avoid:

* Hardcoding project IDs in `.tf` files
* Committing `.tfvars` with secrets

---
