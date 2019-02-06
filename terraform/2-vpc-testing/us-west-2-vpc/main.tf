variable "aws_region" {
  default = "us-east-1"
}
variable "office_ip" {}

variable "vpc1_name" {}
variable "vpc1_cidr" {
  default = "10.0.0.0/16"
}
variable "vpc1_public_subnets" {
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}


provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::696238294826:role/DevAdmin"
  }
  region = "${var.aws_region}"
  version = "~> 1.57"
}

module "vpc1" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.vpc1_name}"

  cidr = "${var.vpc1_cidr}"

  azs             = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  public_subnets  = "${var.vpc1_public_subnets}"

  enable_vpn_gateway = true
  enable_dns_hostnames = true
  enable_dns_support = true

  assign_generated_ipv6_cidr_block = false

  public_subnet_tags = {
    Name = "${var.vpc1_name}-public"
  }

  tags = {
    Terraform = "true"
    Owner       = "aaron.lauer"
  }

  vpc_tags = {
    Name = "${var.vpc1_name}"
  }
}

resource "aws_security_group" "allow_all1" {
  name = "allow_all_ael2"
  description = "Allow all inbound traffic AEL test"
  vpc_id = "${module.vpc1.vpc_id}"

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.office_ip}","${module.vpc2.vpc_cidr_block}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
