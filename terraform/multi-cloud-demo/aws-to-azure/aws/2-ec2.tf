provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "sales-demo" {
  ami           = "ami-0ac019f4fcb7cb7e6"
  instance_type = "t2.micro"
  key_name      = "ael-laptop"
  subnet_id     = "subnet-02410ef4012a90849"

  //vpc_security_group_ids = ["sg-00ae5183039504d8c"]
  vpc_security_group_ids = ["${module.vpc1-us-east-1.aws_security_groups}"]

  tags = {
    Name      = "ael-kb-test-instance1"
    Terraform = "true"
    Owner     = "aaron.lauer"
  }
}
