terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "SolEng"

    workspaces {
      name = "rancher-multicloud-infra"
    }
  }
}

provider "aws" {
  region = "us-east-2"
  alias  = "use2"
}

provider "aws" {
  region = "us-east-1"
  alias  = "use1"
}

provider "aws" {
  region = "us-west-2"
  alias  = "usw2"
}

provider "aws" {
  region = "us-west-1"
  alias  = "usw1"
}


provider "aws" {
  region = "eu-west-1"
  alias  = "euw1"
}

//// ORACLE LATENCY test
module "vpc-oracle-east" {
  providers = {
    aws = aws.use1
    //propagate_private_route_tables_vgw = true
  }

  version = "2.7.0"

  source                            = "terraform-aws-modules/vpc/aws"
  name                              = "ael-oracle-latency-test-use1"
  cidr                              = "10.100.0.0/16"
  azs                               = ["us-east-1a", "us-east-1b"]
  enable_dns_hostnames              = true
  enable_dns_support                = true
  enable_vpn_gateway                = true
  propagate_public_route_tables_vgw = true
  create_database_subnet_group      = false
  enable_nat_gateway                = false

  public_subnets = [
    "10.100.101.0/24",
    "10.100.102.0/24",
  ]

  tags = {
    Terraform   = "true"
    Environment = "oracle-latency"
    Owner       = "aaron.lauer"
  }
}

module "vpc-oracle-west" {
  providers = {
    aws = aws.usw2
    //propagate_private_route_tables_vgw = true
  }

  version = "2.7.0"

  source                            = "terraform-aws-modules/vpc/aws"
  name                              = "ael-oracle-latency-test-usw2"
  cidr                              = "10.101.0.0/16"
  azs                               = ["us-west-2a", "us-west-2b"]
  enable_dns_hostnames              = true
  enable_dns_support                = true
  enable_vpn_gateway                = true
  propagate_public_route_tables_vgw = true
  create_database_subnet_group      = false
  enable_nat_gateway                = false

  public_subnets = [
    "10.101.101.0/24",
    "10.101.102.0/24",
  ]

  tags = {
    Terraform   = "true"
    Environment = "oracle-latency"
    Owner       = "aaron.lauer"
  }
}

module "vpc-oracle-west1" {
  providers = {
    aws = aws.usw1
    //propagate_private_route_tables_vgw = true
  }

  version = "2.7.0"

  source                            = "terraform-aws-modules/vpc/aws"
  name                              = "ael-oracle-latency-test-usw1"
  cidr                              = "10.102.0.0/16"
  azs                               = ["us-west-1b", "us-west-1c"]
  enable_dns_hostnames              = true
  enable_dns_support                = true
  enable_vpn_gateway                = true
  propagate_public_route_tables_vgw = true
  create_database_subnet_group      = false
  enable_nat_gateway                = false

  public_subnets = [
    "10.102.101.0/24",
    "10.102.102.0/24",
  ]

  tags = {
    Terraform   = "true"
    Environment = "oracle-latency"
    Owner       = "aaron.lauer"
  }
}

resource "aws_dx_gateway_association" "dxg-oracle-east" {
  provider              = aws.use1
  dx_gateway_id         = aws_dx_gateway.dxg.id
  associated_gateway_id = module.vpc-oracle-east.vgw_id

  timeouts {
    create = "30m"
    delete = "30m"
    update = "30m"
  }
}

resource "aws_vpn_gateway_route_propagation" "oracle-east" {
  provider       = aws.use1
  vpn_gateway_id = module.vpc-oracle-east.vgw_id
  route_table_id = module.vpc-oracle-east.vpc_main_route_table_id
}



resource "aws_dx_gateway_association" "dxg-oracle-west" {
  provider              = aws.usw2
  dx_gateway_id         = aws_dx_gateway.dxg.id
  associated_gateway_id = module.vpc-oracle-west.vgw_id

  timeouts {
    create = "30m"
    delete = "30m"
    update = "30m"
  }
}

resource "aws_vpn_gateway_route_propagation" "oracle-west" {
  provider       = aws.usw2
  vpn_gateway_id = module.vpc-oracle-west.vgw_id
  route_table_id = module.vpc-oracle-west.vpc_main_route_table_id
}

resource "aws_dx_gateway_association" "dxg-oracle-west1" {
  provider              = aws.usw1
  dx_gateway_id         = aws_dx_gateway.dxg.id
  associated_gateway_id = module.vpc-oracle-west1.vgw_id

  timeouts {
    create = "30m"
    delete = "30m"
    update = "30m"
  }
}

resource "aws_vpn_gateway_route_propagation" "oracle-west1" {
  provider       = aws.usw1
  vpn_gateway_id = module.vpc-oracle-west1.vgw_id
  route_table_id = module.vpc-oracle-west1.vpc_main_route_table_id
}

resource "aws_security_group" "oracle-east" {
  provider = aws.use1
  name     = "oracle-east-latency"
  vpc_id   = module.vpc-oracle-east.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8", "136.56.63.167/32"]
  }
  tags = {
    Terraform   = "true"
    Environment = "oracle-latency"
    Owner       = "aaron.lauer"
  }
}

resource "aws_security_group" "oracle-west" {
  provider = aws.usw2
  name     = "oracle-west-latency"
  vpc_id   = module.vpc-oracle-west.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8", "136.56.63.167/32"]
  }

  tags = {
    Terraform   = "true"
    Environment = "oracle-latency"
    Owner       = "aaron.lauer"
  }
}

resource "aws_security_group" "oracle-west1" {
  provider = aws.usw1
  name     = "oracle-west1-latency"
  vpc_id   = module.vpc-oracle-west1.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8", "136.56.63.167/32"]
  }
  tags = {
    Terraform   = "true"
    Environment = "oracle-latency"
    Owner       = "aaron.lauer"
  }
}

///// END ORACLE LATENCY TEST

module "vpc" {
  providers = {
    aws = aws.use2
    //propagate_private_route_tables_vgw = true
  }

  version = "2.7.0"

  source                            = "terraform-aws-modules/vpc/aws"
  name                              = "ael-rancher-demo1"
  cidr                              = "10.20.0.0/16"
  azs                               = var.azs
  enable_dns_hostnames              = true
  enable_dns_support                = true
  enable_vpn_gateway                = true
  propagate_public_route_tables_vgw = true
  create_database_subnet_group      = false
  enable_nat_gateway                = false

  public_subnets = [
    "10.20.101.0/24",
    "10.20.102.0/24",
  ]

  tags = {
    Terraform   = "true"
    Environment = "rancher-demo"
    Owner       = "aaron.lauer"
  }
}

resource "aws_dx_gateway" "dxg" {
  provider        = aws.use2
  name            = "ael-dxg-us-east-2-terraform"
  amazon_side_asn = "64512"

  timeouts {
    create = "20m"
    delete = "20m"
  }
}


resource "aws_dx_gateway_association" "dxg_assoc" {
  provider              = aws.use2
  dx_gateway_id         = aws_dx_gateway.dxg.id
  associated_gateway_id = module.vpc.vgw_id

  timeouts {
    create = "30m"
    delete = "30m"
    update = "30m"
  }
}

resource "aws_vpn_gateway_route_propagation" "default" {
  provider       = aws.use2
  vpn_gateway_id = module.vpc.vgw_id
  route_table_id = module.vpc.vpc_main_route_table_id
}

resource "aws_security_group" "rancher-sandbox" {
  provider = aws.use2
  name     = "rancher-sandbox"
  vpc_id   = module.vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["172.16.0.0/16", "10.33.133.0/24", "10.10.10.0/24"]
  }
  tags = {
    Terraform   = "true"
    Environment = "rancher-demo"
    Owner       = "aaron.lauer"
  }
}

/*resource "aws_vpn_gateway_route_propagation" "private" {
  provider       = aws.use2
  count          = "2"
  vpn_gateway_id = module.vpc.vgw_id
  route_table_id = element(module.vpc.private_route_table_ids, count.index)
}
*/
