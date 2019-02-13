output "ael-demo-exprt-Service-Key" {
  description = "Expressroute Service Key"
  value = ["${azurerm_express_route_circuit.ael-demo-exprt.service_key}"]
}
