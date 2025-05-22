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

variable "vm_config" {
  type = object({
    name         = string
    machine_type = string
    zone         = string
    tags         = list(string)
  })

  default = {
    name         = "i27-webserver"
    machine_type = "e2-micro"
    zone         = "us-central1-a"
    tags         = ["i27-ssh-network-tag", "i27-webserver-network-tag"]
  }
}