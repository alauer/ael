output "dx_primary_id" {
  description = "Primary resource ID"
  value       = "${pureport_aws_connection.us-east-1.gateways.0.remote_id}"
}

output "dx_secondary_id" {
  description = "Secondary resource ID"
  value       = "${pureport_aws_connection.us-east-1.gateways.1.remote_id}"
}

output "aws_dx_vlan_primary_gw" {
  description = "VLAN assigned to Primary"
  value       = "${pureport_aws_connection.us-east-1.gateways.0.vlan}"
}

output "aws_dx_vlan_secondary_gw" {
  description = "VLAN assigned to Secondary"
  value       = "${pureport_aws_connection.us-east-1.gateways.1.vlan}"
}

output "bgp_password_primary_gw" {
  description = "BGP primary auth key"
  value       = "${pureport_aws_connection.us-east-1.gateways.0.bgp_password}"
}

output "bgp_password_secondary_gw" {
  description = "BGP secondary auth key"
  value       = "${pureport_aws_connection.us-east-1.gateways.1.bgp_password}"
}

/*
Primary vlan
Secondary vlan
Pureport ASN
bgp_auth_key_primary
bgp_auth_key_secondary
*/

