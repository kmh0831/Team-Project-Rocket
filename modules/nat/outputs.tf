# modules/nat/outputs.tf

output "nat_network_interface_ids" {
  value = aws_instance.nat.*.network_interface_id
}
