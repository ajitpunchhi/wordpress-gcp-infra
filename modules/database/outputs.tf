# modules/database/outputs.tf

output "connection_name" {
  description = "The connection name of the instance"
  value       = google_sql_database_instance.instance.connection_name
}

output "database_ip" {
  description = "The private IP address of the database instance"
  value       = google_sql_database_instance.instance.private_ip_address
}

output "database_name" {
  description = "The name of the WordPress database"
  value       = google_sql_database.database.name
}

output "user_name" {
  description = "The name of the database user"
  value       = google_sql_user.user.name
}

output "secret_id" {
  description = "The ID of the secret in Secret Manager containing database connection info"
  value       = google_secret_manager_secret.db_connection.id
}