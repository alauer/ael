provider "azurerm" {
  version = "~> 1.21"
}

resource "azurerm_express_route_circuit" "ael-kb-exprt" {
  name                  = "ael-expressRoute1"
  resource_group_name   = "us-west2-dev" #This needs to be in a variables file
  location              = "westus2" #This needs to be in a variables file
  service_provider_name = "Equinix" #This needs to be in a variables file
  peering_location      = "Seattle" #This needs to be in a variables file
  bandwidth_in_mbps     = 50 #This needs to be in a variables file

  sku {
    tier   = "Standard"
    family = "MeteredData"
  }

  tags {
  Terraform = "true"
  Owner       = "aaron.lauer"
  }
}
