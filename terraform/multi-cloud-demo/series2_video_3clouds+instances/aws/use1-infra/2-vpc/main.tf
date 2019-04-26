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

  source               = "terraform-aws-modules/vpc/aws"
  name                 = "ael-wordpress-demo"
  cidr                 = "10.20.0.0/16"
  azs                  = ["${var.azs}"]
  enable_dns_hostnames = true

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
}
