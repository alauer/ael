variable "aws_region" {
  default = "us-east-1"
}
variable "office_ip" {}

variable "vpc1_name" {}
variable "vpc1_cidr" {
  default = "10.0.0.0/16"
}
variable "vpc1_public_subnets" {
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

#variable "create_second_vpc" {
#  default = "false"
#}
#variable "aws_region2" {
#  default = "eu-west-1"
#}
#
#variable "vpc2_name" {}
#variable "vpc2_cidr" {
#  default = "10.10.0.0/16"
#}
#variable "vpc2_public_subnets" {
#  default = ["10.10.101.0/24", "10.10.102.0/24", "10.10.103.0/24"]
#}

variable "dx_connection_id_primary" {}
variable "dx_connection_id_secondary" {}
variable "bgp_pureport_asn" {}
variable "pureport_vlan_primary" {}
variable "pureport_vlan_secondary" {}
variable "bgp_auth_key_primary" {}
variable "bgp_auth_key_secondary" {}

variable "azure_resource_group_name" {}
variable "azure_location" {}
variable "azure_peering_location"{
  type = "map"
  default = {
    "westus2" = "Seattle"
  }
}
