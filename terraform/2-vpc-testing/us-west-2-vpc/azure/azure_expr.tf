variable "azure_resource_group_name" {
  default = "us-east-sol-eng"
}
variable "azure_location" {
  default = "eastus"
}
variable "azure_peering_location"{
  type = "map"
  default = {
    "westus2" = "Seattle"
    "eastus" = "Asburn"
    "eastus2" = "Ashburn"
  }
}

variable "office_ip" {
  default = "136.41.224.23/32"
}



provider "azurerm" {
  version = "~> 1.21"
}


resource "azurerm_virtual_network" "test" {
  name                = "virtualNetwork1"
  location            = "${var.azure_location}"
  resource_group_name = "${var.azure_resource_group_name}"
  address_space       = ["10.100.0.0/16"]
  dns_servers         = ["10.100.0.4", "10.100.0.5"]

  tags {
    Terraform = "true"
    Owner = "aaron.lauer"
  }
}

resource "azurerm_subnet" "test" {
  name                 = "testsubnet"
  resource_group_name  = "${var.azure_resource_group_name}"
  virtual_network_name = "${azurerm_virtual_network.test.name}"
  address_prefix       = "10.100.1.0/24"

}



resource "azurerm_network_security_group" "ssh" {
  name                = "ssh"
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
    source_address_prefixes    = "${list(var.office_ip)}"
    destination_address_prefix = "*"
  }

}

resource "azurerm_subnet_network_security_group_association" "ssh" {
  subnet_id                 = "${azurerm_subnet.test.id}"
  network_security_group_id = "${azurerm_network_security_group.ssh.id}"
}


/*resource "azurerm_express_route_circuit" "ael-kb-exprt" {
  name                  = "ael-expressRoute1"
  resource_group_name   = "${var.azure_resource_group_name}"
  location              = "${var.azure_location}"           #This needs to be in a variables file
  service_provider_name = "Equinix"           #This needs to be in a variables file
  peering_location      = "${lookup(var.azure_peering_location, var.azure_location)}"           #This needs to be in a variables file
  bandwidth_in_mbps     = 50                  #hardcode this to save money in dev account

  sku {
    tier   = "Standard"
    family = "MeteredData"
  }

  tags {
    Terraform = "true"
    Owner     = "aaron.lauer"
  }
}*/
