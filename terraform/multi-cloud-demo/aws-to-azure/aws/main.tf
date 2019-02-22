terraform {
  backend "s3" {
    bucket = "ael-demo-tf-statefiles"
    key    = "ael-tf-state/aws-azure/aws.tfstate"
    region = "us-east-1"
  }
}

module "dxg-us-east-1" {
  source                     = "../modules/pureport_dxg"
  region                     = "us-east-1"
  directconnect_primary_id   = "dxcon-fg2f5y2r"
  directconnect_secondary_id = "dxcon-fgmige0t"
  dxg_name                   = "ael-dxg-us-east-1"
  bgp_auth_key_primary       = "fLYZETy2B6BmCmMrhdtvq"
  bgp_auth_key_secondary     = "ZdvYHrWCyXj2lJ4LkXkfD"
  bgp_pureport_asn           = "394351"
  pureport_vlan_primary      = "100"
  pureport_vlan_secondary    = "150"
}

module "vpc1-us-east-1" {
  source             = "../modules/pureport_vpc"
  region             = "us-east-1"
  vpc_name           = "vpc-us-east-1-ael"
  vpc_cidr           = "10.20.0.0/16"
  number_of_subnets  = 1
  enable_vpn_gateway = true
  enable_dx_gateway  = true
  create_vpc         = true

  dxg_id = "${module.dxg-us-east-1.dxg_id}"
}

module "vpc-eu-west-1" {
  source             = "../modules/pureport_vpc"
  region             = "eu-west-1"
  vpc_name           = "vpc-eu-west-1-ael"
  vpc_cidr           = "10.30.0.0/16"
  number_of_subnets  = 1
  enable_vpn_gateway = true
  enable_dx_gateway  = true
  create_vpc         = true

  dxg_id = "${module.dxg-us-east-1.dxg_id}"
}
