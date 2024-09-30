# modules/bastion/outputs.tf

output "bastion_primary_network_interface_id" {
  value = tolist([for ni in aws_instance.bastion.network_interface : ni.id])[0]
}

output "bastion_instance_id" {
  value = aws_instance.bastion.id
}