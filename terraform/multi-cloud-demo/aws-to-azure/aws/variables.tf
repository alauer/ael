#variable "aws_region" {
#  default = "us-east-1"
#}
variable "office_ip" {}

#variable "vpc1_name" {}
#variable "vpc1_cidr" {
#  default = "10.0.0.0/16"
#}
#variable "vpc1_public_subnets" {
#  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
#}

variable "dx_connection_id_primary" {
  default = ""
}

variable "dx_connection_id_secondary" {
  default = ""
}

variable "bgp_pureport_asn" {}
variable "pureport_vlan_primary" {}
variable "pureport_vlan_secondary" {}
variable "bgp_auth_key_primary" {}
variable "bgp_auth_key_secondary" {}
