provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "sales-demo" {
  ami           = "ami-0ac019f4fcb7cb7e6"
  instance_type = "t2.micro"
  key_name      = "ael-laptop"

  tags = {
    Name      = "sales-demo-instance1"
    Terraform = "true"
    Owner     = "Solutions Engineering"
  }
}
