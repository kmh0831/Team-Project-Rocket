# modules/security_groups/variables.tf

variable "vpc_id" {
  description = "The ID of the VPC where the resources will be deployed"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = null  # 기본값을 null로 설정하여 선택적인 변수로 만듭니다.
}

variable "db_vpc_id" {
  description = "The ID of the VPC for the RDS"
  type        = string
  default     = null  # 기본값을 null로 설정하여 선택적인 변수로 만듭니다.
}

variable "allowed_ssh_cidr" {
  description = "The CIDR block allowed to access the Bastion host via SSH"
  type        = string
}

variable "db_allowed_cidr" {
  description = "The CIDR block allowed to access the RDS"
  type        = string
}

variable "nat_security_group_ingress_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "nat_security_group_egress_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}
