variable "vpc_id" {
  description = "The VPC ID for security groups"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "The CIDR block allowed for SSH access"
  type        = string
}

variable "db_allowed_cidr" {
  description = "CIDR block allowed for DB access"
  type        = string
}

variable "nat_security_group_ingress_cidr_blocks" {
  description = "CIDR blocks allowed for ingress traffic to NAT"
  type        = list(string)
}

variable "nat_security_group_egress_cidr_blocks" {
  description = "CIDR blocks allowed for egress traffic from NAT"
  type        = list(string)
}
