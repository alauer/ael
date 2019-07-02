resource "pureport_aws_connection" "ael-use1-terraform-lab" {
  provider          = "pureport.terraform-testing"
  name              = "ael-use1-terraform-lab"
  speed             = "50"
  high_availability = true

  location_href = "${data.pureport_locations.iad.locations.0.href}"
  network_href  = "${data.pureport_networks.main.networks.0.href}"

  aws_region     = "us-east-1"
  aws_account_id = "873060941818"
  peering_type   = "PRIVATE"

  provisioner "local-exec" {
    command = "aws directconnect confirm-connection --connection-id ${pureport_aws_connection.ael-use1-terraform-lab.gateways.0.remote_id}"
  }

  provisioner "local-exec" {
    command = "aws directconnect confirm-connection --connection-id ${pureport_aws_connection.ael-use1-terraform-lab.gateways.1.remote_id}"
  }
}
