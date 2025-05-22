provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_sql_database_instance" "i27_sql_instance" {
  name             = var.db_instance_name
  database_version = "MYSQL_8_0"
  region           = var.region

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        name  = "allow-public"
        value = "0.0.0.0/0"
      }
    }
  }

  deletion_protection = false
}

resource "google_sql_user" "i27_db_user" {
  name     = var.db_user
  instance = google_sql_database_instance.i27_sql_instance.name
  password = var.db_password
}

output "db_password_plain_test" {
  value     = var.db_password
  sensitive = true
}