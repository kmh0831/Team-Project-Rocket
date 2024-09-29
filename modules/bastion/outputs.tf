# modules/bastion/outputs.tf (수정된 부분)
output "bastion_network_interface_id" {
  description = "Bastion 호스트의 네트워크 인터페이스 ID"
  value       = aws_instance.bastion.network_interface_ids[0]  # 첫 번째 네트워크 인터페이스 ID 참조
}