# modules/security_groups/variables.tf

variable "vpc_id" {
  description = "The ID of the VPC where the resources will be deployed"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "db_vpc_id" {
  description = "The ID of the VPC for the RDS"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "The CIDR block allowed to access the Bastion host via SSH"
  type        = string
}

variable "db_allowed_cidr" {
  description = "The CIDR block allowed to access the RDS"
  type        = string
}
