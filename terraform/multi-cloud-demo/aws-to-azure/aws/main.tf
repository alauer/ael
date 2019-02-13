terraform {
  backend "s3" {
    bucket = "ael-demo-tf-statefiles"
    key    = "ael-tf-state/aws-azure/aws.tfstate"
    region = "us-east-1"
  }
}

module "dxg-us-east-1" {
  source = "../modules/pureport_dxg"
  region = "us-east-1"
  directconnect_primary_id = "dxcon-ffvn4f14"
  directconnect_secondary_id = "dxcon-ffkuissd"
  dxg_name = "ael-dxg-us-east-1"
  bgp_auth_key_primary = "Ew3eMBD4a7zXtQKmbSoxS"
  bgp_auth_key_secondary = "VVPE4KBsUBvZ4oWF4Z0Cw"
  bgp_pureport_asn = "394351"
  pureport_vlan_primary = "100"
  pureport_vlan_secondary = "150"
}

module "vpc-us-east-1" {
  source = "../modules/pureport_vpc"
  region = "us-east-1"
  vpc_name = "vpc-us-east-1-ael"
  vpc_cidr = "10.10.0.0/16"
  number_of_subnets = 1
  enable_vpn_gateway = true
  enable_dx_gateway = true
  create_vpc = true
  dxg_id = "${module.dxg-us-east-1.dxg_id}"
}
/*
module "vpc-eu-west-1" {
  source = "../modules/pureport_vpc"
  region = "eu-west-1"
  vpc_name = "vpc-eu-west-1-ael"
  vpc_cidr = "10.20.0.0/16"
  number_of_subnets = 1
  enable_vpn_gateway = true
  enable_dx_gateway = true
  create_vpc = false
  #dxg_id = "${module.dxg-us-east-1.dxg_id}"
}
*/
