# modules/load_balancer/variables.tf

variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "backend_service_name" {
  description = "Name for the backend service"
  type        = string
}

variable "health_check_name" {
  description = "Name for the health check"
  type        = string
}

variable "instance_group" {
  description = "URL of the instance group for the backend service"
  type        = string
  default     = null
}

variable "private_key_path" {
  description = "Path to the private key file for SSL"
  type        = string
  default     = "ssl/privkey.pem"
}

variable "certificate_path" {
  description = "Path to the certificate file for SSL"
  type        = string
  default     = "ssl/cert.pem"
}