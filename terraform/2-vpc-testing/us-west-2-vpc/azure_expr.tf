variable "resource_group_name" {}

provider "azurerm" {
  version = "~> 1.21"
}

resource "azurerm_express_route_circuit" "ael-kb-exprt" {
  name                  = "ael-expressRoute1"
  resource_group_name   = "us-west2-dev"      #This needs to be in a variables file
  location              = "westus2"           #This needs to be in a variables file
  service_provider_name = "Equinix"           #This needs to be in a variables file
  peering_location      = "Seattle"           #This needs to be in a variables file
  bandwidth_in_mbps     = 50                  #This needs to be in a variables file

  sku {
    tier   = "Standard"
    family = "MeteredData"
  }

  tags {
    Terraform = "true"
    Owner     = "aaron.lauer"
  }
}

module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = "us-west2-dev"
  location            = "westus2"
  address_space       = "10.20.0.0/16"
  subnet_prefixes     = ["10.20.1.0/24", "10.20.2.0/24", "10.20.3.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]

  tags = {
    Terraform = "true"
    Owner     = "aaron.lauer"
  }
}

resource "azurerm_subnet" "subnet" {
  name  = "subnet1"
  address_prefix = "10.20.1.0/24"
  resource_group_name = "${var.resource_group_name}"
  virtual_network_name = "ael-kb-test1"
}

resource "azurerm_network_security_group" "ssh" {
  depends_on          = ["module.network"]
  name                = "ssh"
  location            = "westus2"
  resource_group_name = "us-west2-dev"

  security_rule {
    name                       = "allow_all_ael"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
#    source_address_prefixes      = "${var.vpc1_public_subnets}"
    source_address_prefixes    = "${list("${var.vpc1_cidr}","${var.vpc2_cidr}","${var.office_ip}")}"
    destination_address_prefix = "*"
  }

}

resource "azurerm_subnet_network_security_group_association" "ssh" {
  subnet_id                 = "${azurerm_subnet.subnet.id}"
  network_security_group_id = "${azurerm_network_security_group.ssh.id}"
}
