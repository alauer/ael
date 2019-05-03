output "us-west1-interconnect_key1" {
  description = "Primary pairing key ${local.region1}"
  value       = "${google_compute_interconnect_attachment.pureport1.pairing_key}"
}

output "us-west1-interconnect_key2" {
  description = "Secondary pairing key ${local.region1}"
  value       = "${google_compute_interconnect_attachment.pureport2.pairing_key}"
}

output "us-central1-interconnect_key1" {
  description = "Primary pairing key ${local.region2}"
  value       = "${google_compute_interconnect_attachment.pureport3.pairing_key}"
}

output "us-central1-interconnect_key2" {
  description = "Secondary pairing key ${local.region2}"
  value       = "${google_compute_interconnect_attachment.pureport4.pairing_key}"
}
