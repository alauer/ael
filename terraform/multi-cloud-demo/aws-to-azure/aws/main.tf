terraform {
  backend "s3" {
    bucket = "pureport-sol-eng"
    key    = "ael-tf-state/aws-azure/aws.tfstate"
    region = "us-east-1"
    role_arn = "arn:aws:iam::696238294826:role/DevAdmin"
  }
}

module "dxg-us-east-1" {
  source = "../modules/pureport_dxg"
  region = "us-east-1"
  role_arn = "arn:aws:iam::696238294826:role/DevAdmin"
  directconnect_primary_id = "dxcon-fh78lw38"
  directconnect_secondary_id = "dxcon-fgo1bji2"
  dxg_name = "ael-dxg-us-east-1"
  bgp_auth_key_primary = "kc0Cq4EUuNHTls7m6HphV"
  bgp_auth_key_secondary = "g0gQSCZFiJLYNge90lp3U"
  bgp_pureport_asn = "394351"
  pureport_vlan_primary = "130"
  pureport_vlan_secondary = "158"
}

module "vpc-us-east-1" {
  source = "../modules/pureport_vpc"
  region = "us-east-1"
  role_arn = "arn:aws:iam::696238294826:role/DevAdmin"
  vpc_name = "vpc-us-east-1-ael"
  vpc_cidr = "10.10.0.0/16"
  number_of_subnets = 1
  enable_vpn_gateway = true
  enable_dx_gateway = true
  create_vpc = true
  dxg_id = "${module.dxg-us-east-1.dxg_id}"
}

module "vpc-eu-west-1" {
  source = "../modules/pureport_vpc"
  region = "eu-west-1"
  role_arn = "arn:aws:iam::696238294826:role/DevAdmin"
  vpc_name = "vpc-eu-west-1-ael"
  vpc_cidr = "10.20.0.0/16"
  number_of_subnets = 1
  enable_vpn_gateway = true
  enable_dx_gateway = true
  create_vpc = true
  dxg_id = "${module.dxg-us-east-1.dxg_id}"
}
