# modules/bastion/outputs.tf

# bastion/outputs.tf
output "bastion_primary_network_interface_id" {
  value = aws_instance.bastion.network_interface[0].id
}

output "bastion_instance_id" {
  value = aws_instance.bastion.id
}