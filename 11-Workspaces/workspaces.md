
#  Terraform Workspaces

## 🔹 What are Workspaces?

* Workspaces in Terraform allow you to manage **multiple environments (like dev, test, prod)** within the **same Terraform configuration**.
* Each workspace has its **own state file**, meaning resources created in one workspace do not affect the others.
* By default, Terraform starts with a workspace named `default`.

---

## 🔹 Why use Workspaces?

* To separate infrastructure by **environments** (dev, test, prod).
* To avoid creating multiple copies of the same `.tf` files.
* To keep state files isolated for safety and clarity.

---

## 🔹 Common Workspace Commands

| Command                          | Description                           |
| -------------------------------- | ------------------------------------- |
| `terraform workspace list`       | Lists all workspaces                  |
| `terraform workspace new dev`    | Creates a new workspace named `dev`   |
| `terraform workspace select dev` | Switches to the `dev` workspace       |
| `terraform workspace show`       | Displays the current active workspace |
| `terraform workspace delete dev` | Deletes a workspace (only if empty)   |

---

## 🧾 Example – Using Workspaces

Let’s say we want to create a **GCP VM instance**, but differentiate between environments (dev & prod).

### main.tf

```hcl
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_compute_instance" "tf_vm" {
  name         = "vm-${terraform.workspace}"   # Workspace-specific name
  machine_type = var.machine_type
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network = google_compute_network.tf_vpc.id
  }
}

resource "google_compute_network" "tf_vpc" {
  name                    = "vpc-${terraform.workspace}"
  auto_create_subnetworks = true
}
```

### variables.tf

```hcl
variable "project_id" {
  type        = string
  description = "Project ID"
  #default     = "silver-tempo-455118-a5"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "machine_type" {
  type    = string
  default = "e2-micro"
}
```

---

## 🔹 Workflow

```bash
# Initialize
terraform init

# Create workspaces
terraform workspace new dev
terraform workspace new prod

# Switch to dev
terraform workspace select dev
terraform apply   # Will create vm-dev and vpc-dev

# Switch to prod
terraform workspace select prod
terraform apply   # Will create vm-prod and vpc-prod

# cleanup after practise
terraform workspace select dev
terraform destroy --auto-approve

terraform workspace select prod
terraform destroy --auto-approve
```

👉 Each environment (`dev`, `prod`) has its **own state file**, so resources don’t overlap.

---

## ✅ Key Pointers for using workspaces

* Workspaces help in managing **multiple environments safely**.
* State files are **isolated** per workspace.
* Good for simple environment separation, but for **large infra projects**, prefer **separate state backends** (like different buckets).

