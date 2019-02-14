provider "aws" {
  region  = "${var.region}"
  version = "~> 1.58"
}

terraform {
  required_version = ">= 0.10.3" # introduction of Local Values configuration language feature
}

locals {
  # Use `local.vpc_id` to give a hint to Terraform that subnets should be deleted before secondary CIDR blocks can be free!
  vpc_id = "${element(concat(aws_vpc_ipv4_cidr_block_association.this.*.vpc_id, aws_vpc.this.*.id, list("")), 0)}"
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "this" {
  count                            = "${var.create_vpc ? 1 : 0}"
  cidr_block                       = "${var.vpc_cidr}"
  assign_generated_ipv6_cidr_block = "false"
  enable_dns_support               = "true"
  enable_dns_hostnames             = "true"

  tags {
    Name      = "${var.vpc_name}"
    Terraform = "true"
    Owner     = "aaron.lauer"
  }
}

###################
# Internet Gateway
###################
resource "aws_internet_gateway" "this" {
  count = "${var.create_vpc ? 1 : 0}"

  vpc_id = "${local.vpc_id}"

  tags {
    Name      = "${var.vpc_name}-igw"
    Terraform = "true"
    Owner     = "aaron.lauer"
  }
}

################
# Publiс routes
################
resource "aws_route" "public_internet_gateway" {
  count = "${var.create_vpc ? 1 : 0}"

  route_table_id         = "${aws_vpc.this.default_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.this.id}"

  timeouts {
    create = "10m"
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "this" {
  count = "${var.create_vpc && length(var.secondary_cidr_blocks) > 0 ? length(var.secondary_cidr_blocks) : 0}"

  vpc_id = "${aws_vpc.this.id}"

  cidr_block = "${element(var.secondary_cidr_blocks, count.index)}"
}

#################
# Private routes
# There are so many routing tables as the largest amount of subnets of each type (really?)
#################
#resource "aws_route_table" "private" {
#  count = "${var.create_vpc && local.max_subnet_length > 0 ? local.nat_gateway_count : 0}"
#
#  vpc_id = "${local.vpc_id}"
#
#  lifecycle {
# When attaching VPN gateways it is common to define aws_vpn_gateway_route_propagation
# resources that manipulate the attributes of the routing table (typically for the private subnets)
#    ignore_changes = ["propagating_vgws"]
#  }
#}

##############
# VPN Gateway
##############
resource "aws_vpn_gateway" "this" {
  count = "${var.create_vpc && var.enable_vpn_gateway ? 1 : 0}"

  vpc_id          = "${local.vpc_id}"
  amazon_side_asn = "${var.amazon_side_asn}"

  tags {
    Name      = "vgw-${var.vpc_name}"
    Terraform = "true"
    Owner     = "aaron.lauer"
  }
}

resource "aws_vpn_gateway_route_propagation" "this" {
  count = "${var.create_vpc && var.enable_vpn_gateway ? 1 : 0}"

  vpn_gateway_id = "${aws_vpn_gateway.this.id}"
  route_table_id = "${aws_vpc.this.default_route_table_id}"
}

#resource "aws_vpn_gateway_attachment" "this" {
#  count = "${var.vpn_gateway_id != "" ? 1 : 0}"

#  vpc_id         = "${local.vpc_id}"
#  vpn_gateway_id = "${var.vpn_gateway_id}"
#}

resource "aws_dx_gateway_association" "this" {
  count          = "${var.create_vpc && var.enable_dx_gateway && var.enable_vpn_gateway ? 1 : 0}"
  dx_gateway_id  = "${var.dxg_id}"
  vpn_gateway_id = "${aws_vpn_gateway.this.id}"

  timeouts {
    create = "30m"
    delete = "30m"
  }
}

resource "aws_subnet" "public" {
  count                           = "${var.create_vpc > 0 ? var.number_of_subnets : 0}"
  vpc_id                          = "${aws_vpc.this.id}"
  cidr_block                      = "${cidrsubnet(aws_vpc.this.cidr_block, 8, count.index)}"
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = false
  availability_zone               = "${element(data.aws_availability_zones.available.names, count.index)}"

  tags {
    Name      = "pureport-${element(data.aws_availability_zones.available.names, count.index)}-public"
    Terraform = "true"
    Owner     = "aaron.lauer"
  }
}

resource "aws_security_group" "allow_all" {
  count  = "${var.create_vpc}"
  vpc_id = "${aws_vpc.this.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.office_ip}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name      = "allow-all"
    Terraform = "true"
    Owner     = "aaron.lauer"
  }
}
