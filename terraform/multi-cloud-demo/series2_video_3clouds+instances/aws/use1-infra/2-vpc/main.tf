terraform {
  backend "s3" {
    bucket = "ael-demo-tf-statefiles"
    key    = "ael-tf-state/videoseries2-3clouds/videoseries2-3clouds-vpc.tfstate"
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

module "vpc" {
  providers = {
    aws = "aws.use1"
  }

  source                             = "terraform-aws-modules/vpc/aws"
  name                               = "ael-wordpress-demo"
  cidr                               = "10.20.0.0/16"
  azs                                = ["${var.azs}"]
  enable_dns_hostnames               = true
  enable_dns_support                 = true
  enable_vpn_gateway                 = true
  propagate_public_route_tables_vgw  = true
  propagate_private_route_tables_vgw = true

  private_subnets = [
    "10.20.1.0/24",
    "10.20.2.0/24",
  ]

  public_subnets = [
    "10.20.101.0/24",
    "10.20.102.0/24",
  ]

  //database_subnets = [
  //  "10.20.201.0/24",
  //  "10.20.202.0/24",
  //]
  tags = {
    Terraform   = "true"
    Environment = "2-vpc"
    Owner       = "aaron.lauer"
  }
}

//resource "aws_dx_gateway_association" "dxg_assoc" {
//  provider       = "aws.use1"
//  dx_gateway_id  = "${var.dxg_id}"
//  vpn_gateway_id = "${module.vpc.vgw_id}"
//}


//resource "aws_vpn_gateway_route_propagation" "default" {
//  provider       = "aws.use1"
//  vpn_gateway_id = "${module.vpc.vgw_id}"
//  route_table_id = "${module.vpc.vpc_main_route_table_id}"
//}


//resource "aws_route_table_association" "db_r" {
//  provider = "aws.use1"


//count          = "${length(module.vpc.database_subnets) > 0 ? length(module.vpc.database_subnets) : 0}"
//  subnet_id      = "${element(module.vpc.database_subnets, count.index)}"
//  route_table_id = "${module.vpc.vpc_main_route_table_id}"
//}

