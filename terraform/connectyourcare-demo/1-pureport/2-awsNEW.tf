
resource "pureport_aws_connection" "ael_use1" {
  provider          = pureport.terraform-demo
  name              = "ael_use1"
  speed             = "1000"
  high_availability = true

  location_href = "/locations/us-wdc"
  network_href  = data.pureport_networks.main.networks[0].href

  aws_region     = "us-east-1"
  aws_account_id = "873060941818"
  peering_type   = "PRIVATE"

  provisioner "local-exec" {
    command = <<EOT
      aws --region us-east-1 directconnect confirm-connection --connection-id ${pureport_aws_connection.ael_use1.gateways[0].remote_id}
      aws --region us-east-1 directconnect confirm-connection --connection-id ${pureport_aws_connection.ael_use1.gateways[1].remote_id}
      sleep 300
EOT

  }
}

resource "aws_dx_transit_virtual_interface" "eastprimary" {
  provider      = aws.use1
  connection_id = pureport_aws_connection.ael_use1.gateways[0].remote_id

  dx_gateway_id = data.terraform_remote_state.cloudinfra.outputs.use1_dxg_id

  name             = "vif-${pureport_aws_connection.ael_use1.name}-primary"
  vlan             = pureport_aws_connection.ael_use1.gateways[0].vlan
  amazon_address   = pureport_aws_connection.ael_use1.gateways[0].customer_ip
  customer_address = pureport_aws_connection.ael_use1.gateways[0].pureport_ip
  bgp_auth_key     = pureport_aws_connection.ael_use1.gateways[0].bgp_password
  address_family   = "ipv4"
  bgp_asn          = pureport_aws_connection.ael_use1.gateways[0].pureport_asn

  tags = {
    Terraform   = "true"
    Owner       = "aaron.lauer"
    Environment = "oracle-latency"
  }

  timeouts {
    create = "20m"
    delete = "20m"
    update = "20m"
  }
}

resource "aws_dx_transit_virtual_interface" "eastsecondary" {
  provider      = aws.use1
  connection_id = pureport_aws_connection.ael_use1.gateways[1].remote_id

  dx_gateway_id = data.terraform_remote_state.cloudinfra.outputs.use1_dxg_id

  name             = "vif-${pureport_aws_connection.ael_use1.name}-secondary"
  vlan             = pureport_aws_connection.ael_use1.gateways[1].vlan
  amazon_address   = pureport_aws_connection.ael_use1.gateways[1].customer_ip
  customer_address = pureport_aws_connection.ael_use1.gateways[1].pureport_ip
  bgp_auth_key     = pureport_aws_connection.ael_use1.gateways[1].bgp_password
  address_family   = "ipv4"
  bgp_asn          = pureport_aws_connection.ael_use1.gateways[1].pureport_asn

  tags = {
    Terraform   = "true"
    Owner       = "aaron.lauer"
    Environment = "oracle-latency"
  }

  timeouts {
    create = "20m"
    delete = "20m"
    update = "20m"
  }
}

################################################################################

resource "pureport_aws_connection" "ael_usw1" {
  provider          = pureport.terraform-demo
  name              = "ael_usw1"
  speed             = "1000"
  high_availability = true

  location_href = "/locations/us-sjc"
  network_href  = data.pureport_networks.main.networks[0].href

  aws_region     = "us-west-1"
  aws_account_id = "873060941818"
  peering_type   = "PRIVATE"

  provisioner "local-exec" {
    command = <<EOT
      aws --region us-west-1 directconnect confirm-connection --connection-id ${pureport_aws_connection.ael_usw1.gateways[0].remote_id}
      aws --region us-west-1 directconnect confirm-connection --connection-id ${pureport_aws_connection.ael_usw1.gateways[1].remote_id}
      sleep 300
EOT

  }
}

resource "aws_dx_transit_virtual_interface" "west1primary" {
  provider      = aws.usw1
  connection_id = pureport_aws_connection.ael_usw1.gateways[0].remote_id

  dx_gateway_id = data.terraform_remote_state.cloudinfra.outputs.usw1_dxg_id

  name             = "vif-${pureport_aws_connection.ael_usw1.name}-primary"
  vlan             = pureport_aws_connection.ael_usw1.gateways[0].vlan
  amazon_address   = pureport_aws_connection.ael_usw1.gateways[0].customer_ip
  customer_address = pureport_aws_connection.ael_usw1.gateways[0].pureport_ip
  bgp_auth_key     = pureport_aws_connection.ael_usw1.gateways[0].bgp_password
  address_family   = "ipv4"
  bgp_asn          = pureport_aws_connection.ael_usw1.gateways[0].pureport_asn

  tags = {
    Terraform   = "true"
    Owner       = "aaron.lauer"
    Environment = "oracle-latency"
  }

  timeouts {
    create = "20m"
    delete = "20m"
    update = "20m"
  }
}

resource "aws_dx_transit_virtual_interface" "west1secondary" {
  provider      = aws.usw1
  connection_id = pureport_aws_connection.ael_usw1.gateways[1].remote_id

  dx_gateway_id = data.terraform_remote_state.cloudinfra.outputs.usw1_dxg_id

  name             = "vif-${pureport_aws_connection.ael_usw1.name}-secondary"
  vlan             = pureport_aws_connection.ael_usw1.gateways[1].vlan
  amazon_address   = pureport_aws_connection.ael_usw1.gateways[1].customer_ip
  customer_address = pureport_aws_connection.ael_usw1.gateways[1].pureport_ip
  bgp_auth_key     = pureport_aws_connection.ael_usw1.gateways[1].bgp_password
  address_family   = "ipv4"
  bgp_asn          = pureport_aws_connection.ael_usw1.gateways[1].pureport_asn

  tags = {
    Terraform   = "true"
    Owner       = "aaron.lauer"
    Environment = "oracle-latency"
  }

  timeouts {
    create = "20m"
    delete = "20m"
    update = "20m"
  }
}
