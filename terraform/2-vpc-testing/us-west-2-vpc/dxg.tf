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
  connection_id = "dxcon-ffocf371"   #This needs to be in a variables file

  dx_gateway_id = "${aws_dx_gateway.ael-kb-test.id}"

  name = "vif-ael-kb-primary"
  vlan = 343   #This needs to be in a variables file
  amazon_address = "169.254.1.1/30"   #This needs to be in a variables file
  customer_address = "169.254.1.2/30"   #This needs to be in a variables file
  bgp_auth_key = "bh3knqcdlMaW4qLD3LOi4"   #This needs to be in a variables file
  address_family = "ipv4"
  bgp_asn = 394351   #This needs to be in a variables file
}

resource "aws_dx_private_virtual_interface" "vif-ael-kb-secondary" {
  connection_id = "dxcon-fg442gu7"   #This needs to be in a variables file

  dx_gateway_id = "${aws_dx_gateway.ael-kb-test.id}"

  name = "vif-ael-kb-secondary"
  vlan = 311   #This needs to be in a variables file
  amazon_address = "169.254.2.1/30"   #This needs to be in a variables file
  customer_address = "169.254.2.2/30"   #This needs to be in a variables file
  bgp_auth_key = "MbHKTLsxvdauWNyAFV1WO"   #This needs to be in a variables file
  address_family = "ipv4"
  bgp_asn = 394351   #This needs to be in a variables file
}
