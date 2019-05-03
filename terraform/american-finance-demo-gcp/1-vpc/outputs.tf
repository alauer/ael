output "vpc_cloud_router1" {
  description = "Primary Cloud Router"
  value       = "${google_compute_router.pureport1.self_link}"
}

output "vpc_cloud_router2" {
  description = "Secondary Cloud Router"
  value       = "${google_compute_router.pureport2.self_link}"
}

output "vpc_cloud_router3" {
  description = "Primary Cloud Router"
  value       = "${google_compute_router.pureport3.self_link}"
}

output "vpc_cloud_router4" {
  description = "Secondary Cloud Router"
  value       = "${google_compute_router.pureport4.self_link}"
}
