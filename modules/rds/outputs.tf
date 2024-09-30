# modules/rds/outputs.tf

output "rds_db_instance_identifier" {
  value = aws_db_instance.rds.identifier
}

output "rds_db_name" {
  value = aws_db_instance.rds.db_name
}
