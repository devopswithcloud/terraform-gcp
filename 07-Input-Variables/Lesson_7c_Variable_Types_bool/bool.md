# Terraform Variables – Type: `bool`

**Use Case**: Conditionally Enable Startup Script for GCE VM

---

## What is a Boolean (`bool`) Variable?

A **boolean** variable represents a binary choice:

* `true` = Enabled
* `false` = Disabled

Commonly used for:

* Enabling/disabling features (like a startup script)
* Turning on/off resources
* Applying conditional logic in a clean way

---

## `variables.tf`

```hcl
variable "enable_startup_script" {
  type        = bool
  description = "Whether to enable the startup script"
  default     = false
}
```

> Default is `false`, meaning no startup script will run unless explicitly enabled.

---

## `terraform.tfvars`

```hcl
project_id            = "silver-tempo-455118-a5"
enable_startup_script = true
ssh_priority          = 800
http_priority         = 900
region                = "us-central1"
zone                  = "us-central1-a"
vm_name               = "custom-vm-name"
machine_type          = "e2-medium"
```

> `enable_startup_script = true` enables the startup logic for the VM.

---

## Where and How It’s Used (From Your `main.tf`)

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

  metadata_startup_script = var.enable_startup_script ? file("${path.module}/startup.sh") : null

  tags = ["i27-ssh-network-tag", "i27-webserver-network-tag"]
}
```

### Logic Explained

```hcl
metadata_startup_script = var.enable_startup_script ? file("${path.module}/startup.sh") : null
```

* ✅ If `enable_startup_script = true`
  👉 Terraform injects and runs `startup.sh`

* ❌ If `false`
  👉 Terraform passes `null` — no script is attached

---

## How It Works in Practice

1. **Create `startup.sh`** in the same folder:

```bash
#!/bin/bash
sudo apt update -y
sudo apt install apache2 -y
sudo systemctl start apache2
```

2. **Enable in `terraform.tfvars`:**

```hcl
enable_startup_script = true
```

3. **Deploy:**

```bash
terraform init
terraform apply
```

4. **Verify:** Use external IP to check if Apache is running (`http://<external-ip>`)

---

## Summary Table

| Variable                | Type   | Default | Purpose                          |
| ----------------------- | ------ | ------- | -------------------------------- |
| `enable_startup_script` | `bool` | `false` | Conditionally run startup script |

---

## Key Concept: Ternary Operator in Terraform

```hcl
condition ? value_if_true : value_if_false
```

* Used for clean conditional expressions.
* No need for `count`, `locals`, or `dynamic`.

---

## Advantages of This Approach

* Beginner-friendly
* Clean and readable
* Avoids advanced constructs
* Works well with file-based scripts

## Refer manifest files for deeper example
---
