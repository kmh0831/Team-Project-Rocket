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
