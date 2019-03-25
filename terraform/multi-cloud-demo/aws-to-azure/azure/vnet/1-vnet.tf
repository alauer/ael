terraform {
  backend "s3" {
    bucket = "ael-demo-tf-statefiles"
    key    = "ael-tf-state/aws-azure/azure/vnet/vnet.tfstate"
    region = "us-east-1"
  }
}

resource "azurerm_virtual_network" "ael-kb-test" {
  name                = "${var.prefix}-vnet-${var.azure_location}"
  location            = "${var.azure_location}"
  resource_group_name = "${var.azure_resource_group_name}"
  address_space       = ["172.16.33.0/24"]

  tags {
    Terraform = "true"
    Owner     = "aaron.lauer"
  }
}

resource "azurerm_subnet" "ael-kb-test" {
  name                 = "${var.prefix}-subnet1"
  resource_group_name  = "${var.azure_resource_group_name}"
  virtual_network_name = "${azurerm_virtual_network.ael-kb-test.name}"
  address_prefix       = "172.16.33.0/26"
}

resource "azurerm_public_ip" "ael-kb-test" {
  name                = "${var.prefix}-pip-vnetgw"
  resource_group_name = "${var.azure_resource_group_name}"
  location            = "${var.azure_location}"

  allocation_method = "Dynamic"

  tags {
    Terraform = "true"
    Owner     = "aaron.lauer"
  }
}

resource "azurerm_public_ip" "vm-main" {
  name                = "${var.prefix}-pip"
  location            = "${var.azure_location}"
  resource_group_name = "${var.azure_resource_group_name}"
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "ael-kb-test" {
  name                = "${var.prefix}-nic"
  location            = "${var.azure_location}"
  resource_group_name = "${var.azure_resource_group_name}"

  ip_configuration {
    name                          = "${var.prefix}-configuration1"
    subnet_id                     = "${azurerm_subnet.ael-kb-test.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.vm-main.id}"
  }
}

resource "azurerm_virtual_network_gateway_connection" "ael-kb-test" {
  name                = "${var.prefix}-vnet-gw1-conn-pureport"
  resource_group_name = "${var.azure_resource_group_name}"
  location            = "${var.azure_location}"

  type                       = "ExpressRoute"
  virtual_network_gateway_id = "${azurerm_virtual_network_gateway.ael-kb-test.id}"

  express_route_circuit_id = "/subscriptions/c0d488be-6472-4d1d-ada5-40914167eeb4/resourceGroups/us-east-sol-eng/providers/Microsoft.Network/expressRouteCircuits/ael-KBexpressRoute1"
}

resource "azurerm_virtual_network_gateway" "ael-kb-test" {
  name                = "${var.prefix}-vnet-gw1"
  resource_group_name = "${var.azure_resource_group_name}"
  location            = "${var.azure_location}"

  type       = "ExpressRoute"
  enable_bgp = true
  sku        = "Standard"

  ip_configuration {
    name                          = "${var.prefix}-vnetGatewayConfig"
    public_ip_address_id          = "${azurerm_public_ip.ael-kb-test.id}"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = "${azurerm_subnet.ael-kb-testgw.id}"
  }

  tags {
    Terraform = "true"
    Owner     = "aaron.lauer"
  }
}

resource "azurerm_subnet" "ael-kb-testgw" {
  name                 = "GatewaySubnet"
  resource_group_name  = "${var.azure_resource_group_name}"
  virtual_network_name = "${azurerm_virtual_network.ael-kb-test.name}"
  address_prefix       = "172.16.33.224/27"
}

resource "azurerm_network_security_group" "allow_all" {
  name                = "${var.prefix}-ssh-nsg1"
  location            = "${var.azure_location}"
  resource_group_name = "${var.azure_resource_group_name}"

  security_rule {
    name                    = "ael-kb-test_allow_clouds"
    priority                = 1010
    direction               = "Inbound"
    access                  = "Allow"
    protocol                = "*"
    source_port_range       = "*"
    destination_port_range  = "*"
    source_address_prefixes = ["${var.office_ip}"]

    source_address_prefixes    = ["${var.office_ip}", "10.20.0.0/16", "10.30.0.0/16"]
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "ael-kb-test_allow_all_ssh"
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
    Owner     = "aaron.lauer"
  }
}

#resource "azurerm_subnet_network_security_group_association" "ssh" {
#  subnet_id                 = "${azurerm_subnet.test.id}"
#  network_security_group_id = "${azurerm_network_security_group.ssh.id}"
#}

