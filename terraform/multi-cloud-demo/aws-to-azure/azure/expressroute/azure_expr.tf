terraform {
  backend "s3" {
    bucket = "ael-demo-tf-statefiles"
    key    = "ael-tf-state/aws-azure/azure/expressroute/expr.tfstate"
    region = "us-east-1"
  }
}

variable "azure_resource_group_name" {
  default = "us-east-sol-eng"
}

variable "azure_location" {
  default = "eastus2"
}

variable "azure_peering_location" {
  type = "map"

  default = {
    "westus2" = "Seattle"
    "eastus"  = "Washington DC"
    "eastus2" = "Washington DC"
  }
}

variable "office_ip" {
  default = "136.41.224.23/32"
}

provider "azurerm" {
  version = "~> 1.21"
}

resource "azurerm_express_route_circuit" "ael-demo-exprt" {
  name                  = "ael-expressRoute1"
  resource_group_name   = "${var.azure_resource_group_name}"
  location              = "${var.azure_location}"                                     #This needs to be in a variables file
  service_provider_name = "Equinix"                                                   #This needs to be in a variables file
  peering_location      = "${lookup(var.azure_peering_location, var.azure_location)}" #This needs to be in a variables file
  bandwidth_in_mbps     = 50                                                          #hardcode this to save money in dev account

  sku {
    tier   = "Standard"
    family = "MeteredData"
  }

  tags {
    Terraform = "true"
    Owner     = "aaron.lauer"
  }
}

resource "azurerm_express_route_circuit_peering" "test" {
  peering_type                  = "AzurePrivatePeering"
  express_route_circuit_name    = "${azurerm_express_route_circuit.ael-demo-exprt.name}"
  resource_group_name           = "${var.azure_resource_group_name}"
  peer_asn                      = 394351
  primary_peer_address_prefix   = "192.168.100.128/30"
  secondary_peer_address_prefix = "192.168.100.132/30"
  vlan_id                       = 100
  shared_key                    = "QaHGLGsPcDc5hnqd88c2d"
}
