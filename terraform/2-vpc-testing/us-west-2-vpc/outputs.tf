# DXG
#output "ael-kb-dxg1" {
#  description = "List of IDs of DXG"
#  value = ["${aws_dx_gateway.ael-kb-test.id}"]
#}

output "ael-kb-exprt Service Key" {
  description = "Expressroute Service Key"
  value = ["${azurerm_express_route_circuit.ael-kb-exprt.service_key}"]
}
