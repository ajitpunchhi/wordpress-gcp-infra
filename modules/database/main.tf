# modules/database/main.tf

# Generate a random password for the database
resource "random_password" "password" {
  length  = 16
  special = true
}

# Create a dedicated MySQL instance
resource "google_sql_database_instance" "instance" {
  name             = var.instance_name
  region           = var.region
  database_version = "MYSQL_8_0"
  project          = var.project_id

  settings {
    tier              = var.db_tier
    availability_type = "REGIONAL"
    
    backup_configuration {
      enabled            = true
      binary_log_enabled = true
      start_time         = "01:00" # 1am UTC
    }
    
    maintenance_window {
      day          = 7  # Sunday
      hour         = 2  # 2am
      update_track = "stable"
    }
    
    ip_configuration {
      ipv4_enabled    = false
      private_network = "projects/${var.project_id}/global/networks/${var.network_name}"
    }
    
    disk_autoresize = true
    disk_size       = var.disk_size
    disk_type       = "PD_SSD"
    
    database_flags {
      name  = "character_set_server"
      value = "utf8mb4"
    }
    
    database_flags {
      name  = "collation_server"
      value = "utf8mb4_unicode_ci"
    }
  }

  deletion_protection = true
}

# Create the WordPress database
resource "google_sql_database" "database" {
  name     = var.database_name
  instance = google_sql_database_instance.instance.name
  project  = var.project_id
}

# Create a user for the WordPress database
resource "google_sql_user" "user" {
  name     = var.user_name
  instance = google_sql_database_instance.instance.name
  password = random_password.password.result
  project  = var.project_id
}

# Store the database connection details in Secret Manager
resource "google_secret_manager_secret" "db_connection" {
  secret_id = "wordpress-db-connection"
  project   = var.project_id
  
  replication {
    #automatic = true
  }
}

resource "google_secret_manager_secret_version" "db_connection_version" {
  secret      = google_secret_manager_secret.db_connection.id
  secret_data = <<-EOF
    {
      "host": "${google_sql_database_instance.instance.private_ip_address}",
      "database": "${google_sql_database.database.name}",
      "username": "${google_sql_user.user.name}",
      "password": "${random_password.password.result}"
    }
  EOF
}