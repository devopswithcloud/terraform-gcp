variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  default     = "us-central1"
}

variable "zone" {
  type        = string
  default     = "us-central1-a"
}

variable "vpc_name" {
  type        = string
  default     = "i27-vpc"
}

variable "subnet_name" {
  type        = string
  default     = "i27-subnet"
}

variable "subnet_cidr" {
  type        = string
  default     = "10.6.0.0/16"
}

variable "environment" {
  type        = string
  default     = "dev"
}


# map of strings
variable "machine_types" {
  type = map(string)
  default = {
    dev   = "e2-micro"
    stage = "e2-small"
    prod  = "e2-medium"
  }
}

variable "enable_startup_script" {
  type    = bool
  default = false
}

variable "vm_tags" {
  type    = list(string)
  default = ["i27-ssh-network-tag", "i27-webserver-network-tag"]
}