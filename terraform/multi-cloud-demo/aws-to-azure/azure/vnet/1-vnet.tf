terraform {
  backend "s3" {
    bucket = "ael-demo-tf-statefiles"
    key    = "ael-tf-state/aws-azure/azure/vnet/vnet.tfstate"
    region = "us-east-1"
  }
}

resource "azurerm_virtual_network" "sales-demo" {
  name                = "sales-demo-vnet-${var.azure_location}"
  location            = "${var.azure_location}"
  resource_group_name = "${var.azure_resource_group_name}"
  address_space       = ["172.16.33.0/24"]

  tags {
    Terraform = "true"
    Owner     = "Solutions Engineering"
  }
}

resource "azurerm_subnet" "sales-demo" {
  name                 = "sales-demo-subnet1"
  resource_group_name  = "${var.azure_resource_group_name}"
  virtual_network_name = "${azurerm_virtual_network.sales-demo.name}"
  address_prefix       = "172.16.33.0/26"
}

resource "azurerm_public_ip" "sales-demo" {
  name                = "sales-demo-pip-vnetgw"
  resource_group_name = "${var.azure_resource_group_name}"
  location            = "${var.azure_location}"

  allocation_method = "Dynamic"

  tags {
    Terraform = "true"
    Owner     = "Solutions Engineering"
  }
}

resource "azurerm_public_ip" "vm-main" {
  name                = "${var.prefix}-pip"
  location            = "${var.azure_location}"
  resource_group_name = "${var.azure_resource_group_name}"
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "sales-demo" {
  name                = "sales-demo-nic"
  location            = "${var.azure_location}"
  resource_group_name = "${var.azure_resource_group_name}"

  ip_configuration {
    name                          = "sales-demo-configuration1"
    subnet_id                     = "${azurerm_subnet.sales-demo.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.vm-main.id}"
  }
}

/*
resource "azurerm_virtual_network_gateway_connection" "sales-demo" {
name                = "sales-demo-vnet-gw1-conn-pureport"
  resource_group_name = "${var.azure_resource_group_name}"
  location            = "${var.azure_location}"

  type                       = "ExpressRoute"
  virtual_network_gateway_id = "${azurerm_virtual_network_gateway.sales-demo.id}"

  express_route_circuit_id = "/subscriptions/c0d488be-6472-4d1d-ada5-40914167eeb4/resourceGroups/us-east-sol-eng/providers/Microsoft.Network/expressRouteCircuits/ael-expressRoute1"
}
*/

/*
resource "azurerm_virtual_network_gateway" "sales-demo" {
  name                = "sales-demo-vnet-gw1"
  resource_group_name = "${var.azure_resource_group_name}"
  location            = "${var.azure_location}"

  type       = "ExpressRoute"
  enable_bgp = true
  sku        = "Standard"

  ip_configuration {
    name                          = "sales-demo-vnetGatewayConfig"
    public_ip_address_id          = "${azurerm_public_ip.sales-demo.id}"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "${azurerm_subnet.sales-demo.id}"
  }

  tags {
    Terraform = "true"
    Owner     = "Solutions Engineering"
  }
}

resource "azurerm_subnet" "sales-demogw" {
  name                 = "sales-demo-GatewaySubnet"
  resource_group_name  = "${var.azure_resource_group_name}"
  virtual_network_name = "${azurerm_virtual_network.sales-demo.name}"
  address_prefix       = "172.16.33.224/27"
}
*/
resource "azurerm_network_security_group" "allow_all" {
  name                = "sales-demo-ssh-nsg1"
  location            = "${var.azure_location}"
  resource_group_name = "${var.azure_resource_group_name}"

  security_rule {
    name                       = "sales-demo_allow_clouds"
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["${var.office_ip}"]
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "sales-demo_allow_all_ssh"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    Terraform = "true"
    Owner     = "Solutions Engineering"
  }
}

#resource "azurerm_subnet_network_security_group_association" "ssh" {
#  subnet_id                 = "${azurerm_subnet.test.id}"
#  network_security_group_id = "${azurerm_network_security_group.ssh.id}"
#}

