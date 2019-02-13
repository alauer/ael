output "dxg_id" {
  description = "The ID of the Direct Connect Gateway"
  value = "${element(concat(aws_dx_gateway.this.*.id, list("")), 0)}"
}

output "primary_vif" {
  description = "The ID of the VIF on the Primary Connection"
  value = "${element(concat(aws_dx_private_virtual_interface.primary.*.id, list("")), 0)}"
}

output "secondary_vif" {
    description = "The ID of the VIF on the Secondary Connection"
    value = "${element(concat(aws_dx_private_virtual_interface.secondary.*.id, list("")), 0)}"
}
