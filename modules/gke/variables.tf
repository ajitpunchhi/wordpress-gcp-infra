# modules/gke/variables.tf

variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for the GKE cluster"
  type        = string
}

variable "zones" {
  description = "The GCP zones for the GKE cluster"
  type        = list(string)
}

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

variable "node_count" {
  description = "The number of nodes per zone"
  type        = number
  default     = 1
}

variable "machine_type" {
  description = "The machine type for GKE nodes"
  type        = string
  default     = "e2-medium"
}

variable "min_node_count" {
  description = "Minimum number of nodes per zone"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum number of nodes per zone"
  type        = number
  default     = 3
}

variable "disk_size_gb" {
  description = "Disk size for each node in GB"
  type        = number
  default     = 100
}

variable "service_account" {
  description = "The service account for GKE nodes"
  type        = string
}