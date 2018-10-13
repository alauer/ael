provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::696238294826:role/DevAdmin"
  }
  region = "us-west-2"
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "ael-api-tf"

  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  private_subnets = ["10.0.104.0/24", "10.0.105.0/24", "10.0.106.0/24"]

  assign_generated_ipv6_cidr_block = false

  public_subnet_tags = {
    Name = "ael-api-public"
  }

  private_subnet_tags = {
    Name = "ael-api-private"
  }

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "ael-api-tf"
  }
}

resource "aws_security_group" "allow_all" {
  name = "allow_all_ael"
  description = "Allow all inbound traffic AEL test"
  vpc_id = "${module.vpc.vpc_id}"

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["136.41.224.23/32"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_lb" "test" {
  name = "ael-lb-test-tf"
  internal = "true"
  load_balancer_type = "network"
  subnets = ["${module.vpc.public_subnets}"]
}
