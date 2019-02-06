variable "dx_connection_id_primary" {}
variable "dx_connection_id_secondary" {}
variable "bgp_pureport_asn" {}
variable "pureport_vlan_primary" {}
variable "pureport_vlan_secondary" {}
variable "bgp_auth_key_primary" {}
variable "bgp_auth_key_secondary" {}


resource "aws_dx_gateway" "ael-kb-test" {
  name            = "ael-kb-dxg1"
  amazon_side_asn = "64512"
}

resource "aws_dx_gateway_association" "ael-kb-test-gateway-attach1" {
  dx_gateway_id = "${aws_dx_gateway.ael-kb-test.id}"
  vpn_gateway_id = "${module.vpc1.vgw_id}"
}

resource "aws_dx_gateway_association" "ael-kb-test-gateway-attach2" {
  dx_gateway_id = "${aws_dx_gateway.ael-kb-test.id}"
  vpn_gateway_id = "${module.vpc2.vgw_id}"
}

resource "aws_dx_private_virtual_interface" "vif-ael-kb-primary" {
  connection_id = "${var.dx_connection_id_primary}"

  dx_gateway_id = "${aws_dx_gateway.ael-kb-test.id}"

  name = "vif-ael-kb-primary"
  vlan = "${var.pureport_vlan_primary}"
  amazon_address = "169.254.1.1/30"   #This needs to be in a variables file
  customer_address = "169.254.1.2/30"   #This needs to be in a variables file
  bgp_auth_key = "${var.bgp_auth_key_primary}"   #This needs to be in a variables file
  address_family = "ipv4"
  bgp_asn = "${var.bgp_pureport_asn}"   #This needs to be in a variables file
}

resource "aws_dx_private_virtual_interface" "vif-ael-kb-secondary" {
  connection_id = "${var.dx_connection_id_secondary}"

  dx_gateway_id = "${aws_dx_gateway.ael-kb-test.id}"

  name = "vif-ael-kb-secondary"
  vlan = "${var.pureport_vlan_secondary}"
  amazon_address = "169.254.2.1/30"   #This needs to be in a variables file
  customer_address = "169.254.2.2/30"   #This needs to be in a variables file
  bgp_auth_key = "${var.bgp_auth_key_secondary}"   #This needs to be in a variables file
  address_family = "ipv4"
  bgp_asn = "${var.bgp_pureport_asn}"   #This needs to be in a variables file
}
