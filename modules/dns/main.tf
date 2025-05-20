# modules/dns/main.tf

# Cloud DNS zone
resource "google_dns_managed_zone" "dns_zone" {
  name        = var.dns_zone_name
  dns_name    = "${var.domain_name}."
  description = "DNS zone for ${var.domain_name}"
  project     = var.project_id
}

# A record for the domain
resource "google_dns_record_set" "a_record" {
  name         = "${var.record_name}.${google_dns_managed_zone.dns_zone.dns_name}"
  managed_zone = google_dns_managed_zone.dns_zone.name
  type         = "A"
  ttl          = 300
  project      = var.project_id
  
  rrdatas = [var.load_balancer_ip]
}

# A record for the root domain
resource "google_dns_record_set" "root_a_record" {
  name         = google_dns_managed_zone.dns_zone.dns_name
  managed_zone = google_dns_managed_zone.dns_zone.name
  type         = "A"
  ttl          = 300
  project      = var.project_id
  
  rrdatas = [var.load_balancer_ip]
}

# CNAME record for www
resource "google_dns_record_set" "cname_record" {
  name         = "www.${google_dns_managed_zone.dns_zone.dns_name}"
  managed_zone = google_dns_managed_zone.dns_zone.name
  type         = "CNAME"
  ttl          = 300
  project      = var.project_id
  
  rrdatas = ["${var.domain_name}."]
}

# MX records for email
resource "google_dns_record_set" "mx_record" {
  name         = google_dns_managed_zone.dns_zone.dns_name
  managed_zone = google_dns_managed_zone.dns_zone.name
  type         = "MX"
  ttl          = 3600
  project      = var.project_id
  
  rrdatas = [
    "1 aspmx.l.google.com.",
    "5 alt1.aspmx.l.google.com.",
    "5 alt2.aspmx.l.google.com.",
    "10 alt3.aspmx.l.google.com.",
    "10 alt4.aspmx.l.google.com."
  ]
}