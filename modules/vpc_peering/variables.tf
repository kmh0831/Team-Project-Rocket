# modules/vpc_peering/variables.tf

variable "vpc_id_a" {
  type = string
}

variable "vpc_id_b" {
  type = string
}

variable "peering_name" {
  type = string
}

variable "eks_vpc_cidr" {
  type = string
}

variable "db_vpc_cidr" {
  type = string
}

variable "eks_private_subnet_ids" {
  description = "List of private subnet IDs for the EKS VPC"
  type        = list(string)
}

variable "eks_route_table_ids" {
  description = "List of route table IDs for the EKS private subnets"
  type        = list(string)
}

variable "db_private_subnet_ids" {
  description = "List of private subnet IDs for the DB VPC"
  type        = list(string)
}

variable "db_route_table_ids" {
  description = "List of route table IDs for the DB private subnets"
  type        = list(string)
}