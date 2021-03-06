resource "azurerm_virtual_machine" "main" {
  count = "${var.create_vm ? 1 : 0}"
  name  = "${var.prefix}-vm"

  location              = "${var.azure_location}"
  resource_group_name   = "${var.azure_resource_group_name}"
  network_interface_ids = ["${azurerm_network_interface.ael-kb-test.id}"]
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

  tags {
    Terraform = "true"
    Owner     = "Solutions Engineering"
  }
}
