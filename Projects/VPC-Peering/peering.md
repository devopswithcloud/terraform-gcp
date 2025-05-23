
# Terraform Configuration for VPC Peering Between Two VPCs

## Overview
This Terraform configuration creates a complex setup with the following resources:
- **Two VPC Networks** (VPC 1 and VPC 2) with their own subnets and firewall rules.
- **Two VM Instances** (one in each VPC).
- **Firewall Rules** to allow SSH, HTTP, and ICMP traffic in both VPCs.
- **VPC Peering** between VPC 1 and VPC 2, enabling communication between them.

## Resources Created

### 1. VPC 1 Configuration
- **Resource**: `google_compute_network.vpc1`
  - Creates the first VPC network named `vpc-network-1`.
  - **CIDR Block**: `10.0.0.0/16`.
- **Subnet**: `google_compute_subnetwork.subnet_vpc1`
  - A subnet is created within VPC 1 with the same CIDR block as the VPC.
- **Firewall Rules**:
  - **SSH Rule**: Allows SSH access to VPC 1 on port 22 from any source.
  - **HTTP Rule**: Allows HTTP traffic on port 80 from any source.
  - **ICMP Rule**: Allows ICMP traffic to VPC 1 from any source.
- **VM Instance**: `google_compute_instance.vm_instance_vpc1`
  - A VM instance is created within VPC 1.
  - The instance is connected to the subnet in VPC 1.

### 2. VPC 2 Configuration
- **Resource**: `google_compute_network.vpc2`
  - Creates the second VPC network named `vpc-network-2`.
  - **CIDR Block**: `10.1.0.0/16`.
- **Subnet**: `google_compute_subnetwork.subnet_vpc2`
  - A subnet is created within VPC 2 with the same CIDR block as the VPC.
- **Firewall Rules**:
  - **SSH Rule**: Allows SSH access to VPC 2 on port 22 from any source.
  - **HTTP Rule**: Allows HTTP traffic on port 80 from any source.
  - **ICMP Rule**: Allows ICMP traffic to VPC 2 from any source.
- **VM Instance**: `google_compute_instance.vm_instance_vpc2`
  - A VM instance is created within VPC 2.
  - The instance is connected to the subnet in VPC 2.

### 3. VPC Peering
- **VPC Peering** is established between **VPC 1** and **VPC 2**.
  - **Peering Request from VPC 1 to VPC 2**: Enables communication from VPC 1 to VPC 2.
  - **Peering Request from VPC 2 to VPC 1**: Enables communication from VPC 2 to VPC 1.

## Variables
- **Region**: The region where the resources are deployed. Default is `us-central1`.
- **Project ID**: The GCP project ID.

## Outputs
- **VPC 1 Self Link**: The self link of VPC 1.
- **VPC 2 Self Link**: The self link of VPC 2.
- **VPC 1 Subnet Self Link**: The self link of the subnet in VPC 1.
- **VPC 2 Subnet Self Link**: The self link of the subnet in VPC 2.
- **VPC Peering Status**: The status of the VPC peering between VPC 1 and VPC 2.

---

## Conclusion
This Terraform configuration provides a comprehensive setup of two VPCs with their own subnets, firewall rules, VM instances, and peering between the VPCs. This setup enables communication between the two VPCs while securing them with firewall rules for SSH, HTTP, and ICMP traffic.
