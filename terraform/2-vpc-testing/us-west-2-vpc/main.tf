module "vpc-us-east-1" {
  source = "modules/pureport_vpc"
  region = "us-east-1"
  role_arn = "arn:aws:iam::696238294826:role/DevAdmin"
  vpc_name = "vpc-us-east-1-ael"
  vpc_cidr = "10.10.0.0/16"
  number_of_subnets = 2
  enable_vpn_gateway = true
  create_vpc = true
}

module "vpc-eu-west-1" {
  source = "modules/pureport_vpc"
  region = "eu-west-1"
  role_arn = "arn:aws:iam::696238294826:role/DevAdmin"
  vpc_name = "vpc-eu-west-1-ael"
  vpc_cidr = "10.20.0.0/16"
  number_of_subnets = 1
  enable_vpn_gateway = true
  create_vpc = true
}
