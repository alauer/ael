output "ael_use1_terraform_lab" {
  value = "${pureport_aws_connection.ael-use1-terraform-lab.gateways}"
}

output "ael_westus_terraform_lab" {
  value = "${pureport_azure_connection.ael_westus_terraform_lab.gateways}"
}

output "ael_iad_vpn_terraform_lab" {
  value = "${pureport_site_vpn_connection.raleigh-lab.gateways}"
}

output "gce_primary_pairing_key" {
  value = "${google_compute_interconnect_attachment.pureport1.pairing_key}"
}

output "gce_secondary_pairing_key" {
  value = "${google_compute_interconnect_attachment.pureport2.pairing_key}"
}

/*
Primary vlan
Secondary vlan
Pureport ASN
bgp_auth_key_primary
bgp_auth_key_secondary
*/

