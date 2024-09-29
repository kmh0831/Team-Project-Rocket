output "nat_network_interface_ids" {
  value = aws_instance.nat.*.primary_network_interface_id
}
