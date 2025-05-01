
## Title: Terraform Workflow with Core Commands - GCP
### Description: Understand the Terraform Workflow & Core Commands with Hands-on on Google Cloud

## Introduction
- Understand basic Terraform Commands
  - terraform init
  - terraform validate
  - terraform plan
  - terraform apply
  - terraform destroy   

## Terraform Workflow

Write → Init → Validate → Plan → Apply → Destroy

---

### 1. Write Configuration

Create `.tf` files to define your infrastructure as code.

**Example: Create a custom VPC**
```hcl
resource "google_compute_network" "vpc1" {
  name                    = "vpc1"
  auto_create_subnetworks = false
}
```

---

### 2. terraform init

Initializes the directory and sets up the backend and required providers.

```bash
# Configure GCP Credentials (ADC: Application Default Credentials)
gcloud auth application-default login

# Initialize Terraform
terraform init
Observation:
1) Downloaded the provider plugins (initialized plugins)
2) Review the folder structure ".terraform folder"
```

**Observations:**
- Initialized Local Backend
- Downloads provider plugins (e.g., `google`)
- Initializes `.terraform/` directory for state and cache

---

### 3. terraform validate

Checks the syntax and internal consistency of your `.tf` code.

```bash
terraform validate
```

**Observations:**
-  Tt performs a basic syntax check on your Terraform configuration files to ensure they are syntactically valid and internally consistent (no resource creation)
- Helps catch syntax issues early

---

### 4. terraform plan

Generates an execution plan. Shows what Terraform will do without actually doing it.

```bash
terraform plan
```

**Observations:**
- Verify the plan
- Verify the number of resources that going to get created
- Plan Output: `terraform plan` generates an execution plan that shows what actions Terraform will take to achieve the desired state described in your configuration files.
- Lists resources to **create/update/destroy**
- Helps review changes before applying

---

### 5. terraform apply

Executes the plan and provisions the infrastructure.

```bash
terraform apply
# or skip confirmation:
terraform apply -auto-approve
```

**Observations:**
- Creates real resources on GCP
- Will create terraform.tfstate file when you run the terraform apply command containing all the resource information.

---

###  6. Verify on Google Cloud

- Go to **Google Cloud Console > VPC Networks > vpc1**
- Validate that the VPC has been created

---

### 7. terraform destroy

Tears down all resources defined in the current `.tf` files.

```bash
terraform destroy
```

**Optional Cleanup:**
```bash
rm -rf .terraform*
rm -rf terraform.tfstate*
```

---

## Key Takeaway

> Terraform’s power lies in its predictable **workflow**, not just commands. Once the **Write → Plan → Apply** flow is clear, managing any infrastructure becomes seamless.
