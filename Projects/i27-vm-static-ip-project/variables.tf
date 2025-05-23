variable "project_id" {
  type        = string
  description = "GCP Project ID"
  default = ""
}

variable "vpc_name" {
  type        = string
  default     = "task1-vpc"
}

variable "region_1" {
  type    = string
  default = "us-central1"
}

variable "region_2" {
  type    = string
  default = "asia-southeast1"
}

variable "subnet_1_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "subnet_2_cidr" {
  type    = string
  default = "10.20.0.0/16"
}

variable "vm_name" {
  type    = string
  default = "task1-vm"
}

variable "machine_type" {
  type    = string
  default = "e2-medium"
}

variable "enable_startup_script" {
  type    = bool
  default = true
}