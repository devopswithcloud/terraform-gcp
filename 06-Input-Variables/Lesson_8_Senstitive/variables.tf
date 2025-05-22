variable "project_id" {
  type        = string
  description = "Your GCP Project ID"
}

variable "region" {
  type        = string
  default     = "us-central1"
}

variable "db_instance_name" {
  type        = string
  default     = "i27-db-instance"
}

variable "db_user" {
  type        = string
  default     = "i27admin"
}

variable "db_password" {
  type        = string
  description = "Database user password (kept sensitive)"
  sensitive   = true
}