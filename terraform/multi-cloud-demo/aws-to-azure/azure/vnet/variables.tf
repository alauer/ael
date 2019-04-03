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
  default = "136.56.141.127/32"
}

variable "security_group_subnets" {
  default = ["172.16.33.0/24", "10.20.0.0/16", "10.33.133.0/24", "136.56.141.127/32", "136.56.44.125/32"]
}

variable "prefix" {
  default = "ael-kb"
}

data "azurerm_resource_group" "sol-eng" {
  name = "us-east-sol-eng"
}

variable "create_vm" {
  default = "true"
}
