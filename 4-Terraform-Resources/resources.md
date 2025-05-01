## Title: Terraform Resource Block - Deep Dive
### Description: Understand and write Terraform resource blocks with examples and structure.
---

## What is a Terraform `resource` Block?

- The `resource` block is used to **create, modify, or delete** infrastructure components.
- It’s the **core block** in any Terraform configuration — **most of your `.tf` code will be composed of `resource` blocks**.
- Each resource maps to a **specific object in the target cloud/platform** (e.g., GCP, AWS, Azure).

---

## Basic Syntax of a Resource Block

```hcl
resource "<PROVIDER>_<RESOURCE_TYPE>" "<LOCAL_NAME>" {
  # Configuration arguments
}
```

| Part             | Description |
|------------------|-------------|
| `<PROVIDER>`     | Cloud or platform provider (e.g., `google`, `aws`) |
| `<RESOURCE_TYPE>`| Specific service/resource (e.g., `compute_instance`, `storage_bucket`) |
| `<LOCAL_NAME>`   | A unique name to reference this resource locally in the Terraform code |

---

## Example: Google Cloud VPC Resource

```hcl
resource "google_compute_network" "tf_vpc" {
  name                    = "workflowvpc"
  auto_create_subnetworks = false
}
```

### Explanation:
- `google_compute_network`: GCP resource type to create VPC
- `tf_vpc`: local name to reference the VPC in other resources/outputs
- `name`: the name of the VPC in GCP Console
- `auto_create_subnetworks`: set to false to disable automatic subnets

---

## Additional Example: Creaing subnets 

```hcl
# Provider 
provider "google" {
  project = "projectid"
  region  = "us-central1"
}

# VPC Resource
resource "google_compute_network" "tf_vpc" {
  # The name of the VPC network
  name = "i27-vpc"

  # Setting to false to manually define subnetworks instead of automatically creating them
  auto_create_subnetworks = false

  # Description of the VPC network, helpful for identification
  description = "Creating a VPC from terraform"
}

# Create a Subnet Resource
resource "google_compute_subnetwork" "tf_subnet" {
  # The name of the subnet
  name = "i27-subnet"

  # The region where the subnet will be created
  region = "us-central1"

  # The IP range for the subnet, defined in CIDR notation
  ip_cidr_range = "10.6.0.0/16"

  # Associate this subnet with the VPC network created above
  network = google_compute_network.tf_vpc.id
  # Syntax: resource_type.resourcelocal_name.attribute
  # This creates an implicit dependency — no need to write `depends_on`.
}

```

---

## Resource Dependency Handling

Terraform automatically understands **dependencies** based on references.

Example:
```hcl
network       = google_compute_network.tf_vpc.id 
```
This creates an **implicit dependency** — no need to write `depends_on`.

If needed explicitly:
```hcl
depends_on = [google_compute_network.tf_vpc] # we shall see about these later
```

---

##  Commands for Testing a Resource Block

```bash
# Initialize Terraform
terraform init

# Validate syntax
terraform validate

# Preview what will be created
terraform plan

# Apply and create the resource
terraform apply

# View state
terraform show

# Destroy resource
terraform destroy
```

---

## Key Takeaways

- The `resource` block is the **heart of Terraform**.
- Understand the naming: `provider_resource_type`, local name, arguments.
- Start simple (VPC), then add more complex resources (VMs, buckets).
- Use references and let Terraform manage dependency graph automatically.

---

## More Real examples are available in the `manifest-files` folder
