terraform {
  backend "s3" {
    bucket = "ael-demo-tf-statefiles"
    key    = "ael-tf-state/aws-azure/aws.tfstate"
    region = "us-east-1"
  }
}

module "vpc1-us-east-1" {
  source             = "github.com/pureport/solutions-engineering/terraform/modules/pureport_vpc"
  region             = "us-east-1"
  vpc_name           = "vpc-us-east-1-ael"
  vpc_cidr           = "10.20.0.0/16"
  number_of_subnets  = 1
  enable_vpn_gateway = false
  enable_dx_gateway  = false
  create_vpc         = true

  security_group_subnets = ["172.16.33.0/24", "10.30.0.0/24", "192.168.168.0/24"]

  dxg_id = "${module.dxg-us-east-1.dxg_id}"
}

module "vpc-eu-west-1" {
  source             = "github.com/pureport/solutions-engineering/terraform/modules/pureport_vpc"
  region             = "eu-west-1"
  vpc_name           = "vpc-eu-west-1-ael"
  vpc_cidr           = "10.30.0.0/16"
  number_of_subnets  = 1
  enable_vpn_gateway = false
  enable_dx_gateway  = false
  create_vpc         = true

  security_group_subnets = ["172.16.33.0/24", "10.20.0.0/24", "192.168.168.0/24"]

  dxg_id = "${module.dxg-us-east-1.dxg_id}"
}

module "dxg-us-east-1" {
  source = "github.com/pureport/solutions-engineering/terraform/modules/pureport_dxg"
  region = "us-east-1"

  directconnect_primary_id   = "dxcon-ffgik17n"
  directconnect_secondary_id = "dxcon-fg83uply"
  dxg_name                   = "ael-dxg-us-east-1"
  bgp_auth_key_primary       = "LFdwaaBqSSYdU5YFbjT9I"
  bgp_auth_key_secondary     = "fY7U5SiMOotUhHW6ODaxI"
  bgp_pureport_asn           = "394351"
  pureport_vlan_primary      = "116"
  pureport_vlan_secondary    = "166"
}
