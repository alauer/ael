variable "region" {}
variable "role_arn" {}
variable "vpc_name" {}
variable "vpc_cidr" {}
variable "office_ip" {
  default = "136.41.224.23/32"
}

variable "enable_vpn_gateway" {
  description = "Should be true if you want to create a new VPN Gateway resource and attach it to the VPC"
  default     = false
}

variable "vpn_gateway_id" {
  description = "ID of VPN Gateway to attach to the VPC"
  default     = ""
}

variable "create_vpc" {
  default = "false"
}

variable "number_of_subnets" {
  default = "3"
}

variable "amazon_side_asn" {
  default ="64512"
}

variable "secondary_cidr_blocks" {
  description = "List of secondary CIDR blocks to associate with the VPC to extend the IP Address pool"
  default     = []
}
