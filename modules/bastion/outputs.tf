# Bastion 인스턴스의 첫 번째 네트워크 인터페이스 ID 출력
output "bastion_network_interface_id" {
  description = "Bastion 호스트의 네트워크 인터페이스 ID"
  value       = aws_instance.bastion.primary_network_interface_id  # Primary network interface ID 사용
}
