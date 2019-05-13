terraform {
  backend "s3" {
    bucket = "ael-demo-tf-statefiles"
    key    = "ael-tf-state/videoseries2-3clouds/videoseries2-3clouds-azureapp.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "vnet" {
  backend = "s3"

  config {
    bucket = "ael-demo-tf-statefiles"
    key    = "ael-tf-state/videoseries2-3clouds/videoseries2-3clouds-vnet.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "rds" {
  backend = "s3"

  config {
    bucket = "ael-demo-tf-statefiles"
    key    = "ael-tf-state/videoseries2-3clouds/videoseries2-3clouds-app.tfstate"
    region = "us-east-1"
  }
}

data "template_file" "test" {
  template = <<EOF
#cloud-config
package_update: true

runcmd:
  - [ sh, -c, 'docker run --name wordpress -p 8080:80 -e WORDPRESS_DB_HOST=${data.terraform_remote_state.rds.rds_cluster_endpoint}:3306 -e WORDPRESS_DB_PASSWORD=${data.terraform_remote_state.rds.rds_cluster_master_password} --restart unless-stopped -d wordpress:latest']
  - [ sh, -c, 'docker run --name myadmin -d -e PMA_HOST=${data.terraform_remote_state.rds.rds_cluster_endpoint} -e MYSQL_ROOT_PASSWORD=${data.terraform_remote_state.rds.rds_cluster_master_password} --restart unless-stopped -p 8181:80 phpmyadmin/phpmyadmin']

output:
  all: '| tee -a /var/log/cloud-init-output.log'
EOF
}

locals {
  pureport_network          = ["10.20.0.0/16", "10.33.133.0/24", "10.10.10.0/24", "172.16.0.0/16"]
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
    subnet_id                     = "${data.terraform_remote_state.vnet.wordpress_subnet_id}"
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
    id = "/subscriptions/c0d488be-6472-4d1d-ada5-40914167eeb4/resourceGroups/us-east-sol-eng/providers/Microsoft.Compute/images/ael-wordpress-vm-image-20190513135704"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "ael-wordpress-demo"
    admin_username = "soleng"
    admin_password = "7%dUZ4iLM)KtwUzV"
    custom_data    = "${data.template_file.test.rendered}"
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
