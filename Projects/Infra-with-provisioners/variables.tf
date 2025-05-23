variable "project_id" {
  type = string
}

variable "vpc_name" {
  type = string
}


variable "subnets" {
  description = "The details of the subnets to be created"
  type = list(object({
    name = string
    ip_cidr_range = string
    subnet_region = string
  }))
}

variable "firewall_name" {
  type = string
}

variable "source_ranges" {
  type = list(string)
}


variable "instances" {
  type = map(object({
    instance_type = string
    zone = string
    subnet = string
    disk_size = number
  }))
}



