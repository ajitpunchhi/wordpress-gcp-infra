# modules/load_balancer/outputs.tf

output "load_balancer_ip" {
  description = "The IP address of the load balancer"
  value       = google_compute_global_address.default.address
}

output "http_forwarding_rule" {
  description = "The name of the HTTP forwarding rule"
  value       = google_compute_global_forwarding_rule.http.name
}

output "https_forwarding_rule" {
  description = "The name of the HTTPS forwarding rule"
  value       = google_compute_global_forwarding_rule.https.name
}

output "backend_service_name" {
  description = "The name of the backend service"
  value       = google_compute_backend_service.default.name
}