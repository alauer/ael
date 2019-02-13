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


resource "azurerm_express_route_circuit" "ael-demo-exprt" {
  name                  = "ael-expressRoute1"
  resource_group_name   = "${var.azure_resource_group_name}"
  location              = "${var.azure_location}"           #This needs to be in a variables file
  service_provider_name = "Equinix"           #This needs to be in a variables file
  peering_location      = "${lookup(var.azure_peering_location, var.azure_location)}"           #This needs to be in a variables file
  bandwidth_in_mbps     = 100                  #hardcode this to save money in dev account

  sku {
    tier   = "Standard"
    family = "MeteredData"
  }

  tags {
    Terraform = "true"
    Owner     = "aaron.lauer"
  }
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

resource "azurerm_express_route_circuit_peering" "test" {
  peering_type                  = "AzurePrivatePeering"
  express_route_circuit_name    = "${azurerm_express_route_circuit.ael-demo-exprt.name}"
  resource_group_name   = "${var.azure_resource_group_name}"
  peer_asn                      = 394351
  primary_peer_address_prefix   = "192.168.100.128/30"
  secondary_peer_address_prefix = "192.168.100.132/30"
  vlan_id                       = 100
  shared_key = "Ez2e4oKElYA0gwO6gPlOS"
}
