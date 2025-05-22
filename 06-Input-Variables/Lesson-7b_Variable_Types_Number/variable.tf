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

variable "vm_name" {
  type        = string
  default     = "i27-webserver"
}

variable "machine_type" {
  type        = string
  default     = "e2-micro"
}

variable "ssh_priority" {
  type        = number
  description = "Priority for SSH firewall rule"
  default     = 1000
}

variable "http_priority" {
  type        = number
  description = "Priority for HTTP firewall rule"
  default     = 1000
}