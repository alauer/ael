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
  default = "71.70.232.202/32"
}

variable "prefix" {
  default = "sales-demo"
}

data "azurerm_resource_group" "sol-eng" {
  name = "us-east-sol-eng"
}
