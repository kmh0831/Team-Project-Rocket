# modules/rds/outputs.tf

output "rds_db_instance_identifier" {
  value = aws_db_instance.rds.identifier
}

output "rds_db_name" {
  value = aws_db_instance.rds.db_name
}

output "db_private_subnet_ids" {
  value = var.db_private_subnet_ids  # VPC 모듈에서 전달된 값
}

output "db_route_table_ids" {
  value = var.db_route_table_ids  # VPC 모듈에서 전달된 값
}

output "vpc_id" {
  value = var.vpc_id  # VPC 모듈에서 전달된 VPC ID
}
