# VPC
output "vpc_id1" {
  description = "The ID of VPC1"
  value       = "${module.vpc1.vpc_id}"
}

output "vpc_id2" {
  description = "The ID of VPC2"
  value       = "${module.vpc2.vpc_id}"
}

# CIDR blocks
output "vpc_cidr_block1" {
  description = "The CIDR block of the VPC"
  value       = ["${module.vpc1.vpc_cidr_block}"]
}

output "vpc_cidr_block2" {
  description = "The CIDR block of the VPC"
  value       = ["${module.vpc2.vpc_cidr_block}"]
}

//output "vpc_ipv6_cidr_block" {
//  description = "The IPv6 CIDR block"
//  value       = ["${module.vpc.vpc_ipv6_cidr_block}"]
//}

# Subnets
output "private_subnets1" {
  description = "List of IDs of private subnets in VPC1"
  value       = ["${module.vpc1.private_subnets}"]
}

output "private_subnets2" {
  description = "List of IDs of private subnets in VPC2"
  value       = ["${module.vpc2.private_subnets}"]
}

output "public_subnets1" {
  description = "List of IDs of public subnets in VPC1"
  value       = ["${module.vpc1.public_subnets}"]
}
output "public_subnets2" {
  description = "List of IDs of public subnets in VPC2"
  value       = ["${module.vpc2.public_subnets}"]
}

# DXG
output "ael-kb-dxg1" {
  description = "List of IDs of DXG"
  value = ["${aws_dx_gateway.ael-kb-test.id}"]
}

output "ael-kb-exprt Service Key" {
  description = "Expressroute Service Key"
  value = ["${azurerm_express_route_circuit.ael-kb-exprt.service_key}"]
}
