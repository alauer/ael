locals {
  pureport_network          = ["10.20.0.0/16", "10.33.133.0/24", "10.10.10.0/24", "172.16.0.0/16"]
  azure_resource_group_name = "us-east-sol-eng"
  azure_location            = "southcentralus"
  azure_peering_location    = "Dallas"
  office_ip                 = "136.41.224.23/32"
}

provider "azurerm" {
  version = "~> 1.31.0"
  alias   = "azure"
}

//
// CREATE VNET AND SUBNETS
//

resource "azurerm_virtual_network" "vnet" {
  name                = "ael-demo1-demo"
  location            = local.azure_location
  resource_group_name = local.azure_resource_group_name
  address_space       = ["172.16.0.0/16"]

  tags = {
    Terraform   = "true"
    Environment = "1-expr"
    Owner       = "aaron.lauer"
  }
}

resource "azurerm_subnet" "demo1" {
  depends_on           = [azurerm_virtual_network.vnet]
  name                 = "demo1"
  resource_group_name  = local.azure_resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = "172.16.33.0/27"
}

//
//
//   CREATE VNET GATEWAY AND IT's PUBLIC IP
//
//
resource "azurerm_subnet" "ael-demo1-gwvnet" {
  depends_on           = [azurerm_virtual_network.vnet]
  name                 = "GatewaySubnet"
  resource_group_name  = local.azure_resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = "172.16.33.224/27"
}

resource "azurerm_public_ip" "ael-demo1" {
  name                = "ael-demo1-pip-vnetgw"
  resource_group_name = local.azure_resource_group_name
  location            = local.azure_location

  allocation_method = "Dynamic"

  tags = {
    Terraform   = "true"
    Environment = "1-expr"
    Owner       = "aaron.lauer"
  }
}

resource "azurerm_virtual_network_gateway" "ael-demo1" {
  depends_on          = [azurerm_subnet.ael-demo1-gwvnet]
  name                = "ael-demo1-vnet-gw1"
  resource_group_name = local.azure_resource_group_name
  location            = local.azure_location

  type       = "ExpressRoute"
  enable_bgp = true
  sku        = "Standard"

  ip_configuration {
    name                          = "ael-demo1-vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.ael-demo1.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.ael-demo1-gwvnet.id
  }

  tags = {
    Terraform   = "true"
    Environment = "1-expr"
    Owner       = "aaron.lauer"
  }
}
