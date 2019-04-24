terraform {
  backend "s3" {
    bucket = "ael-demo-tf-statefiles"
    key    = "ael-tf-state/videoseries2-3clouds/videoseries2-3clouds-ec2.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "use1"
}

//IMPORT THE VPC REMOTE STATE FILE TO ACCESS THE OUTPUTS
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "ael-demo-tf-statefiles"
    key    = "ael-tf-state/videoseries2-3clouds/videoseries2-3clouds-vpc.tfstate"
    region = "us-east-1"
  }
}

module "us-east-1-ec2" {
  source = "terraform-aws-modules/ec2-instance/aws"

  providers = {
    aws = "aws.use1"
  }

  version = "1.12.0"

  name = "wordpress"

  ami                    = "ami-0ac019f4fcb7cb7e6"
  instance_type          = "t2.micro"
  key_name               = "ael-laptop"
  monitoring             = true
  vpc_security_group_ids = ["${data.terraform_remote_state.vpc.security_groups}"]
  subnet_id              = "${data.terraform_remote_state.vpc.aws_private_subnet}"

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Owner       = "aaron.lauer"
  }
}
