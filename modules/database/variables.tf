# modules/database/variables.tf

variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}

variable "instance_name" {
  description = "The name of the database instance"
  type        = string
}

variable "database_name" {
  description = "The name of the WordPress database"
  type        = string
}

variable "user_name" {
  description = "The name of the database user"
  type        = string
}

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "db_tier" {
  description = "The tier for the database instance"
  type        = string
  default     = "db-f1-micro"
}

variable "disk_size" {
  description = "The disk size for the database instance in GB"
  type        = number
  default     = 20
}