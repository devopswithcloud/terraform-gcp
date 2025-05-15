
# Comprehensive Guide to Using Outputs in Terraform (with GCP Example)

In this guide, we will explore how to use the `outputs` section in Terraform to retrieve and display useful information about your GCP infrastructure.

> ⚠️ **Note**: This documentation assumes you are using the Terraform code we previously defined for:
> - VPC (`google_compute_network.tf_vpc`)
> - Subnet (`google_compute_subnetwork.tf_subnet`)
> - Firewall rules (`google_compute_firewall.tf_ssh`, `tf_http`)
> - GCE Instance (`google_compute_instance.tf_gce_vm`)

This ensures consistency with your current project and helps you get accurate results.

---

## Method 1: Basic Outputs

### `outputs.tf`

```hcl
output "vpc_id" {
  description = "The ID of the VPC"
  value       = google_compute_network.tf_vpc.id
}

output "subnet_id" {
  description = "The ID of the Subnet"
  value       = google_compute_subnetwork.tf_subnet.id
}

output "instance_external_ip" {
  description = "The external IP address of the GCE instance"
  value       = google_compute_instance.tf_gce_vm.network_interface[0].access_config[0].nat_ip
}

output "firewall_rule_names" {
  description = "The names of the firewall rules created"
  value       = [google_compute_firewall.tf_ssh.name, google_compute_firewall.tf_http.name]
}
```

---

## Method 2: Conditional Outputs

```hcl
output "instance_name_if_micro" {
  description = "The name of the instance if it is of type e2-micro"
  value       = google_compute_instance.tf_gce_vm.machine_type == "e2-micro" ? google_compute_instance.tf_gce_vm.name : null
}
```

---

## Method 3: Sensitive Outputs

```hcl
output "sensitive_instance_ip" {
  description = "The external IP address of the GCE instance (sensitive)"
  value       = google_compute_instance.tf_gce_vm.network_interface[0].access_config[0].nat_ip
  sensitive   = true
}
```

---

## Method 4: Complex Outputs (Map)

```hcl
output "instance_details" {
  description = "A map of details for the GCE instance"
  value = {
    name         = google_compute_instance.tf_gce_vm.name
    machine_type = google_compute_instance.tf_gce_vm.machine_type
    zone         = google_compute_instance.tf_gce_vm.zone
    external_ip  = google_compute_instance.tf_gce_vm.network_interface[0].access_config[0].nat_ip
  }
}
```

---

##  Method 5: Referencing Outputs from a Module

#### Inside `module/networking/outputs.tf`

```hcl
output "vpc_id" {
  description = "The ID of the VPC"
  value       = google_compute_network.tf_vpc.id
}
```

#### Inside root `main.tf`

```hcl
module "networking" {
  source = "./module/networking"
}

output "vpc_id_from_module" {
  description = "The VPC ID retrieved from the networking module"
  value       = module.networking.vpc_id
}
```

---

## Best Practices

| Practice                          | Benefit                                       |
|----------------------------------|-----------------------------------------------|
| Use `description` in every output| Helps team members understand each output     |
| Use `sensitive = true`           | Secure secrets/IPs from accidental exposure   |
| Structure outputs using maps     | Logical grouping of related values            |
| Avoid unnecessary outputs        | Only expose what's truly needed               |

---

## Classroom Demo Steps

1. Apply Terraform code you already wrote (VPC, subnet, firewall, VM).
2. Add each output type and re-run `terraform apply`.
3. Show CLI behavior for basic, sensitive, and complex outputs.

---
