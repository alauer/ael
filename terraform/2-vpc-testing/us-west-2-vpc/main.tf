module "vpc-us-west-2" {
  source = "modules/pureport_vpc"
  region = "us-west-2"
  role_arn = "arn:aws:iam::696238294826:role/DevAdmin"
  vpc_name = "vpc-eu-west-1-ael"
  vpc_cidr = "10.20.0.0/16"
  enable_vpn_gateway = false
  create_vpc = false
}

module "vpc-eu-west-1" {
  source = "modules/pureport_vpc"
  region = "eu-west-1"
  role_arn = "arn:aws:iam::696238294826:role/DevAdmin"
  vpc_name = "vpc-eu-west-1-ael"
  vpc_cidr = "10.10.0.0/16"
  enable_vpn_gateway = false
  create_vpc = false
}
