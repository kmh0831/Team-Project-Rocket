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

variable "internet_gateway_id" {
  description = "ID of the existing Internet Gateway"
  type        = string
  default     = null  # 새로 만들지 않으면 null로 설정
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

# modules/vpc/variables.tf

variable "nat_instance_ids" {
  description = "NAT 인스턴스의 네트워크 인터페이스 ID 목록"
  type        = list(string)
}

# modules/vpc/variables.tf

variable "nat_instance_network_interface_ids" {
  description = "NAT 인스턴스의 네트워크 인터페이스 ID 목록"
  type        = list(string)
}

variable "bastion_primary_network_interface_id" {
  description = "Bastion 호스트의 주요 네트워크 인터페이스 ID"
  type        = string
}
