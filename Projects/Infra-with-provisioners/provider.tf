terraform {
  required_providers {
    google = {
        source = "hashicorp/google"
        version = "5.42.0"
    }
  }
}



# Provider block for default project-a
provider "google" {
  project = var.project_id
  region = "us-central1" 
}
