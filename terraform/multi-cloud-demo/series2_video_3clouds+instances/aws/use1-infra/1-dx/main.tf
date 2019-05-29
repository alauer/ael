terraform {
  backend "s3" {
    bucket = "ael-demo-tf-statefiles"
    key    = "ael-tf-state/videoseries2-3clouds/videoseries2-3clouds-dx.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "use1"
}

provider "aws" {
  region = "eu-west-1"
  alias  = "euw1"
}

###############
provider "pureport" {
  api_key    = "73XrDMJd5nKko"
  api_secret = "gEf2eRV2BVEAsywz8"
  api_url    = "https://api.pureport.com"
  alias      = "terraform-testing"
}

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

###################3

module "dxg" {
  source = "/Users/alauer/Documents/GitHub/solutions-engineering/terraform/modules/pureport_dxg"

  providers = {
    aws = "aws.use1"
  }

  region = "us-east-1"

  directconnect_primary_id   = "${pureport_aws_connection.us-east-1.gateways.0.remote_id}"
  directconnect_secondary_id = "${pureport_aws_connection.us-east-1.gateways.1.remote_id}"
  dxg_name                   = "ael-dxg-us-east-1-terraform"
  bgp_auth_key_primary       = "${pureport_aws_connection.us-east-1.gateways.0.bgp_password}"
  bgp_auth_key_secondary     = "${pureport_aws_connection.us-east-1.gateways.1.bgp_password}"
  bgp_pureport_asn           = "${pureport_aws_connection.us-east-1.gateways.0.pureport_asn}"
  pureport_vlan_primary      = "${pureport_aws_connection.us-east-1.gateways.0.vlan}"
  pureport_vlan_secondary    = "${pureport_aws_connection.us-east-1.gateways.1.vlan}"

  tags = {
    Terraform   = "true"
    Owner       = "aaron.lauer"
    Environment = "1-dx"
  }
}
