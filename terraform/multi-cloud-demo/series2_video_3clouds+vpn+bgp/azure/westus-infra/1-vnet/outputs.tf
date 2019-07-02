/*
output "" {
  description = ""
  value       = "${module.db.}"
}
*/

output "wordpress_subnet_id" {
  description = "The subnet ID"
  value       = "${azurerm_subnet.wordpress1.id}"
}
