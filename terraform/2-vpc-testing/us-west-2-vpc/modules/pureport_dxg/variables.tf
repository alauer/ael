variable "region" {}
variable "role_arn" {}
variable "dxg_name" {}
variable "directconnect_primary_id" {
  description = "ID of Direct Connect Primary Connection"
}

variable "directconnect_secondary_id" {
  description = "ID of Direct Connect Secondary Connection"
  default = ""
}

variable "office_ip" {
  default = "136.41.224.23/32"
}


variable "vpn_gateway_id" {
  description = "ID of VPN Gateway to attach to the VPC"
  default     = ""
}

variable "amazon_side_asn" {
  description = "You can choose a private ASN (64512 to 65534) or (4200000000 and 4294967294), or use the default of 64512"
  default ="64512"
}

variable "bgp_auth_key_primary"{
  description = "The BGP auth key of the Primary Gateway, get from the Pureport Console."
}

variable "bgp_auth_key_secondary"{
  description = "The BGP auth key of the Secondary Gateway, get from the connection information in Pureport Console."
}

variable "bgp_pureport_asn" {
  description = "The Pureport BGP ASN, get from the connection information in Pureport Console"
}
