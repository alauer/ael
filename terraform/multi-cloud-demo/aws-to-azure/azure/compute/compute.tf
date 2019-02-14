terraform {
  backend "s3" {
    bucket = "ael-demo-tf-statefiles"
    key    = "ael-tf-state/aws-azure/azure/compute/compute.tfstate"
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
