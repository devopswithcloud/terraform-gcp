variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "vpc_name" {
  type    = string
  default = "i27-vpc"
}

variable "subnet_name" {
  type    = string
  default = "i27-subnet"
}

variable "subnet_cidr" {
  type    = string
  default = "10.6.0.0/16"
}

variable "vm_list" {
  description = "List of VMs to create"
  type = list(object({
    name         = string
    machine_type = string
    zone         = string
    tags         = list(string)
  }))
}