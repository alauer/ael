output "ael-demo-exprt-Service-Key" {
  description = "Expressroute Service Key"
  value = ["${azurerm_express_route_circuit.ael-demo-exprt.service_key}"]
}

output "ael-demo-exprt-Circuit-id" {
  description = "Expressroute Service Key"
  value = ["${azurerm_express_route_circuit.ael-demo-exprt.id}"]
}
