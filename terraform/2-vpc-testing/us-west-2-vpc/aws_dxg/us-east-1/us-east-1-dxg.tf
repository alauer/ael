/*
provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::696238294826:role/DevAdmin"
  }
  region = "us-east-1"
}

resource "aws_dx_gateway" "ael-demo-dxg" {
  name            = "ael-demo-dxg1"
  amazon_side_asn = "64512"
}



resource "aws_dx_gateway_association" "ael-demo-dxg-gateway-attach-use1" {
  dx_gateway_id = "${aws_dx_gateway.ael-demo-dxg.id}"
  vpn_gateway_id = "${module.vpc-us-west-2.vgw_id}"
}
*/

/*
resource "aws_dx_gateway_association" "ael-kb-test-gateway-attach2" {
  dx_gateway_id = "${aws_dx_gateway.ael-kb-test.id}"
  vpn_gateway_id = "${module.vpc-eu-west-1.vgw_id}"
}
*/

#resource "aws_dx_private_virtual_interface" "vif-ael-kb-primary" {
#  connection_id = "${var.dx_connection_id_primary}"

#  dx_gateway_id = "${aws_dx_gateway.ael-kb-test.id}"

#  name = "vif-ael-kb-primary"
#  vlan = "${var.pureport_vlan_primary}"
#  amazon_address = "169.254.1.1/30"   #This needs to be in a variables file
#  customer_address = "169.254.1.2/30"   #This needs to be in a variables file
#  bgp_auth_key = "${var.bgp_auth_key_primary}"   #This needs to be in a variables file
#  address_family = "ipv4"
#  bgp_asn = "${var.bgp_pureport_asn}"   #This needs to be in a variables file
#}

#resource "aws_dx_private_virtual_interface" "vif-ael-kb-secondary" {
#  connection_id = "${var.dx_connection_id_secondary}"

#  dx_gateway_id = "${aws_dx_gateway.ael-kb-test.id}"

#  name = "vif-ael-kb-secondary"
#  vlan = "${var.pureport_vlan_secondary}"
#  amazon_address = "169.254.2.1/30"   #This needs to be in a variables file
#  customer_address = "169.254.2.2/30"   #This needs to be in a variables file
#  bgp_auth_key = "${var.bgp_auth_key_secondary}"   #This needs to be in a variables file
#  address_family = "ipv4"
#  bgp_asn = "${var.bgp_pureport_asn}"   #This needs to be in a variables file
#}
