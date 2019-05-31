/*
output "ael_use1_terraform_lab_dx_primary_id" {
  description = "Primary resource ID"
  value       = "${pureport_aws_connection.ael-use1-terraform-lab.gateways.0.remote_id}"
}

output "ael_use1_terraform_lab_dx_secondary_id" {
  description = "Secondary resource ID"
  value       = "${pureport_aws_connection.ael-use1-terraform-lab.gateways.1.remote_id}"
}

output "ael_use1_terraform_lab_aws_dx_vlan_primary_gw" {
  description = "VLAN assigned to Primary"
  value       = "${pureport_aws_connection.ael-use1-terraform-lab.gateways.0.vlan}"
}

output "ael_use1_terraform_lab_aws_dx_vlan_secondary_gw" {
  description = "VLAN assigned to Secondary"
  value       = "${pureport_aws_connection.ael-use1-terraform-lab.gateways.1.vlan}"
}

output "ael_use1_terraform_lab_bgp_password_primary_gw" {
  description = "BGP primary auth key"
  value       = "${pureport_aws_connection.ael-use1-terraform-lab.gateways.0.bgp_password}"
}

output "ael_use1_terraform_lab_bgp_password_secondary_gw" {
  description = "BGP secondary auth key"
  value       = "${pureport_aws_connection.ael-use1-terraform-lab.gateways.1.bgp_password}"
}

output "ael_use1_terraform_lab_bgp_pureport_asn" {
  value = "${pureport_aws_connection.ael-use1-terraform-lab.gateways.0.pureport_asn}"
}

output "ael_use1_terraform_lab_bgp_customer_asn" {
  value = "${pureport_aws_connection.ael-use1-terraform-lab.gateways.0.customer_asn}"
}
*/
output "ael_use1_terraform_lab" {
  value = "${pureport_aws_connection.ael-use1-terraform-lab.gateways}"
}

output "ael_westus_terraform_lab" {
  value = "${pureport_azure_connection.ael_westus_terraform_lab.gateways}"
}

/*
Primary vlan
Secondary vlan
Pureport ASN
bgp_auth_key_primary
bgp_auth_key_secondary
*/

