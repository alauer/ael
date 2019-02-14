provider "aws" {
  region  = "${var.region}"
  version = "~> 1.58"
}

terraform {
  required_version = ">= 0.10.3" # introduction of Local Values configuration language feature
}

resource "aws_dx_gateway" "this" {
  count           = "${var.dxg_name != "" && var.directconnect_primary_id != "" ? 1 : 0}"
  name            = "${var.dxg_name}"
  amazon_side_asn = "${var.amazon_side_asn}"

  timeouts {
    create = "20m"
    delete = "20m"
  }
}

resource "aws_dx_private_virtual_interface" "primary" {
  count         = "${var.directconnect_primary_id != "" ? 1 : 0}"
  connection_id = "${var.directconnect_primary_id}"

  dx_gateway_id = "${aws_dx_gateway.this.id}"

  name             = "vif-ael-demo-primary"
  vlan             = "${var.pureport_vlan_primary}"
  amazon_address   = "169.254.1.1/30"               #This needs to be in a variables file
  customer_address = "169.254.1.2/30"               #This needs to be in a variables file
  bgp_auth_key     = "${var.bgp_auth_key_primary}"  #This needs to be in a variables file
  address_family   = "ipv4"
  bgp_asn          = "${var.bgp_pureport_asn}"      #This needs to be in a variables file

  timeouts {
    create = "20m"
    delete = "20m"
    update = "20m"
  }
}

resource "aws_dx_private_virtual_interface" "secondary" {
  count         = "${var.directconnect_secondary_id != "" ? 1 : 0}"
  connection_id = "${var.directconnect_secondary_id}"

  dx_gateway_id = "${aws_dx_gateway.this.id}"

  name             = "vif-ael-demo-secondary"
  vlan             = "${var.pureport_vlan_secondary}"
  amazon_address   = "169.254.2.1/30"                 #This needs to be in a variables file
  customer_address = "169.254.2.2/30"                 #This needs to be in a variables file
  bgp_auth_key     = "${var.bgp_auth_key_secondary}"  #This needs to be in a variables file
  address_family   = "ipv4"
  bgp_asn          = "${var.bgp_pureport_asn}"        #This needs to be in a variables file

  timeouts {
    create = "20m"
    delete = "20m"
    update = "20m"
  }
}
