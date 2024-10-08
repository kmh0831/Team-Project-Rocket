# modules/bastion/outputs.tf
output "bastion_instance_id" {
  value = aws_instance.bastion.id
}

output "bastion_primary_network_interface_id" {
  description = "Bastion 호스트의 주요 네트워크 인터페이스 ID"
  value       = aws_instance.bastion.primary_network_interface_id
}
