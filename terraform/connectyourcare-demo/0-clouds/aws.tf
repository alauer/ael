terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "SolEng"

    workspaces {
      name = "connectyourcare-infra"
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

//// soleng demo test
resource "aws_dx_gateway" "use1_dxg" {
  provider        = aws.use1
  name            = "ael-dxg-use1"
  amazon_side_asn = "64512"

  timeouts {
    create = "20m"
    delete = "20m"
  }
}

resource "aws_dx_gateway_association" "use1_dxg" {
  provider              = aws.use1
  dx_gateway_id         = aws_dx_gateway.use1_dxg.id
  associated_gateway_id = aws_ec2_transit_gateway.use1_tgw.id

  allowed_prefixes = module.vpc_use1.public_subnets_cidr_blocks

  timeouts {
    create = "30m"
    delete = "30m"
    update = "30m"
  }
}

resource "aws_dx_gateway" "usw1_dxg" {
  provider        = aws.usw1
  name            = "ael-dxg-usw1"
  amazon_side_asn = "64512"

  timeouts {
    create = "20m"
    delete = "20m"
  }
}

resource "aws_dx_gateway_association" "usw1_dxg" {
  provider              = aws.usw1
  dx_gateway_id         = aws_dx_gateway.usw1_dxg.id
  associated_gateway_id = aws_ec2_transit_gateway.usw1_tgw.id

  allowed_prefixes = module.vpc_usw1.public_subnets_cidr_blocks

  timeouts {
    create = "30m"
    delete = "30m"
    update = "30m"
  }
}
/*
resource "aws_dx_gateway" "usw2_dxg" {
  provider        = aws.usw2
  name            = "ael-dxg-usw2"
  amazon_side_asn = "64512"

  timeouts {
    create = "20m"
    delete = "20m"
  }
}
*/
resource "aws_dx_gateway_association" "usw2_dxg" {
  provider              = aws.usw2
  dx_gateway_id         = aws_dx_gateway.usw1_dxg.id
  associated_gateway_id = aws_ec2_transit_gateway.usw2_tgw.id

  allowed_prefixes = module.vpc_usw2.public_subnets_cidr_blocks

  timeouts {
    create = "30m"
    delete = "30m"
    update = "30m"
  }
}


resource "aws_ec2_transit_gateway" "use1_tgw" {
  provider                        = aws.use1
  description                     = "ael-tgw-use1-terraform"
  amazon_side_asn                 = "65001"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"

  tags = {
    Name        = "ael-tgw-use1-terraform"
    Terraform   = "true"
    Environment = "soleng-demo"
    Owner       = "aaron.lauer"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "use1_tgw" {
  provider           = aws.use1
  subnet_ids         = module.vpc_use1.public_subnets
  transit_gateway_id = aws_ec2_transit_gateway.use1_tgw.id
  vpc_id             = module.vpc_use1.vpc_id
}

module "vpc_use1" {
  providers = {
    aws = aws.use1
    //propagate_private_route_tables_vgw = true
  }

  version = "2.7.0"

  source                            = "terraform-aws-modules/vpc/aws"
  name                              = "ael-soleng-demo-test-use1"
  cidr                              = "10.100.0.0/16"
  azs                               = ["us-east-1a", "us-east-1b"]
  enable_dns_hostnames              = true
  enable_dns_support                = true
  enable_vpn_gateway                = false
  propagate_public_route_tables_vgw = true
  create_database_subnet_group      = false
  enable_nat_gateway                = false

  public_subnets = [
    "10.100.1.0/24",
    "10.100.2.0/24",
  ]

  tags = {
    Terraform   = "true"
    Environment = "soleng-demo"
    Owner       = "aaron.lauer"
  }
}

resource "aws_route" "use1-route200" {
  provider               = aws.use1
  count                  = "${length(module.vpc_use1.public_route_table_ids)}"
  route_table_id         = "${element(module.vpc_use1.public_route_table_ids, count.index)}"
  destination_cidr_block = "10.200.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.use1_tgw.id
}

resource "aws_route" "use1-route201" {
  provider               = aws.use1
  count                  = "${length(module.vpc_use1.public_route_table_ids)}"
  route_table_id         = "${element(module.vpc_use1.public_route_table_ids, count.index)}"
  destination_cidr_block = "10.201.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.use1_tgw.id
}

resource "aws_route" "usw1-route200" {
  provider               = aws.usw1
  count                  = "${length(module.vpc_usw1.public_route_table_ids)}"
  route_table_id         = "${element(module.vpc_usw1.public_route_table_ids, count.index)}"
  destination_cidr_block = "10.200.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.usw1_tgw.id
}

resource "aws_route" "usw1-route201" {
  provider               = aws.usw1
  count                  = "${length(module.vpc_usw1.public_route_table_ids)}"
  route_table_id         = "${element(module.vpc_usw1.public_route_table_ids, count.index)}"
  destination_cidr_block = "10.201.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.usw1_tgw.id
}

resource "aws_route" "usw2-route200" {
  provider               = aws.usw2
  count                  = "${length(module.vpc_usw2.public_route_table_ids)}"
  route_table_id         = "${element(module.vpc_usw2.public_route_table_ids, count.index)}"
  destination_cidr_block = "10.200.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.usw2_tgw.id
}

resource "aws_route" "usw2-route201" {
  provider               = aws.usw2
  count                  = "${length(module.vpc_usw2.public_route_table_ids)}"
  route_table_id         = "${element(module.vpc_usw2.public_route_table_ids, count.index)}"
  destination_cidr_block = "10.201.0.0/16"
  transit_gateway_id     = aws_ec2_transit_gateway.usw2_tgw.id
}
/*
resource "aws_dx_gateway_association" "dxg_soleng_east" {
  provider              = aws.use1
  dx_gateway_id         = aws_dx_gateway.dxg.id
  associated_gateway_id = module.vpc_use1.vgw_id

  timeouts {
    create = "30m"
    delete = "30m"
    update = "30m"
  }
}
*/
/*
resource "aws_vpn_gateway_route_propagation" "soleng_east" {
  provider       = aws.use1
  vpn_gateway_id = module.vpc_use1.vgw_id
  route_table_id = module.vpc_use1.vpc_main_route_table_id
}
*/
resource "aws_security_group" "soleng_east" {
  provider = aws.use1
  name     = "soleng-east-demo"
  vpc_id   = module.vpc_use1.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.100.0.0/16", "10.101.0.0/16", "10.102.0.0/16", "10.200.0.0/16", "10.201.0.0/16", "136.41.224.23/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Terraform   = "true"
    Environment = "soleng-demo"
    Owner       = "aaron.lauer"
  }
}

resource "aws_ec2_transit_gateway" "usw2_tgw" {
  provider                        = aws.usw2
  description                     = "ael-tgw-usw2-terraform"
  amazon_side_asn                 = "65002"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"

  tags = {
    Name        = "ael-tgw-usw2-terraform"
    Terraform   = "true"
    Environment = "soleng-demo"
    Owner       = "aaron.lauer"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "usw2_tgw" {
  provider           = aws.usw2
  subnet_ids         = module.vpc_usw2.public_subnets
  transit_gateway_id = aws_ec2_transit_gateway.usw2_tgw.id
  vpc_id             = module.vpc_usw2.vpc_id
}

module "vpc_usw2" {
  providers = {
    aws = aws.usw2
    //propagate_private_route_tables_vgw = true
  }

  version = "2.7.0"

  source                            = "terraform-aws-modules/vpc/aws"
  name                              = "ael-soleng-demo-test-usw2"
  cidr                              = "10.101.0.0/16"
  azs                               = ["us-west-2a", "us-west-2b"]
  enable_dns_hostnames              = true
  enable_dns_support                = true
  enable_vpn_gateway                = false
  propagate_public_route_tables_vgw = true
  create_database_subnet_group      = false
  enable_nat_gateway                = false

  public_subnets = [
    "10.101.1.0/24",
    "10.101.2.0/24",
  ]

  tags = {
    Terraform   = "true"
    Environment = "soleng-demo"
    Owner       = "aaron.lauer"
  }
}

resource "aws_security_group" "soleng_west2" {
  provider = aws.usw2
  name     = "usw2-demo"
  vpc_id   = module.vpc_usw2.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.100.0.0/16", "10.101.0.0/16", "10.102.0.0/16", "10.200.0.0/16", "10.201.0.0/16", "136.41.224.23/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Terraform   = "true"
    Environment = "soleng-demo"
    Owner       = "aaron.lauer"
  }
}

resource "aws_ec2_transit_gateway" "usw1_tgw" {
  provider                        = aws.usw1
  description                     = "ael-tgw-usw1-terraform"
  amazon_side_asn                 = "65003"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"

  tags = {
    Name        = "ael-tgw-usw1-terraform"
    Terraform   = "true"
    Environment = "soleng-demo"
    Owner       = "aaron.lauer"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "usw1_tgw" {
  provider           = aws.usw1
  subnet_ids         = module.vpc_usw1.public_subnets
  transit_gateway_id = aws_ec2_transit_gateway.usw1_tgw.id
  vpc_id             = module.vpc_usw1.vpc_id
}

module "vpc_usw1" {
  providers = {
    aws = aws.usw1
    //propagate_private_route_tables_vgw = true
  }

  version = "2.7.0"

  source                            = "terraform-aws-modules/vpc/aws"
  name                              = "ael-soleng-demo-test-usw1"
  cidr                              = "10.102.0.0/16"
  azs                               = ["us-west-1b", "us-west-1c"]
  enable_dns_hostnames              = true
  enable_dns_support                = true
  enable_vpn_gateway                = false
  propagate_public_route_tables_vgw = true
  create_database_subnet_group      = false
  enable_nat_gateway                = false

  public_subnets = [
    "10.102.1.0/24",
    "10.102.2.0/24",
  ]

  tags = {
    Terraform   = "true"
    Environment = "soleng-demo"
    Owner       = "aaron.lauer"
  }
}
resource "aws_security_group" "soleng_west1" {
  provider = aws.usw1
  name     = "usw1-demo"
  vpc_id   = module.vpc_usw1.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.100.0.0/16", "10.101.0.0/16", "10.102.0.0/16", "10.200.0.0/16", "10.201.0.0/16", "136.41.224.23/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Terraform   = "true"
    Environment = "soleng-demo"
    Owner       = "aaron.lauer"
  }
}


/*
resource "aws_dx_gateway_association" "dxg-soleng-west" {
  provider              = aws.usw2
  dx_gateway_id         = aws_dx_gateway.dxg.id
  associated_gateway_id = module.vpc_usw2.vgw_id

  timeouts {
    create = "30m"
    delete = "30m"
    update = "30m"
  }
}

resource "aws_vpn_gateway_route_propagation" "soleng-west" {
  provider       = aws.usw2
  vpn_gateway_id = module.vpc_usw2.vgw_id
  route_table_id = module.vpc_usw2.vpc_main_route_table_id
}

resource "aws_dx_gateway_association" "dxg-soleng-west1" {
  provider              = aws.usw1
  dx_gateway_id         = aws_dx_gateway.dxg.id
  associated_gateway_id = module.vpc_usw1.vgw_id

  timeouts {
    create = "30m"
    delete = "30m"
    update = "30m"
  }
}

resource "aws_vpn_gateway_route_propagation" "soleng-west1" {
  provider       = aws.usw1
  vpn_gateway_id = module.vpc_usw1.vgw_id
  route_table_id = module.vpc_usw1.vpc_main_route_table_id
}
*/

/*
resource "aws_security_group" "soleng-west" {
  provider = aws.usw2
  name     = "soleng-west-demo"
  vpc_id   = module.vpc_usw2.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8", "136.41.224.23/32"]
  }
  egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

  tags = {
    Terraform   = "true"
    Environment = "soleng-demo"
    Owner       = "aaron.lauer"
  }
}

resource "aws_security_group" "soleng-west1" {
  provider = aws.usw1
  name     = "soleng-west1-demo"
  vpc_id   = module.vpc_usw1.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8", "136.41.224.23/32"]
  }
  egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
  tags = {
    Terraform   = "true"
    Environment = "soleng-demo"
    Owner       = "aaron.lauer"
  }
}

///// END soleng demo TEST

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
  egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
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
