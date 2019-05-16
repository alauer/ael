/*
output "" {
  description = ""
  value       = "${module.db.}"
}
*/

output "vpc_cloud_router1" {
  description = "Primary Cloud Router"
  value       = "${google_compute_router.pureport1.self_link}"
}

output "vpc_cloud_router2" {
  description = "Secondary Cloud Router"
  value       = "${google_compute_router.pureport2.self_link}"
}

output "network_name" {
  value       = "${module.vpc.network_name}"
  description = "The name of the VPC being created"
}

output "network_self_link" {
  description = "VPC Name"
  value       = "${module.vpc.network_self_link}"
}

output "subnets_names" {
  value       = "${module.vpc.subnets_names}"
  description = "The names of the subnets being created"
}

output "subnets_ips" {
  value       = "${module.vpc.subnets_ips}"
  description = "The IPs and CIDRs of the subnets being created"
}

output "subnets_self_links" {
  value       = "${module.vpc.subnets_self_links}"
  description = "The self-links of subnets being created"
}

output "subnets_regions" {
  value       = "${module.vpc.subnets_regions}"
  description = "The region where the subnets will be created"
}
