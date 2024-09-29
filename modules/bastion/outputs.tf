# modules/bastion/outputs.tf

output "bastion_network_interface_id" {
  value = aws_instance.bastion.network_interface_id
}
