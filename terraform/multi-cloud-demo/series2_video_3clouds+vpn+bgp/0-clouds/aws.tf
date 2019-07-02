terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "SolEng"

    workspaces {
      name = "multicloud-video-cloudinfra"
    }
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

  version = "~> 1.66.0"

  source                            = "terraform-aws-modules/vpc/aws"
  name                              = "ael-terraform-demo1"
  cidr                              = "10.20.0.0/16"
  azs                               = ["${var.azs}"]
  enable_dns_hostnames              = true
  enable_dns_support                = true
  enable_vpn_gateway                = true
  propagate_public_route_tables_vgw = true

  //propagate_private_route_tables_vgw = true

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
    Environment = "2-vpc"
    Owner       = "aaron.lauer"
  }
}

resource "aws_dx_gateway" "dxg" {
  provider        = "aws.use1"
  name            = "ael-dxg-us-east-1-terraform"
  amazon_side_asn = "64512"

  timeouts {
    create = "20m"
    delete = "20m"
  }
}

resource "aws_dx_gateway_association" "dxg_assoc" {
  provider              = "aws.use1"
  dx_gateway_id         = "${aws_dx_gateway.dxg.id}"
  associated_gateway_id = "${module.vpc.vgw_id}"

  timeouts {
    create = "30m"
    delete = "30m"
    update = "30m"
  }
}

resource "aws_vpn_gateway_route_propagation" "default" {
  provider       = "aws.use1"
  vpn_gateway_id = "${module.vpc.vgw_id}"
  route_table_id = "${module.vpc.vpc_main_route_table_id}"
}

resource "aws_vpn_gateway_route_propagation" "private" {
  provider       = "aws.use1"
  count          = "2"
  vpn_gateway_id = "${module.vpc.vgw_id}"
  route_table_id = "${element(module.vpc.private_route_table_ids, count.index)}"
}
