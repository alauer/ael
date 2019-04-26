terraform {
  backend "s3" {
    bucket = "ael-demo-tf-statefiles"
    key    = "ael-tf-state/videoseries2-3clouds/videoseries2-3clouds-app.tfstate"
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

/*module "ec2" {
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
  vpc_security_group_ids      = ["${aws_security_group.app_servers.id}"]
  subnet_id                   = "${module.vpc.public_subnets}"

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Owner       = "aaron.lauer"
  }
}

resource "aws_security_group" "app_servers" {
  name        = "app-servers"
  description = "For application servers"
  vpc_id      = "${module.vpc.vpc_id}"
}
*/


/*module "db" {
providers = {
  aws = "aws.use1"
}
  name                            = "aurora-wordpress-demo"
  engine                          = "aurora-mysql"
  engine_version                  = "5.7.12"
  subnets                         = ["${module.vpc.database_subnets}"]
  vpc_id                          = "${module.vpc.vpc_id}"
  replica_count                   = 1
  instance_type                   = "db.t3.medium"
  apply_immediately               = true
  skip_final_snapshot             = true
  db_parameter_group_name         = "${aws_db_parameter_group.aurora_db_57_parameter_group.id}"
  db_cluster_parameter_group_name = "${aws_rds_cluster_parameter_group.aurora_57_cluster_parameter_group.id}"
  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Owner       = "aaron.lauer"
  }
}

resource "aws_db_parameter_group" "aurora_db_57_parameter_group" {
  name        = "ael-demo-aurora-db-57-parameter-group"
  family      = "aurora-mysql5.7"
  description = "wordpress-aurora-db-57-parameter-group"
}

resource "aws_rds_cluster_parameter_group" "aurora_57_cluster_parameter_group" {
  name        = "ael-demo-aurora-57-cluster-parameter-group"
  family      = "aurora-mysql5.7"
  description = "wordpress-aurora-57-cluster-parameter-group"
}

resource "aws_security_group_rule" "allow_access_aws" {
  type                     = "ingress"
  from_port                = "${module.aurora.this_rds_cluster_port}"
  to_port                  = "${module.aurora.this_rds_cluster_port}"
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.app_servers.id}"
  security_group_id        = "${module.aurora.this_security_group_id}"
}

resource "aws_security_group_rule" "allow_access_all" {
  type              = "ingress"
  from_port         = "${module.aurora.this_rds_cluster_port}"
  to_port           = "${module.aurora.this_rds_cluster_port}"
  protocol          = "tcp"
  cidr_blocks       = ["10.33.133.0/24"]
  security_group_id = "${module.aurora.this_security_group_id}"
}
*/

