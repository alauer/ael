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
  name_regex = "AaronCo"
}

data "pureport_locations" "iad" {
  name_regex = "^Wash*"
}

data "pureport_networks" "main" {
  account_href = "${data.pureport_accounts.main.accounts.0.href}"
  name_regex   = "test-network-ael"
}

resource "pureport_aws_connection" "us-east-1" {
  name              = "ael-use1-terraform-test"
  speed             = "50"
  high_availability = true

  location_href = "${data.pureport_locations.iad.locations.0.href}"
  network_href  = "${data.pureport_networks.main.networks.0.href}"

  aws_region     = "us-east-1"
  aws_account_id = "873060941818"
  peering_type   = "PRIVATE"
}

resource "pureport_site_vpn_connection" "raleigh-lab" {
  name                = "ael-vpn-raleigh-lab"
  speed               = "100"
  high_availability   = true
  enable_bgp_password = true

  location_href = "${data.pureport_locations.iad.locations.0.href}"
  network_href  = "${data.pureport_networks.main.networks.0.href}"

  ike_version = "V2"

  routing_type = "ROUTE_BASED_BGP"
  customer_asn = 65001

  primary_customer_router_ip   = "136.56.60.22"
  secondary_customer_router_ip = "136.56.60.22"
}
