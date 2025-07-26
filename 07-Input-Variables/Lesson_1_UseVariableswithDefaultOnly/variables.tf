variable "machine_type" {
  type        = string
  description = "The machine type for the VM instance"
  default     = "e2-micro"
}

variable "project_id" {
  type        = string
  description = "The GCP project ID"
  default     = "silver-tempo-455118-a5"
}
variable "region" {
  type        = string
  description = "The GCP region"
  default     = "us-central1"
}

variable "zone" {
  type        = string
  description = "The GCP zone"
  default     = "us-central1-a"
}


# --------------------------------------------- -------------------------------- ----------------
# This is for later use, not for this example
variable "instance_count" {
  type        = number
  description = "Number of instances to create"
  default     = 1
}
