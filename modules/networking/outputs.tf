# modules/networking/outputs.tf

output "vpc_id" {
  description = "The ID of the VPC"
  value       = google_compute_network.vpc.id
}

output "vpc_name" {
  description = "The name of the VPC"
  value       = google_compute_network.vpc.name
}

output "subnet_id" {
  description = "The ID of the subnet"
  value       = google_compute_subnetwork.subnet.id
}

output "subnet_name" {
  description = "The name of the subnet"
  value       = google_compute_subnetwork.subnet.name
}

output "subnet_cidr" {
  description = "The CIDR block of the subnet"
  value       = google_compute_subnetwork.subnet.ip_cidr_range
}

output "pods_range_name" {
  description = "The name of the secondary IP range for pods"
  value       = "${var.subnet_name}-pod-range"
}