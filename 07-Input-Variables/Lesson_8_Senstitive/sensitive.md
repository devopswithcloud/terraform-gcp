# Terraform Variables – Marking a Variable as `sensitive`

**Use Case**: Protecting secrets like passwords, tokens, private keys

---

##  What is a Sensitive Variable?

A **sensitive variable** in Terraform hides its value from logs, plans, and CLI output.

### What It Does:

* Hides sensitive values (e.g., passwords, secrets, keys) from:

  * `terraform plan`
  * `terraform apply`
  * `terraform output`

### What It Doesn't Do:

* **Does NOT encrypt** values — they still appear in plain text in `terraform.tfstate`
* Only **masks them in CLI output and logs**

### Where It Works:

| Context            | Behavior                          |
| ------------------ | --------------------------------- |
| `terraform plan`   | ✅ Hidden (shows `(sensitive)`)    |
| `terraform apply`  | ✅ Hidden                          |
| `terraform output` | ✅ Hidden (if marked sensitive)    |
| `.tfstate` file    | ❌ **Plain text visible**          |
| Debug/Log files    | ❌ Visible unless handled manually |

### Example:

```hcl
variable "db_password" {
  type        = string
  description = "The database root password"
  sensitive   = true
}
```

> Even though the type is `string`, `sensitive = true` hides its value from Terraform CLI output.

---

##  `variables.tf`

```hcl
variable "project_id" {
  type        = string
  description = "Your GCP Project ID"
}

variable "region" {
  type        = string
  default     = "us-central1"
}

variable "db_instance_name" {
  type        = string
  default     = "i27-db-instance"
}

variable "db_user" {
  type        = string
  default     = "i27admin"
}

variable "db_password" {
  type        = string
  description = "Database user password (kept sensitive)"
  sensitive   = true
}
```

---
---

### `main.tf`

```hcl
provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_sql_database_instance" "i27_sql_instance" {
  name             = var.db_instance_name
  database_version = "MYSQL_8_0"
  region           = var.region

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        name  = "allow-public"
        value = "0.0.0.0/0"
      }
    }
  }

  deletion_protection = false
}

resource "google_sql_user" "i27_db_user" {
  name     = var.db_user
  instance = google_sql_database_instance.i27_sql_instance.name
  password = var.db_password
}

output "db_password_plain_test" {
  value     = var.db_password
  sensitive = true
}
```
---

### `terraform.tfvars`

```hcl
project_id  = ""
db_password = ""
```

## Output of Sensitive Variables

If you try to print the value using `output`:

```hcl
output "db_password_plain_test" {
  value     = var.db_password
  sensitive = true
}
```

> Even if you `terraform apply`, the output will say:
> `value = (sensitive value)`

