terraform {
  backend "s3" {
    bucket = "ael-demo-tf-statefiles"
    key    = "ael-tf-state/videoseries2-3clouds/videoseries2-3clouds-app.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "ael-demo-tf-statefiles"
    key    = "ael-tf-state/videoseries2-3clouds/videoseries2-3clouds-vpc.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "use1"
}

locals {
  pureport_network = ["10.20.0.0/16", "10.33.133.0/24", "10.10.10.0/24"]
}

resource "aws_route53_resolver_endpoint" "pureport" {
  provider  = "aws.use1"
  name      = "pureport"
  direction = "INBOUND"

  security_group_ids = [
    "${aws_security_group.app_servers.id}",
  ]

  ip_address {
    subnet_id = "${data.terraform_remote_state.vpc.public_subnets[0]}"
    ip        = "10.20.101.5"
  }

  ip_address {
    subnet_id = "${data.terraform_remote_state.vpc.public_subnets[1]}"
    ip        = "10.20.102.5"
  }

  tags = {
    Terraform   = "true"
    Environment = "3-application"
    Owner       = "aaron.lauer"
  }
}

module "ec2" {
  providers = {
    aws = "aws.use1"
  }

  source = "terraform-aws-modules/ec2-instance/aws"

  version = "1.21.0"

  name = "wordpress"

  ami                         = "ami-0a313d6098716f372"
  instance_type               = "t2.micro"
  key_name                    = "ael-laptop"
  monitoring                  = false
  associate_public_ip_address = true
  vpc_security_group_ids      = ["${aws_security_group.app_servers.id}", "${data.terraform_remote_state.vpc.default_security_group_id}"]
  subnet_id                   = "${data.terraform_remote_state.vpc.public_subnets[0]}"

  tags = {
    Terraform   = "true"
    Environment = "3-application"
    Owner       = "aaron.lauer"
  }
}

module "db" {
  providers = {
    aws = "aws.use1"
  }

  source                          = "terraform-aws-modules/rds-aurora/aws"
  name                            = "aurora-wordpress-demo"
  engine                          = "aurora-mysql"
  engine_version                  = "5.7.12"
  subnets                         = "${data.terraform_remote_state.vpc.database_subnets}"
  vpc_id                          = "${var.vpc_id}"
  replica_count                   = 1
  instance_type                   = "db.t3.medium"
  apply_immediately               = true
  skip_final_snapshot             = true
  db_parameter_group_name         = "${aws_db_parameter_group.aurora_db_57_parameter_group.id}"
  db_cluster_parameter_group_name = "${aws_rds_cluster_parameter_group.aurora_57_cluster_parameter_group.id}"
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  password                        = "${var.db_password}"

  tags = {
    Terraform   = "true"
    Environment = "3-application"
    Owner       = "aaron.lauer"
  }
}

resource "aws_db_parameter_group" "aurora_db_57_parameter_group" {
  provider    = "aws.use1"
  name        = "ael-demo-aurora-db-57-parameter-group"
  family      = "aurora-mysql5.7"
  description = "wordpress-aurora-db-57-parameter-group"
}

resource "aws_rds_cluster_parameter_group" "aurora_57_cluster_parameter_group" {
  provider    = "aws.use1"
  name        = "ael-demo-aurora-57-cluster-parameter-group"
  family      = "aurora-mysql5.7"
  description = "wordpress-aurora-57-cluster-parameter-group"
}

resource "aws_security_group" "app_servers" {
  provider    = "aws.use1"
  name        = "app-servers"
  description = "For application servers"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"
}

resource "aws_security_group_rule" "allow_access_aws" {
  provider          = "aws.use1"
  type              = "ingress"
  to_port           = 0
  from_port         = 0
  protocol          = "-1"
  cidr_blocks       = "${local.pureport_network}"
  security_group_id = "${aws_security_group.app_servers.id}"
}

resource "aws_security_group_rule" "allow_access_aws_ssh" {
  provider          = "aws.use1"
  type              = "ingress"
  to_port           = 22
  from_port         = 22
  protocol          = "tcp"
  cidr_blocks       = ["${local.pureport_network}", "0.0.0.0/0"]
  security_group_id = "${aws_security_group.app_servers.id}"
}

resource "aws_security_group_rule" "allow_access_db" {
  provider          = "aws.use1"
  type              = "ingress"
  from_port         = "${module.db.this_rds_cluster_port}"
  to_port           = "${module.db.this_rds_cluster_port}"
  protocol          = "tcp"
  cidr_blocks       = "${local.pureport_network}"
  security_group_id = "${module.db.this_security_group_id}"
}
