//variable "parent_zone_name" {}

resource "google_dns_record_set" "parent_dns_pointer" {
  name       = "${google_dns_managed_zone.env_dns_zone.dns_name}"
  depends_on = ["google_dns_managed_zone.env_dns_zone"]
  type       = "NS"
  ttl        = 300

  // managed_zone = "${var.parent_zone_name}"
  managed_zone = "c2c-zone"

  rrdatas = ["${google_dns_managed_zone.env_dns_zone.name_servers}"]
}
