variable "aws_region" {}
variable "office_ip" {}

variable "vpc1_name" {}
variable "vpc1_cidr" {
  default = "10.0.0.0/16"
}
variable "vpc1_public_subnets" {
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "vpc2_name" {}
variable "vpc2_cidr" {
  default = "10.10.0.0/16"
}
variable "vpc2_public_subnets" {
  default = ["10.10.101.0/24", "10.10.102.0/24", "10.10.103.0/24"]
}


provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::696238294826:role/DevAdmin"
  }
  region = "${var.aws_region}"
  version = "~> 1.57"
}

module "vpc2" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.vpc2_name}"

  cidr = "${var.vpc2_cidr}"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  public_subnets  = "${var.vpc2_public_subnets}"

  enable_vpn_gateway = true


  assign_generated_ipv6_cidr_block = false

  public_subnet_tags = {
    Name = "${var.vpc2_name}-public"
  }

  tags = {
    Terraform = "true"
    Owner       = "aaron.lauer"
  }

  vpc_tags = {
    Name = "${var.vpc2_name}"
  }
}

module "vpc1" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.vpc1_name}"

  cidr = "${var.vpc1_cidr}"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  public_subnets  = "${var.vpc1_public_subnets}"

  enable_vpn_gateway = true

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


resource "aws_security_group" "allow_all2" {
  name = "allow_all_ael1"
  description = "Allow all inbound traffic AEL test"
  vpc_id = "${module.vpc2.vpc_id}"

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.office_ip}","${module.vpc1.vpc_cidr_block}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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
    cidr_blocks = ["${var.office_ip}","${module.vpc2.vpc_cidr_block}"]   #This needs to be in a variables file
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
