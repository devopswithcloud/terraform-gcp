
## Terraform `terraform` Block – Configuration Meta Block

The `terraform` block is used to configure how Terraform itself behaves. It doesn't create resources — instead, it sets:

* Required Terraform CLI version
* Required provider plugins and versions
* Backend for remote state
* (Optional) Experimental features

---

### Example Structure

```hcl
terraform {
  required_version = ">= 1.12.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  backend "gcs" {
    bucket = "my-terraform-state-bucket"
    prefix = "state/dev"
  }
}
```

---

## Version Constraints in Terraform

Terraform allows you to use **version constraints** to control which versions are allowed.

---

### `required_version` – For Terraform CLI

This ensures the correct **Terraform binary** is used when applying the configuration.

| Constraint          | Meaning                                               |
| ------------------- | ----------------------------------------------------- |
| `= 1.4.2`           | Exactly version 1.4.2                                 |
| `!= 1.4.2`          | Any version except 1.4.2                              |
| `>= 1.2.0`          | Version 1.2.0 or higher                               |
| `<= 1.4.0`          | Version 1.4.0 or lower                                |
| `~> 1.3.0`          | Any version 1.3.x (e.g., 1.3.1, 1.3.9)                |
| `~> 1.3`            | Same as above                                         |
| `>= 1.3.0, < 1.5.0` | Range between 1.3.0 (inclusive) and 1.5.0 (exclusive) |

#### Example:

```hcl
terraform {
  required_version = "~> 1.4.0"
}
```

---

###  `required_providers` – For Terraform Providers

Used to define **source** and **version constraints** for each provider.

| Version Constraint  | Meaning                                               |
| ------------------- | ----------------------------------------------------- |
| `= 5.7.0`           | Only version 5.7.0                                    |
| `>= 5.0.0`          | Minimum version must be 5.0.0                         |
| `< 6.0.0`           | Maximum version is less than 6.0.0                    |
| `>= 4.0.0, < 5.0.0` | Accepts versions in the 4.x range                     |
| `~> 5.0`            | Allows patch upgrades (5.0.1, 5.0.2, … but not 5.1.0) |

#### Example:

```hcl
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0, < 5.0"
    }
  }
}
```

---

## `backend` Block (Inside `terraform`)

Used to configure **remote state backends** such as GCS, S3, etc.

```hcl
terraform {
  backend "gcs" {
    bucket = "my-tf-state"
    prefix = "env/dev"
  }
}
```

> ⚠️ Variables are **not allowed** in the backend block directly.

---

## Key Points to Remember

* Only **one `terraform` block** is allowed per module.
* The block configures how Terraform behaves (not infrastructure).
* Always **pin versions** for Terraform and providers to avoid breaking changes.
* Use constraints like `~>`, `>=`, `<` for better control.
