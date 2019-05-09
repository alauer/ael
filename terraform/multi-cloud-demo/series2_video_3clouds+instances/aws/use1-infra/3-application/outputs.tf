output "rds_cluster_database_name" {
  description = "Name for an automatically created database on cluster creation"
  value       = "${module.db.this_rds_cluster_database_name}"
}

output "rds_cluster_endpoint" {
  description = "The cluster endpoint"
  value       = "${module.db.this_rds_cluster_endpoint}"
}

output "rds_cluster_master_username" {
  description = "The master username"
  value       = "${module.db.this_rds_cluster_master_username}"
}

output "rds_cluster_master_password" {
  description = "The master password"
  value       = "${module.db.this_rds_cluster_master_password}"
}

output "ec2_public_ip" {
  description = "List of public IP addresses assigned to the instances, if applicable"
  value       = ["${module.ec2.public_ip}"]
}

output "ec2_private_ip" {
  description = "List of private IP addresses assigned to the instances"
  value       = ["${module.ec2.private_ip}"]
}

/*
output "" {
  description = ""
  value       = "${module.db.}"
}
*/

