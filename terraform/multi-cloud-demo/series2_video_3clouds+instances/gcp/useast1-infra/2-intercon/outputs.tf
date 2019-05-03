output "primary_interconnect_key" {
  description = "Primary pairing key"
  value       = "${google_compute_interconnect_attachment.pureport1.pairing_key}"
}

output "secondary_interconnect_key" {
  description = "Secondary pairing key"
  value       = "${google_compute_interconnect_attachment.pureport2.pairing_key}"
}
