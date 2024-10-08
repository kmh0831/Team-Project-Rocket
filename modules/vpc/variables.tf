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

variable "internet_gateway_id" {
  description = "ID of the existing Internet Gateway"
  type        = string
  default     = null
}

variable "public_subnet_cidr_blocks" {
  type = list(string)
}

variable "private_subnet_cidr_blocks" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "nat_instance_network_interface_ids" {
  description = "List of NAT instance network interface IDs"
  type        = list(string)
}

variable "bastion_primary_network_interface_id" {
  description = "Primary network interface ID of the Bastion host"
  type        = string
}
