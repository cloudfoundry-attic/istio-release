# TODO(gabe): do we need a firewall rule to allow this healthcheck?
resource "google_compute_http_health_check" "cf-istio-router" {
  name         = "${var.env_id}-cf-istio-router"
  port         = 8001
  request_path = "/healthcheck/ok"
}

resource "google_compute_target_pool" "cf-istio-router" {
  name = "${var.env_id}-cf-istio-router"

  session_affinity = "NONE"

  health_checks = [
    "${google_compute_http_health_check.cf-istio-router.name}",
  ]
}

resource "google_compute_firewall" "cf-istio-router" {
  name       = "${var.env_id}-cf-istio-router"
  depends_on = ["google_compute_network.bbl-network"]
  network    = "${google_compute_network.bbl-network.name}"

  allow {
    protocol = "tcp"
    ports    = ["80","443"]
  }

  target_tags = ["${google_compute_target_pool.cf-istio-router.name}"]
}

resource "google_compute_firewall" "cf-istio-router-health-check" {
  name       = "${var.env_id}-cf-istio-router-health-check"
  depends_on = ["google_compute_network.bbl-network"]
  network    = "${google_compute_network.bbl-network.name}"

  allow {
    protocol = "tcp"
    ports    = ["8001"]
  }

  source_ranges = ["209.85.152.0/22", "209.85.204.0/22", "35.191.0.0/16"]
  target_tags = ["${google_compute_target_pool.cf-istio-router.name}"]
}

resource "google_compute_forwarding_rule" "cf-istio-router-http" {
  name        = "${var.env_id}-cf-istio-router-http"
  target      = "${google_compute_target_pool.cf-istio-router.self_link}"
  port_range  = "80"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.cf-istio-router.address}"
}

resource "google_compute_forwarding_rule" "cf-istio-router-https" {
  name        = "${var.env_id}-cf-istio-router-https"
  target      = "${google_compute_target_pool.cf-istio-router.self_link}"
  port_range  = "443"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.cf-istio-router.address}"
}


resource "google_compute_address" "cf-istio-router" {
  name = "${var.env_id}-cf-istio-router"
}

resource "google_dns_record_set" "cf-istio-router-dns" {
  name       = "istio.${google_dns_managed_zone.env_dns_zone.dns_name}"
  depends_on = ["google_compute_address.cf-istio-router"]
  type       = "A"
  ttl        = 300

  managed_zone = "${google_dns_managed_zone.env_dns_zone.name}"

  rrdatas = ["${google_compute_address.cf-istio-router.address}"]
}


output "istio_router_lb_ip" {
  value = "${google_compute_address.cf-istio-router.address}"
}

output "istio_router_target_pool" {
  value = "${google_compute_target_pool.cf-istio-router.name}"
}
