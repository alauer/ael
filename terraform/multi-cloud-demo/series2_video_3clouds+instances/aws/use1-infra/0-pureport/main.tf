terraform {
  backend "s3" {
    bucket = "ael-demo-tf-statefiles"
    key    = "ael-tf-state/videoseries2-3clouds/videoseries2-3clouds-awspureport.tfstate"
    region = "us-east-1"
  }
}

provider "pureport" {
  api_key    = "73XrDMJd5nKko"
  api_secret = "gEf2eRV2BVEAsywz8"
  api_url    = "https://api.pureport.com"
  alias      = "terraform-testing"
}

/*
curl -X POST https://api.pureport.com/login \
    -H "Content-Type: application/json" \
    -d '{
        "key": "73XrDMJd5nKko",
        "secret": "gEf2eRV2BVEAsywz8"
    }'
*/

data "pureport_accounts" "main" {
  provider   = "pureport.terraform-testing"
  name_regex = "AaronCo"
}

data "pureport_locations" "iad" {
  provider   = "pureport.terraform-testing"
  name_regex = "^Wash*"
}

data "pureport_networks" "main" {
  provider     = "pureport.terraform-testing"
  account_href = "${data.pureport_accounts.main.accounts.0.href}"
  name_regex   = "test-network-ael"
}

resource "pureport_aws_connection" "us-east-1" {
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
    command = "aws directconnect confirm-connection --connection-id ${pureport_aws_connection.us-east-1.gateways.0.remote_id}"
  }

  provisioner "local-exec" {
    command = "aws directconnect confirm-connection --connection-id ${pureport_aws_connection.us-east-1.gateways.1.remote_id}"
  }
}
