terraform {
  backend "s3" {
    bucket = "ael-demo-tf-statefiles"
    key    = "ael-tf-state/aws-azure/aws.tfstate"
    region = "us-east-1"
  }
}

module "vpc1-us-east-1" {
  source                 = "/Users/alauer/Documents/GitHub/solutions-engineering/terraform/modules/pureport_vpc"
  region                 = "us-east-1"
  vpc_name               = "vpc-us-east-1-ael"
  vpc_cidr               = "10.20.0.0/16"
  enable_vpn_gateway     = true
  enable_dx_gateway      = true
  create_vpc             = true
  security_group_subnets = ["172.16.33.0/24", "10.30.0.0/16", "10.33.133.0/24"]

  private_subnets = ["10.20.1.0/24"]
  public_subnets  = ["10.20.101.0/24"]

  dxg_id = "${module.dxg-us-east-1.dxg_id}"

  tags {
    Owner = "aaron.lauer"
  }
}

module "vpc-eu-west-1" {
  source                 = "/Users/alauer/Documents/GitHub/solutions-engineering/terraform/modules/pureport_vpc"
  region                 = "eu-west-1"
  vpc_name               = "vpc-eu-west-1-ael"
  vpc_cidr               = "10.30.0.0/16"
  enable_vpn_gateway     = true
  enable_dx_gateway      = true
  create_vpc             = true
  security_group_subnets = ["172.16.33.0/24", "10.20.0.0/16", "10.33.133.0/24"]

  private_subnets = ["10.30.1.0/24"]
  public_subnets  = ["10.30.101.0/24"]

  dxg_id = "${module.dxg-us-east-1.dxg_id}"

  tags {
    Owner = "aaron.lauer"
  }
}

module "dxg-us-east-1" {
  source = "/Users/alauer/Documents/GitHub/solutions-engineering/terraform/modules/pureport_dxg"
  region = "us-east-1"

  directconnect_primary_id   = "dxcon-fgd93v1w"
  directconnect_secondary_id = "dxcon-fg9fyr4z"
  dxg_name                   = "ael-dxg-us-east-1"
  bgp_auth_key_primary       = "cHgzIo0tijY4sm1CGZ1iJ"
  bgp_auth_key_secondary     = "K5WiVwItHmW6T8cSjkB4m"
  bgp_pureport_asn           = "394351"
  pureport_vlan_primary      = "141"
  pureport_vlan_secondary    = "190"

  tags {
    Owner = "aaron.lauer"
  }
}
