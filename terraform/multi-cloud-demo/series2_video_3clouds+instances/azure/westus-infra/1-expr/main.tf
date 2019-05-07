// EXPR ID: /subscriptions/c0d488be-6472-4d1d-ada5-40914167eeb4/resourceGroups/us-east-sol-eng/providers/Microsoft.Network/expressRouteCircuits/ael-KBexpressRoute1

terraform {
  backend "s3" {
    bucket = "ael-demo-tf-statefiles"
    key    = "ael-tf-state/videoseries2-3clouds/videoseries2-3clouds-expr.tfstate"
    region = "us-east-1"
  }
}

locals {
  pureport_network          = ["10.20.0.0/16", "10.33.133.0/24", "10.10.10.0/24"]
  azure_resource_group_name = "us-east-sol-eng"
  azure_location            = "westus"
  azure_peering_location    = "Silicon Valley"
  office_ip                 = "136.41.224.23/32"
  expr_id                   = "/subscriptions/c0d488be-6472-4d1d-ada5-40914167eeb4/resourceGroups/us-east-sol-eng/providers/Microsoft.Network/expressRouteCircuits/ael-KBexpressRoute1"
}

provider "azurerm" {
  version = "=1.24.0"
}

resource "azurerm_express_route_circuit_peering" "wordpress-demo" {
  peering_type                  = "AzurePrivatePeering"
  express_route_circuit_name    = "ael-KBexpressRoute1"
  resource_group_name           = "${local.azure_resource_group_name}"
  peer_asn                      = 394351
  primary_peer_address_prefix   = "169.254.1.0/30"
  secondary_peer_address_prefix = "169.254.2.0/30"
  vlan_id                       = 100
  shared_key                    = "IDt25veH3cDpGJ9uvmCZG"
}
