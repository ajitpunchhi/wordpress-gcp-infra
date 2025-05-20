# variables.tf - Root variables

# General GCP settings
variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for resources"
  type        = string
}

variable "zones" {
  description = "The GCP zones for the GKE cluster"
  type        = list(string)
}

# VPC and networking variables
variable "vpc_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
}

variable "subnet_range" {
  description = "Secondary IP range for pods"
  type        = string
}

# GKE cluster variables
variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "node_count" {
  description = "Number of nodes per zone in the GKE cluster"
  type        = number
}

variable "machine_type" {
  description = "Machine type for GKE nodes"
  type        = string
}

variable "min_node_count" {
  description = "Minimum number of nodes per zone"
  type        = number
}

variable "max_node_count" {
  description = "Maximum number of nodes per zone"
  type        = number
}

variable "disk_size_gb" {
  description = "Disk size for each node in GB"
  type        = number
}

variable "service_account" {
  description = "Service account for GKE nodes"
  type        = string
}

# DNS variables
variable "domain_name" {
  description = "Domain name for the website"
  type        = string
}

variable "dns_zone_name" {
  description = "Name of the DNS zone"
  type        = string
}

variable "record_name" {
  description = "DNS record name"
  type        = string
}

# Load balancer variables
variable "backend_service_name" {
  description = "Name for the backend service"
  type        = string
}

variable "health_check_name" {
  description = "Name for the health check"
  type        = string
}

# Database variables
variable "db_instance_name" {
  description = "Name for the database instance"
  type        = string
}

variable "database_name" {
  description = "Name for the WordPress database"
  type        = string
}

variable "db_user_name" {
  description = "Username for the database"
  type        = string
}