variable "project" {
    description = "The GCP project ID where resources will be created."
    type        = string
}

variable "region" {
    description = "The GCP region where resources will be created."
    type        = string
}

variable "zone" {
    description = "The GCP zone where resources will be created."
    type        = string
}

variable "vm_user" {
    description = "The username for the VM instances."
    type        = string
}

variable "iam_roles" {
  description = "List of IAM roles to assign to the service account"
  type        = list(string)
  default     = [
    "roles/owner"                 # Example: full access to most resources
  ]
}