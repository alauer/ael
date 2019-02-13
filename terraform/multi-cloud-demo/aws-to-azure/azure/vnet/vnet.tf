terraform {
  backend "s3" {
    bucket = "pureport-sol-eng"
    key    = "ael-tf-state/aws-azure/azure/vnet/vnet.tfstate"
    region = "us-east-1"
    role_arn = "arn:aws:iam::696238294826:role/DevAdmin"
    profile = "devadmin"
  }
}

variable "azure_resource_group_name" {
  default = "us-east-sol-eng"
}
variable "azure_location" {
  default = "eastus2"
}
variable "azure_peering_location"{
  type = "map"
  default = {
    "westus2" = "Seattle"
    "eastus" = "Washington DC"
    "eastus2" = "Washington DC"
  }
}

variable "office_ip" {
  default = "136.41.224.23/32"
}



provider "azurerm" {
  version = "~> 1.21"
}

resource "azurerm_virtual_network" "test" {
  name                = "ael-demo-vnet-useast2"
  location            = "${var.azure_location}"
  resource_group_name = "${var.azure_resource_group_name}"
  address_space       = ["10.100.0.0/16"]

  tags {
    Terraform = "true"
    Owner = "aaron.lauer"
  }
}

resource "azurerm_subnet" "test" {
  name                 = "ael-demo-subnet1"
  resource_group_name  = "${var.azure_resource_group_name}"
  virtual_network_name = "${azurerm_virtual_network.test.name}"
  address_prefix       = "10.100.1.0/24"

}

resource "azurerm_subnet" "GatewaySubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = "${var.azure_resource_group_name}"
  virtual_network_name = "${azurerm_virtual_network.test.name}"
  address_prefix       = "10.100.254.0/26"

}



resource "azurerm_network_security_group" "ssh" {
  name                = "ael-ssh"
  location            = "${var.azure_location}"
  resource_group_name = "${var.azure_resource_group_name}"

  security_rule {
    name                       = "allow_all_ael"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["${var.office_ip}", "10.10.0.0/16", "10.20.0.0/16"]
    destination_address_prefix = "*"
  }
  tags {
    Terraform = "true"
    Owner     = "aaron.lauer"
  }

}

resource "azurerm_subnet_network_security_group_association" "ssh" {
  subnet_id                 = "${azurerm_subnet.test.id}"
  network_security_group_id = "${azurerm_network_security_group.ssh.id}"
}

resource "azurerm_public_ip" "test" {
  name                = "ael-publicip1"
  resource_group_name   = "${var.azure_resource_group_name}"
  location              = "${var.azure_location}"

  allocation_method = "Dynamic"

  tags {
    Terraform = "true"
    Owner     = "aaron.lauer"
  }
}

resource "azurerm_virtual_network_gateway" "vnetGateway" {
  name = "ael-vnet-gw1"
  resource_group_name   = "${var.azure_resource_group_name}"
  location              = "${var.azure_location}"

  type = "ExpressRoute"
  enable_bgp = true
  sku = "Standard"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = "${azurerm_public_ip.test.id}"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "${azurerm_subnet.GatewaySubnet.id}"
  }
  tags {
    Terraform = "true"
    Owner     = "aaron.lauer"
  }
}

resource "azurerm_virtual_network_gateway_connection" "vnetGWC" {
  name                = "ael-vnet-gw1-conn-pureport"
  resource_group_name   = "${var.azure_resource_group_name}"
  location              = "${var.azure_location}"

  type                            = "ExpressRoute"
  virtual_network_gateway_id      = "${azurerm_virtual_network_gateway.vnetGateway.id}"

  express_route_circuit_id        = "/subscriptions/c0d488be-6472-4d1d-ada5-40914167eeb4/resourceGroups/us-east-sol-eng/providers/Microsoft.Network/expressRouteCircuits/ael-expressRoute1"
}
