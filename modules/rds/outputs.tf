# modules/rds/outputs.tf

output "rds_db_instance_identifier" {
  value = aws_db_instance.rds.identifier
}

output "rds_db_name" {
  value = aws_db_instance.rds.db_name
}

output "db_private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "db_route_table_ids" {
  value = aws_route_table.private[*].id
}

output "vpc_id" {
  value = aws_vpc.this.id
}
