output "dxg_resource_id" {
  description = "The Resource ID of the Direct Connect Gateway"
  value       = "${module.dxg.dxg_id}"
}

/*
output "dx_primary_id" {
  value = "${pureport_aws_connection.us-east-1.gateways.0.remote_id}"
}

output "dx_secondary_id" {
  value = "${pureport_aws_connection.us-east-1.gateways.1.remote_id}"
}
*/

