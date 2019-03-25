output "ael-KB-exprt-Service-Key" {
  description = "Expressroute Service Key"
  value       = ["${azurerm_express_route_circuit.ael-KB-exprt.service_key}"]
}

output "ael-KB-exprt-Circuit-id" {
  description = "Expressroute Service Key"
  value       = ["${azurerm_express_route_circuit.ael-KB-exprt.id}"]
}
