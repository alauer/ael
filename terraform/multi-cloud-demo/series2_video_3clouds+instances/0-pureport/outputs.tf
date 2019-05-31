output "ael_use1_terraform_lab" {
  value = "${pureport_aws_connection.ael-use1-terraform-lab.gateways}"
}

output "ael_westus_terraform_lab" {
  value = "${pureport_azure_connection.ael_westus_terraform_lab.gateways}"
}

output "ael_iad_vpn_terraform_lab" {
  value = "${pureport_site_vpn_connection.raleigh-lab.gateways}"
}

/*
Primary vlan
Secondary vlan
Pureport ASN
bgp_auth_key_primary
bgp_auth_key_secondary
*/

