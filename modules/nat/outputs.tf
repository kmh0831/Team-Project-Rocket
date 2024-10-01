# modules/nat/outputs.tf

output "nat_instance_network_interface_ids" {
  value = aws_instance.nat.*.primary_network_interface_id
}

output "nat_instance_ids" {
  value = aws_instance.nat.*.id
}
