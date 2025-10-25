variable "subnet_name" {
  description = "Name of the Subnet"
  type        = string
}


variable "region" {
    description = "Region where the subnet will be created"
    type        = string
}


variable "subnet_cidr" {
  description = "CIDR range for the subnet"
  type        = string
}


variable "vpc_id" {
  description = "ID of the VPC where the subnet will be created"
  type        = string
}
