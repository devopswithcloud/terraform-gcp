
# Project: Infrastructure as Code (IaC) Assignment

## Objective
You are given the following infrastructure requirements.  
Based on these, you need to **write Terraform code** to provision the required Google Cloud resources.

---

## Infrastructure Requirements

### 1. Provider Setup
- Use **Google Cloud Platform** as the provider.
- Set the project ID as: ``
- Default region: `us-central1`
- Assume credentials are already configured or will be passed via environment.

---

### 2. Networking

- Create a **custom VPC** named `i27-ecommerce-vpc`.  
- The VPC must **NOT** auto-create subnetworks (i.e., `auto_create_subnetworks = false`).
- We should be providing a way to create multiple subnets in different regions and cidr ranges. 
- Create the following **subnets** inside the VPC:

| Subnet Name                    | Region        | CIDR Range    |
|---------------------------------|---------------|---------------|
| i27-ecommerce-central-subnet    | us-central1   | 10.1.0.0/16   |
| i27-ecommerce-east4-subnet      | us-east4      | 10.2.0.0/16   |

---

### 3. Firewall

- Create a **firewall rule** attached to the `i27-ecommerce-vpc`.
- Allow incoming **TCP** traffic on the following ports:
  - 22 (SSH)
  - 80 (HTTP)
  - 8080 (Application)
  - 9000 (SonarQube)
- Use `dynamic`
- Allow connections from **any IP address** (`0.0.0.0/0`).

---

### 4. Compute Instances
- Create keys.
- Place those keys in to GCE metadata. 
- Create GCE instances so that i can login to those vms using by custom keys .
- Install ansible packages on `ansible` vm only and not on other vms created. 
- Create the following **virtual machines** based on the given details:

| Instance Name  | Machine Type | Zone          | Subnet                          | Disk Size (GB) |
|----------------|--------------|---------------|----------------------------------|----------------|
| ansible        | e2-medium     | us-central1-a | i27-ecommerce-central-subnet     | 10             |
| jenkins-master | e2-medium     | us-east4-b    | i27-ecommerce-east4-subnet       | 10             |
| jenkins-slave  | e2-medium     | us-east4-b    | i27-ecommerce-east4-subnet       | 20             |
| sonarqube      | e2-medium     | us-central1-a | i27-ecommerce-central-subnet     | 10             |
| docker-server      | n1-stardard-1     | us-central1-a | i27-ecommerce-central-subnet     | 10             |

- All instances should allow SSH access via their public IPs.

---

### 5. Outputs

- Display the **public** and **private IP addresses** of all VMs after deployment.
- Additionally, provide **ready-to-use SSH command outputs** for connecting to:
  - ansible
  - jenkins-master
  - jenkins-slave

Example SSH output:
```bash
ssh -i id_rsa <username>@<public-ip-address>
```

✅ Username to use: `maha`

---

### 6. Variables
- Use **variables** to manage:
  - VPC name
  - Subnets (as a list of objects)
  - Instances (as a map of objects)
  - VM username
  - Source ranges for firewall

✅ These inputs must be provided through a `terraform.tfvars` file.

---

## Bonus Points ⭐
- Use **`for_each`** or **`count`** wherever appropriate.
- Use **meta-arguments** like `depends_on` if you think resource creation must be ordered.
- Organize the code neatly into logical sections (Provider, Network, Firewall, Compute, Outputs, Variables).

---

# 📦 Deliverables

- `main.tf`
- `variables.tf`
- `terraform.tfvars`
- `outputs.tf` (if outputs are separated)
- Any optional `README.md` explaining the structure (bonus)

---

# ✨ Note
- Do **NOT** hardcode values inside the resource blocks.
- Use **variables** and **outputs** properly.
- Keep the code modular and clean.

---

# 🎯 Sample terraform.tfvars you should handle

```hcl
vpc_name = "i27-ecommerce-vpc"

subnets = [
    {
        name = "i27-ecommerce-central-subnet"
        ip_cidr_range = "10.1.0.0/16"
        subnet_region = "us-central1"
    },
    {
        name = "i27-ecommerce-east4-subnet"
        ip_cidr_range = "10.2.0.0/16"
        subnet_region = "us-east4"
    }
]

instances  = {
    "ansible" = {
        instance_type = "e2-medium"
        zone = "us-central1-a"
        subnet = "i27-ecommerce-central-subnet"
        disk_size = 10
    },
    "jenkins-master" = {
        instance_type = "e2-medium"
        zone = "us-east4-b"
        subnet = "i27-ecommerce-east4-subnet"
        disk_size = 10   
    },
    "jenkins-slave" = {
        instance_type = "e2-medium"
        zone = "us-east4-b"
        subnet = "i27-ecommerce-east4-subnet"
        disk_size = 20
    },
    "sonarqube" = {
        instance_type = "e2-medium"
        zone = "us-central1-a"
        subnet = "i27-ecommerce-central-subnet"
        disk_size = 10
    }
}

vm_user = "maha"

source_ranges = ["0.0.0.0/0"]
```

---
