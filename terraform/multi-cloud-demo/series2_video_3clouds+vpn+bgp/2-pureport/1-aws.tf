resource "pureport_aws_connection" "ael-use1-terraform-lab" {
  provider          = pureport.terraform-testing
  name              = "ael-use1-terraform-lab"
  speed             = "50"
  high_availability = true

  location_href = data.pureport_locations.iad.locations[0].href
  network_href  = data.pureport_networks.main.networks[0].href

  aws_region     = "us-east-1"
  aws_account_id = "873060941818"
  peering_type   = "PRIVATE"

  provisioner "local-exec" {
    command = <<EOT
      aws directconnect confirm-connection --connection-id ${pureport_aws_connection.ael-use1-terraform-lab.gateways[0].remote_id}
      aws directconnect confirm-connection --connection-id ${pureport_aws_connection.ael-use1-terraform-lab.gateways[1].remote_id}
      sleep 300
EOT

  }
  //  provisioner "local-exec" {
  //    command = "aws directconnect confirm-connection --connection-id ${pureport_aws_connection.ael-use1-terraform-lab.gateways.1.remote_id}; sleep 180"
  //  }
}

resource "aws_dx_private_virtual_interface" "primary" {
  provider = aws.use1
  connection_id = pureport_aws_connection.ael-use1-terraform-lab.gateways[0].remote_id

  dx_gateway_id = data.terraform_remote_state.cloudinfra.outputs.dxg_id

  name = "vif-${pureport_aws_connection.ael-use1-terraform-lab.name}-primary"
  vlan = pureport_aws_connection.ael-use1-terraform-lab.gateways[0].vlan
  amazon_address = pureport_aws_connection.ael-use1-terraform-lab.gateways[0].customer_ip #This needs to be in a variables file
  customer_address = pureport_aws_connection.ael-use1-terraform-lab.gateways[0].pureport_ip #This needs to be in a variables file
  bgp_auth_key = pureport_aws_connection.ael-use1-terraform-lab.gateways[0].bgp_password #This needs to be in a variables file
  address_family = "ipv4"
  bgp_asn = pureport_aws_connection.ael-use1-terraform-lab.gateways[0].pureport_asn

  tags = {
    Terraform = "true"
    Owner = "aaron.lauer"
    Environment = "2-pureport"
  }

  timeouts {
    create = "20m"
    delete = "20m"
    update = "20m"
  }
}

resource "aws_dx_private_virtual_interface" "secondary" {
  provider = aws.use1
  connection_id = pureport_aws_connection.ael-use1-terraform-lab.gateways[1].remote_id

  dx_gateway_id = data.terraform_remote_state.cloudinfra.outputs.dxg_id

  name = "vif-${pureport_aws_connection.ael-use1-terraform-lab.name}-secondary"
  vlan = pureport_aws_connection.ael-use1-terraform-lab.gateways[1].vlan
  amazon_address = pureport_aws_connection.ael-use1-terraform-lab.gateways[1].customer_ip #This needs to be in a variables file
  customer_address = pureport_aws_connection.ael-use1-terraform-lab.gateways[1].pureport_ip #This needs to be in a variables file
  bgp_auth_key = pureport_aws_connection.ael-use1-terraform-lab.gateways[1].bgp_password #This needs to be in a variables file
  address_family = "ipv4"
  bgp_asn = pureport_aws_connection.ael-use1-terraform-lab.gateways[1].pureport_asn #This needs to be in a variables file

  tags = {
    Terraform = "true"
    Owner = "aaron.lauer"
    Environment = "2-pureport"
  }

  timeouts {
    create = "20m"
    delete = "20m"
    update = "20m"
  }
}

