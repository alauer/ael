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

module "vnet" {
  source              = "Azure/vnet/azurerm"
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
