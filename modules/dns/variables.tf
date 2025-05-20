# modules/dns/variables.tf

variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "domain_name" {
  description = "The domain name"
  type        = string
}

variable "dns_zone_name" {
  description = "The name of the DNS zone"
  type        = string
}

variable "record_name" {
  description = "The record name (subdomain)"
  type        = string
}

variable "load_balancer_ip" {
  description = "The IP address of the load balancer"
  type        = string
}