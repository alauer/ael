provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "ael-kb-test1"

  cidr = "10.0.0.0/16"

  azs            = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  assign_generated_ipv6_cidr_block = false

  public_subnet_tags = {
    Name = "ael-kb-test1-public"
  }

  tags = {
    Owner       = "aaron.lauer"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "ael-kb-test1"
  }
}


resource "aws_security_group" "allow_all" {
  name        = "allow_all_ael"
  description = "Allow all inbound traffic AEL test"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["136.41.224.23/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
