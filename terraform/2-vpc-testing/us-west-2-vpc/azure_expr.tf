provider "azurerm" {
  version = "~> 1.21"
}

resource "azurerm_express_route_circuit" "ael-kb-exprt" {
  name                  = "ael-expressRoute1"
  resource_group_name   = "us-west2-dev"
  location              = "westus2"
  service_provider_name = "Equinix"
  peering_location      = "Seattle"
  bandwidth_in_mbps     = 50

  sku {
    tier   = "Standard"
    family = "MeteredData"
  }

  tags {
  Terraform = "true"
  Owner       = "aaron.lauer"
  }
}
