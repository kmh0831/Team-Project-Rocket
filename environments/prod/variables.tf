# environments/prod/variables.tf

variable "aws_region" {
  default = "ap-northeast-2"
}

variable "availability_zone_a" {
  default = "ap-northeast-2a"
}

variable "availability_zone_b" {
  default = "ap-northeast-2c"
}

variable "eks_vpc_cidr_block" {
  default = "172.16.0.0/16"
}

variable "db_vpc_cidr_block" {
  default = "192.168.0.0/16"
}

variable "eks_public_subnets" {
  default = ["172.16.1.0/24", "172.16.2.0/24", "172.16.7.0/24"]
}

variable "eks_private_subnets" {
  default = ["172.16.3.0/24", "172.16.4.0/24", "172.16.5.0/24"]
}

variable "db_private_subnets" {
  default = ["192.168.1.0/24", "192.168.2.0/24"]
}

variable "enable_dns_support" {
  default = true
}

variable "enable_dns_hostnames" {
  default = true
}

variable "route_cidr_block" {
  default = "0.0.0.0/0"
}

variable "nat_instance_private_ips" {
  default = ["172.16.1.100", "172.16.2.100"]
}

variable "bastion_instance_private_ip" {
  default = "172.16.7.100"
}

variable "nat_ami" {
  default = "ami-0c2d3e23e757b5d84"
}

variable "bastion_ami" {
  default = "ami-0c2d3e23e757b5d84"
}

variable "key_name" {
  default = "team_seoul"
}

variable "allowed_ssh_cidr" {
  default = "0.0.0.0/0"
}

variable "nat_instance_type" {
  default = "t3.micro"
}

variable "bastion_instance_type" {
  default = "t3.micro"
}

variable "cluster_name" {
  default = "rocket-eks-cluster"
}

variable "node_group_name" {
  default = "App-node-group"
}

variable "eks_instance_types" {
  default = ["t3.small"]
}

variable "eks_desired_size" {
  default = 2
}

variable "eks_max_size" {
  default = 4
}

variable "eks_min_size" {
  default = 2
}

variable "eks_role_arn" {
  default = "arn:aws:iam::your-account-id:role/eks-cluster-role"
}

variable "eks_node_role_arn" {
  default = "arn:aws:iam::your-account-id:role/eks-node-role"
}

variable "db_identifier" {
  default = "prod-db-instance"
}

variable "db_name" {
  default = "prod_db"
}

variable "db_engine" {
  default = "mysql"
}

variable "db_engine_version" {
  default = "8.0"
}

variable "db_instance_class" {
  default = "db.t3.micro"
}

variable "db_allocated_storage" {
  default = 20
}

variable "db_storage_type" {
  default = "gp2"
}

variable "db_multi_az" {
  default = false
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  default = "password!"
}

variable "peering_name" {
  default = "vpc-peering-eks-db"
}
