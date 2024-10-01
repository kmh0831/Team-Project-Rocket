variable "aws_region" {
  description = "AWS region"
}

variable "availability_zone_a" {
  description = "First availability zone"
}

variable "availability_zone_b" {
  description = "Second availability zone"
}

variable "eks_vpc_cidr_block" {
  description = "CIDR block for EKS VPC"
}

variable "db_vpc_cidr_block" {
  description = "CIDR block for DB VPC"
}

variable "eks_public_subnets" {
  description = "Public subnets for EKS VPC"
}

variable "eks_private_subnets" {
  description = "Private subnets for EKS VPC"
}

variable "db_private_subnets" {
  description = "Private subnets for DB VPC"
}

variable "enable_dns_support" {
  description = "Enable DNS support"
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames"
}

variable "route_cidr_block" {
  description = "Route CIDR block for internet gateway"
}

variable "nat_instance_private_ips" {
  description = "Private IPs for NAT instances"
}

variable "bastion_instance_private_ip" {
  description = "Private IP for Bastion host"
}

variable "nat_ami" {
  description = "AMI for NAT instances"
}

variable "bastion_ami" {
  description = "AMI for Bastion host"
}

variable "key_name" {
  description = "SSH key name"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed for SSH access"
}

variable "nat_instance_type" {
  description = "Instance type for NAT instances"
}

variable "bastion_instance_type" {
  description = "Instance type for Bastion host"
}

variable "cluster_name" {
  description = "EKS cluster name"
}

variable "node_group_name" {
  description = "EKS node group name"
}

variable "eks_instance_types" {
  description = "Instance types for EKS node group"
}

variable "eks_desired_size" {
  description = "Desired size for EKS node group"
}

variable "eks_max_size" {
  description = "Maximum size for EKS node group"
}

variable "eks_min_size" {
  description = "Minimum size for EKS node group"
}

variable "eks_role_arn" {
  description = "Role ARN for EKS cluster"
}

variable "eks_node_role_arn" {
  description = "Role ARN for EKS node"
}

variable "db_identifier" {
  description = "RDS DB instance identifier"
}

variable "db_name" {
  description = "RDS DB name"
}

variable "db_engine" {
  description = "RDS DB engine type"
}

variable "db_engine_version" {
  description = "RDS DB engine version"
}

variable "db_instance_class" {
  description = "RDS DB instance class"
}

variable "db_allocated_storage" {
  description = "Allocated storage for RDS DB"
}

variable "db_storage_type" {
  description = "Storage type for RDS DB"
}

variable "db_multi_az" {
  description = "Enable Multi-AZ for RDS"
}

variable "db_username" {
  description = "RDS DB username"
}

variable "db_password" {
  description = "RDS DB password"
}

variable "peering_name" {
  description = "VPC peering connection name"
}

variable "vpc_config" {
  description = "Configuration for VPCs"
  type = map(object({
    cidr_block           = string
    availability_zones   = list(string)
    public_subnets       = list(string)
    private_subnets      = list(string)
  }))
}

variable "nat_security_group_ingress_cidr_blocks" {
  description = "CIDR blocks allowed for ingress traffic in the NAT security group"
  type        = list(string)
}

variable "nat_security_group_egress_cidr_blocks" {
  description = "CIDR blocks allowed for egress traffic in the NAT security group"
  type        = list(string)
}

# List 형식으로 가용 영역 정의
variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}
