/*
output "" {
  description = ""
  value       = "${module.db.}"
}
*/

output "wordpress_vm_public_ip" {
  description = "Wordpress Public IP"
  value       = "${azurerm_public_ip.vm-main.ip_address}"
}

output "wordpress_vm_private_ip" {
  description = "Wordpress Private IP"
  value       = "${azurerm_network_interface.ael-wordpress1.private_ip_address}"
}
