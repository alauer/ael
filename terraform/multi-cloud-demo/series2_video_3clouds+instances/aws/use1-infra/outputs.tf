output "ec2_host_id" {
  description = "EC2 Instance ID"
  value       = "${module.us-east-1-ec2.id[0]}"
}

output "ec2_public_ip" {
  description = "EC2 Public IP address"
  value       = "${module.us-east-1-ec2.public_ip[0]}"
}

output "ec2_private_ip" {
  description = "EC2 Private IP address"
  value       = "${module.us-east-1-ec2.private_ip[0]}"
}
