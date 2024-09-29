# modules/nat/outputs.tf

output "nat_instance_network_interface_ids" {
  description = "NAT 인스턴스의 네트워크 인터페이스 IDs"
  value       = [for instance in aws_instance.nat : instance.primary_network_interface_id]
}

output "nat_instance_ids" {
  value = aws_instance.nat.*.primary_network_interface_id
}
