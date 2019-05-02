terraform {
  backend "s3" {
    bucket = "ael-demo-tf-statefiles"
    key    = "ael-tf-state/videoseries2-3clouds/videoseries2-3clouds-vnet.tfstate"
    region = "us-east-1"
  }
}

locals {
  pureport_network          = ["10.20.0.0/16", "10.33.133.0/24"]
  azure_resource_group_name = "us-east-sol-eng"
  azure_location            = "westus"
  azure_peering_location    = "Silicon Valley"
  office_ip                 = "136.41.224.23/32"
  expr_id                   = "/subscriptions/c0d488be-6472-4d1d-ada5-40914167eeb4/resourceGroups/us-east-sol-eng/providers/Microsoft.Network/expressRouteCircuits/ael-KBexpressRoute1"
}

provider "azurerm" {
  version = "=1.24.0"
}

//
// CREATE VNET AND SUBNETS
//

resource "azurerm_virtual_network" "vnet" {
  name                = "ael-wordpress-demo"
  location            = "${local.azure_location}"
  resource_group_name = "${local.azure_resource_group_name}"
  address_space       = ["172.16.0.0/16"]
  dns_servers         = ["10.20.101.5", "10.20.102.5"]

  tags = {
    Terraform   = "true"
    Environment = "1-expr"
    Owner       = "aaron.lauer"
  }
}

resource "azurerm_subnet" "wordpress1" {
  depends_on           = ["azurerm_virtual_network.vnet"]
  name                 = "wordpress1"
  resource_group_name  = "${local.azure_resource_group_name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "172.16.33.0/27"
}

//
//
//   CREATE VNET GATEWAY AND IT's PUBLIC IP
//
//
resource "azurerm_subnet" "ael-wordpress-gwvnet" {
  depends_on           = ["azurerm_virtual_network.vnet"]
  name                 = "GatewaySubnet"
  resource_group_name  = "${local.azure_resource_group_name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "172.16.33.224/27"
}

resource "azurerm_public_ip" "ael-wordpress" {
  name                = "ael-wordpress-pip-vnetgw"
  resource_group_name = "${local.azure_resource_group_name}"
  location            = "${local.azure_location}"

  allocation_method = "Dynamic"

  tags = {
    Terraform   = "true"
    Environment = "1-expr"
    Owner       = "aaron.lauer"
  }
}

resource "azurerm_virtual_network_gateway" "ael-wordpress" {
  depends_on          = ["azurerm_subnet.ael-wordpress-gwvnet"]
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
//  VNET GW CONNECTION TO EXPR
//
//

resource "azurerm_virtual_network_gateway_connection" "ael-kb-test" {
  name                = "ael-wordpress-vnet-gw1-conn"
  resource_group_name = "${local.azure_resource_group_name}"
  location            = "${local.azure_location}"

  type                       = "ExpressRoute"
  virtual_network_gateway_id = "${azurerm_virtual_network_gateway.ael-wordpress.id}"

  express_route_circuit_id = "${local.expr_id}"
}
