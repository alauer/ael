terraform {
  backend "s3" {
    bucket = "ael-demo-tf-statefiles"
    key    = "ael-tf-state/videoseries2-3clouds/videoseries2-3clouds-app.tfstate"
    region = "us-east-1"
  }
}

locals {
  pureport_network          = ["10.20.0.0/16", "10.33.133.0/24"]
  azure_resource_group_name = "us-east-sol-eng"
  azure_location            = "westus"
  azure_peering_location    = "Silicon Valley"
  office_ip                 = "136.41.224.23/32"
  expr_id                   = "/subscriptions/c0d488be-6472-4d1d-ada5-40914167eeb4/resourceGroups/us-east-sol-eng/providers/Microsoft.Network/expressRouteCircuits/ael-KBexpressRoute1"
}

provider "azurerm" {
  version = "=1.24.0"
}

//
//  PROVISION COMPUTE INSTANCE
//
resource "azurerm_public_ip" "vm-main" {
  name                = "ael-wordpress-pip"
  resource_group_name = "${local.azure_resource_group_name}"
  location            = "${local.azure_location}"
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "ael-wordpress1" {
  name                = "ael-wordpress-nic"
  resource_group_name = "${local.azure_resource_group_name}"
  location            = "${local.azure_location}"

  ip_configuration {
    name                          = "ael-wordpress-configuration1"
    subnet_id                     = "${azurerm_subnet.wordpress1.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.vm-main.id}"
  }
}

resource "azurerm_virtual_machine" "main" {
  name = "ael-wordpress-vm"

  resource_group_name   = "${local.azure_resource_group_name}"
  location              = "${local.azure_location}"
  network_interface_ids = ["${azurerm_network_interface.ael-wordpress1.id}"]
  vm_size               = "Standard_B1s"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "sales-demo-vm"
    admin_username = "soleng"
    admin_password = "7%dUZ4iLM)KtwUzV"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    Terraform   = "true"
    Environment = "1-expr"
    Owner       = "aaron.lauer"
  }
}
