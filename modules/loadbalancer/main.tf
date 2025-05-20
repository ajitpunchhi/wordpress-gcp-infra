# modules/load_balancer/main.tf

# Reserve a static external IP address
resource "google_compute_global_address" "default" {
  name         = "wordpress-lb-ip"
  description  = "Static IP for WordPress Load Balancer"
  address_type = "EXTERNAL"
  project      = var.project_id
}

# Create HTTPS health check
resource "google_compute_health_check" "default" {
  name                = var.health_check_name
  project             = var.project_id
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2

  http_health_check {
    port         = 80
    request_path = "/wp-login.php"
  }
}

# Create backend service
resource "google_compute_backend_service" "default" {
  name                  = var.backend_service_name
  project               = var.project_id
  protocol              = "HTTP"
  port_name             = "http"
  timeout_sec           = 30
  health_checks         = [google_compute_health_check.default.id]
  load_balancing_scheme = "EXTERNAL"

  backend {
    group = var.instance_group
  }
}

# URL map
resource "google_compute_url_map" "default" {
  name            = "wordpress-url-map"
  project         = var.project_id
  default_service = google_compute_backend_service.default.id
}

# HTTP proxy
resource "google_compute_target_http_proxy" "default" {
  name    = "wordpress-http-proxy"
  project = var.project_id
  url_map = google_compute_url_map.default.id
}

# HTTPS proxy with SSL certificate
resource "google_compute_ssl_certificate" "default" {
  name        = "wordpress-ssl-cert"
  project     = var.project_id
  private_key = file(var.private_key_path)
  certificate = file(var.certificate_path)
}

resource "google_compute_target_https_proxy" "default" {
  name             = "wordpress-https-proxy"
  project          = var.project_id
  url_map          = google_compute_url_map.default.id
  ssl_certificates = [google_compute_ssl_certificate.default.id]
}

# Forwarding rule for HTTP
resource "google_compute_global_forwarding_rule" "http" {
  name       = "wordpress-http-forwarding-rule"
  project    = var.project_id
  target     = google_compute_target_http_proxy.default.id
  port_range = "80"
  ip_address = google_compute_global_address.default.address
}

# Forwarding rule for HTTPS
resource "google_compute_global_forwarding_rule" "https" {
  name       = "wordpress-https-forwarding-rule"
  project    = var.project_id
  target     = google_compute_target_https_proxy.default.id
  port_range = "443"
  ip_address = google_compute_global_address.default.address
}