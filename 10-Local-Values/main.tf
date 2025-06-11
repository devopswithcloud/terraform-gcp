terraform {
  required_providers {
    google = {
        source = "hashicorp/google"
        version = "5.42.0"
    }
  }
}


provider "google" {
  project = var.project
  region = var.region
}


variable "project" {
  type = string
  default = "********************"
}

variable "region" {
  type = string
  default = "us-central1"
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}


variable "env" {
  description = "Environment name (dev/stage/prod)"
  type = string
  default = "dev"
}




locals {
  # Naming 
  name_prefix = "${var.env}-app"
  tags = ["terraform", var.env]

  # GCS Bucket
  bucket_prefix = "${var.env}-bucket"
  region = var.region
  storage_class = "STANDARD"
  bucket_name = "${local.bucket_prefix}-${var.project}-${random_id.bucket_suffix.hex}"

  #GCE 
  instance_name  = "${local.name_prefix}-vm"
  machine_type = var.env == "prod" ? "e2-standard-4" : "e2-medium"
}

# Google Cloud Storage
resource "google_storage_bucket" "tf_bucket" {
  name = local.bucket_name
  location = local.region
  storage_class = local.storage_class
  project = var.project

  versioning {
    enabled = true
  }
  labels = {
    environment  = var.env
  }
  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 365 
    }
  }
}


# Google Compute Instance
resource "google_compute_instance" "tf_gce_vm" {
  name = local.instance_name
  machine_type = local.machine_type
  zone = "${var.region}-a"
  boot_disk {
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-minimal-2204-jammy-v20250424"
    }
  }
  network_interface {
    #
    subnetwork = "default"
    access_config {
      
    }
  }

  tags = local.tags
}


# Output
output "vm_name" {
  value = google_compute_instance.tf_gce_vm.name
}

output "bucket_name" {
  value = google_storage_bucket.tf_bucket.name
}
