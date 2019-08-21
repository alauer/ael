variable "azure_resource_group_name" {
  default = "us-east-sol-eng"
}

variable "azure_location" {
  default = "westus"
}

variable "azure_peering_location" {
  type = "map"

  default = {
    "westus"  = "Silicon Valley"
    "westus2" = "Seattle"
    "eastus"  = "Washington DC"
    "eastus2" = "Washington DC"
  }
}

variable "office_ip" {
  default = "136.41.224.23/32"
}

variable "create_expr_peering" {
  default = "true"
}

provider "azurerm" {
  version = "= 1.24.0"
  alias   = "azure"
}

resource "pureport_azure_connection" "ael_westus_terraform_lab" {
  provider          = "pureport.terraform-testing"
  name              = "ael-westus-terraform-lab"
  speed             = "50"
  high_availability = true

  location_href = "${data.pureport_locations.sjc.locations.0.href}"
  network_href  = "${data.pureport_networks.main.networks.0.href}"

  service_key = "${azurerm_express_route_circuit.ael-use1-terraform-lab.service_key}"
}

resource "azurerm_express_route_circuit" "ael-use1-terraform-lab" {
  provider              = "azurerm.azure"
  name                  = "ael-use1-terraform-lab"
  resource_group_name   = "${var.azure_resource_group_name}"
  location              = "${var.azure_location}"                                     #This needs to be in a variables file
  service_provider_name = "Equinix"                                                   #This needs to be in a variables file
  peering_location      = "${lookup(var.azure_peering_location, var.azure_location)}" #This needs to be in a variables file
  bandwidth_in_mbps     = 50                                                          #hardcode this to save money in dev account

  sku {
    tier   = "Standard"
    family = "MeteredData"
  }

  tags = {
    Terraform   = "true"
    Environment = "1-expr"
    Owner       = "aaron.lauer"
  }
}

resource "azurerm_express_route_circuit_peering" "test" {
  provider                      = "azurerm.azure"
  count                         = "${var.create_expr_peering ? 1 : 0}"
  peering_type                  = "AzurePrivatePeering"
  express_route_circuit_name    = "${azurerm_express_route_circuit.ael-use1-terraform-lab.name}"
  resource_group_name           = "${var.azure_resource_group_name}"
  peer_asn                      = "${pureport_azure_connection.ael_westus_terraform_lab.gateways.0.pureport_asn}"
  primary_peer_address_prefix   = "${pureport_azure_connection.ael_westus_terraform_lab.gateways.0.peering_subnet}"
  secondary_peer_address_prefix = "${pureport_azure_connection.ael_westus_terraform_lab.gateways.1.peering_subnet}"
  vlan_id                       = 100
  shared_key                    = "${pureport_azure_connection.ael_westus_terraform_lab.gateways.0.bgp_password}"
}
