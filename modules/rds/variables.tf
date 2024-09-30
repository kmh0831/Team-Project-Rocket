# modules/rds/variables.tf

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}

variable "db_identifier" {
  type = string
}

variable "db_name" {
  type = string
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "allocated_storage" {
  type = number
}

variable "storage_type" {
  type = string
}

variable "multi_az" {
  type = bool
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "skip_final_snapshot" {
  type    = bool
}

variable "final_snapshot_identifier" {
  type    = string
}

variable "db_private_subnet_ids" {
  description = "List of private subnet IDs for the RDS instance"
  type        = list(string)
}

variable "db_route_table_ids" {
  description = "List of route table IDs for the DB subnets"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID where the RDS instance is deployed"
  type        = string
}
