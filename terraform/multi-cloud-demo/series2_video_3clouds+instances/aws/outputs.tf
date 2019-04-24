output "aws_public_subnet" {
  description = "Public Subnet ID"
  value       = "${module.vpc1-us-east-1.aws_public_subnets[0]}"
}

output "aws_private_subnet" {
  description = "Private Subnet ID"
  value       = "${module.vpc1-us-east-1.aws_private_subnets[0]}"
}

output "security_groups" {
  description = "VPC Security Groups"
  value       = ["${module.vpc1-us-east-1.aws_security_groups}"]
}
