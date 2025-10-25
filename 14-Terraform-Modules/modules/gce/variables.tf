variable "vm_name" {
  description = "Name of the VM instance"
  type        = string
}
variable "machine_type" {
  description = "Machine type of the VM instance"
  type        = string
}
variable "zone" {
  description = "Zone where the VM instance will be created"
  type        = string
}

variable "subnet_id" {
  description = "ID of the Subnet where the VM will be created"
  type        = string
}
