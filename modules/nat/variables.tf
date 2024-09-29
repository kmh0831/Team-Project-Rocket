# modules/nat/variables.tf

variable "vpc_id" {
  type = string
}

variable "nat_subnet_ids" {
  type = list(string)
}

variable "nat_instance_private_ips" {
  type = list(string)
}

variable "nat_ami" {
  type = string
}

variable "nat_instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "nat_security_group_ingress_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "nat_security_group_egress_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "security_group_id" {
  description = "The security group ID for the NAT instance"
  type        = string
}