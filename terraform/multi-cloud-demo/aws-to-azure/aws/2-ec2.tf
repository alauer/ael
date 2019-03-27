provider "aws" {
  region = "us-east-1"
}

variable "create_instance" {
  default = "false"
}

resource "aws_instance" "sales-demo" {
  create_instance = "false"
  count           = "${var.create_instance ? 1 : 0}"
  ami             = "ami-0ac019f4fcb7cb7e6"
  instance_type   = "t2.micro"
  key_name        = "ael-laptop"
  subnet_id       = "subnet-0ecff90af356b13f7"

  //vpc_security_group_ids = ["sg-00ae5183039504d8c"]
  vpc_security_group_ids = ["${module.vpc1-us-east-1.aws_security_groups}"]

  tags = {
    Name      = "ael-kb-test-instance1"
    Terraform = "true"
    Owner     = "aaron.lauer"
  }
}
