output "private_subnets" {
  description = "The Resource IDs of the Private Subnets"
  value       = "${module.vpc.private_subnets}"
}

output "public_subnets" {
  description = "The Resource IDs of the Public Subnets"
  value       = "${module.vpc.public_subnets}"
}

output "database_subnets" {
  description = "The Resource IDs of the Database Subnets"
  value       = "${module.vpc.database_subnets}"
}

output "vpc_id" {
  description = "The Resource ID of the VPC"
  value       = "${module.vpc.vpc_id}"
}
