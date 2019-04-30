// EXPR ID: /subscriptions/c0d488be-6472-4d1d-ada5-40914167eeb4/resourceGroups/us-east-sol-eng/providers/Microsoft.Network/expressRouteCircuits/ael-KBexpressRoute1

terraform {
  backend "s3" {
    bucket = "ael-demo-tf-statefiles"
    key    = "ael-tf-state/videoseries2-3clouds/videoseries2-3clouds-expr.tfstate"
    region = "us-east-1"
  }
}

locals {
  pureport_network          = ["10.20.0.0/16", "10.33.133.0/24"]
  azure_resource_group_name = "us-east-sol-eng"
  azure_location            = "westus"
  azure_peering_location    = "Silicon Valley"
  office_ip                 = "136.41.224.23/32"
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

module "vnet" {
  source              = "Azure/vnet/azurerm"
  resource_group_name = "${local.azure_resource_group_name}"
  location            = "${local.azure_location}"
  vnet_name           = "ael-wordpress-demo"
  address_space       = "172.16.0.0/16"
  subnet_prefixes     = ["172.16.33.0/27"]
  subnet_names        = ["wordpress1"]
  dns_servers         = ["10.20.101.5", "10.20.102.5"]

  tags {
    Terraform   = "true"
    Environment = "1-expr"
    Owner       = "aaron.lauer"
  }
}

//
//
//   CREAT VNET GATEWAY AND SUBNET
//
//

resource "azurerm_subnet" "ael-wordpress-gwvnet" {
  depends_on           = ["module.vnet"]
  name                 = "GatewaySubnet"
  resource_group_name  = "${local.azure_resource_group_name}"
  virtual_network_name = "${module.vnet.vnet_name}"
  address_prefix       = "172.16.33.224/27"
}

resource "azurerm_public_ip" "ael-wordpress" {
  name                = "ael-wordpress-pip-vnetgw"
  resource_group_name = "${local.azure_resource_group_name}"
  location            = "${local.azure_location}"

  allocation_method = "Dynamic"

  tags {
    Terraform = "true"
    Owner     = "aaron.lauer"
  }
}

resource "azurerm_virtual_network_gateway" "ael-kb-test" {
  name                = "ael-wordpress-vnet-gw1"
  resource_group_name = "${local.azure_resource_group_name}"
  location            = "${local.azure_location}"

  type       = "ExpressRoute"
  enable_bgp = true
  sku        = "Standard"

  ip_configuration {
    name                          = "ael-wordpress-vnetGatewayConfig"
    public_ip_address_id          = "${azurerm_public_ip.ael-wordpress.id}"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "${azurerm_subnet.ael-wordpress-gwvnet.id}"
  }

  tags {
    Terraform   = "true"
    Environment = "1-expr"
    Owner       = "aaron.lauer"
  }
}

//
//
//
//
//
//

