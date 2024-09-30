# modules/vpc/variables.tf

variable "vpc_config" {
  type = map(object({
    cidr_block           = string
    availability_zones   = list(string)
    public_subnets       = list(string)
    private_subnets      = list(string)
  }))
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "route_cidr_block" {
  type    = string
  default = "0.0.0.0/0"
}

variable "eks_vpc_cidr_block" {
  description = "CIDR block for the EKS VPC"
  type        = string
}

variable "db_vpc_cidr_block" {
  description = "CIDR block for the DB VPC"
  type        = string
}

# modules/vpc/variables.tf

variable "bastion_primary_network_interface_id" {
  description = "Bastion host primary network interface ID"
  type        = string
}
