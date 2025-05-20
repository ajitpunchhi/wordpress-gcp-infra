# outputs.tf - Root outputs

output "vpc_name" {
  description = "The name of the VPC network"
  value       = module.networking.vpc_name
}

output "subnet_name" {
  description = "The name of the subnet"
  value       = module.networking.subnet_name
}

output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = module.gke.cluster_name
}

output "cluster_endpoint" {
  description = "The endpoint for the GKE cluster"
  value       = module.gke.cluster_endpoint
  sensitive   = true
}

output "load_balancer_ip" {
  description = "The IP address of the load balancer"
  value       = module.load_balancer.load_balancer_ip
}

output "database_connection_name" {
  description = "The connection name of the MySQL instance"
  value       = module.database.connection_name
}

output "database_ip" {
  description = "The private IP address of the MySQL instance"
  value       = module.database.database_ip
}

output "website_url" {
  description = "The URL to access the WordPress site"
  value       = "https://${var.record_name}.${var.domain_name}"
}