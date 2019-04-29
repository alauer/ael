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
  create_database_subnet_group       = true
  enable_vpn_gateway                 = true
  propagate_private_route_tables_vgw = true
  create_database_subnet_route_table = true

  private_subnets = [
    "10.20.1.0/24",
    "10.20.2.0/24",
  ]

  public_subnets = [
    "10.20.101.0/24",
    "10.20.102.0/24",
  ]

  database_subnets = [
    "10.20.201.0/24",
    "10.20.202.0/24",
  ]

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Owner       = "aaron.lauer"
  }
}

resource "aws_dx_gateway_association" "dxg_assoc" {
  provider       = "aws.use1"
  dx_gateway_id  = "${var.dxg_id}"
  vpn_gateway_id = "${module.vpc.vgw_id}"
}
