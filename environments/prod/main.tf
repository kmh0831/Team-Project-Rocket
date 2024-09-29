# environments/prod/main.tf

provider "aws" {
  region = var.aws_region
}

# VPC 모듈 호출
module "vpc" {
  source = "../../modules/vpc"

  vpc_config = {
    "EKS-vpc" = {
      cidr_block = var.eks_vpc_cidr_block
      availability_zones = [var.availability_zone_a, var.availability_zone_b]
      public_subnets = var.eks_public_subnets
      private_subnets = var.eks_private_subnets
    }
    "DB-vpc" = {
      cidr_block = var.db_vpc_cidr_block
      availability_zones = [var.availability_zone_a, var.availability_zone_b]
      public_subnets = []
      private_subnets = var.db_private_subnets
    }
  }
  
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  route_cidr_block     = var.route_cidr_block
}

# 보안 그룹 모듈 호출
module "security_groups" {
  source = "../../modules/security_groups"

  vpc_id         = module.vpc.vpc_ids["EKS-vpc"]
  vpc_cidr_block = var.eks_vpc_cidr_block
  db_vpc_id      = module.vpc.vpc_ids["DB-vpc"]
  allowed_ssh_cidr = var.allowed_ssh_cidr
  db_allowed_cidr  = var.eks_vpc_cidr_block  # RDS에서 접근 가능한 EKS CIDR
}

# NAT 인스턴스 모듈 호출
module "nat_instance" {
  source                  = "../../modules/nat"
  vpc_id                  = module.vpc.vpc_ids["EKS-vpc"]
  nat_subnet_ids          = module.vpc.public_subnet_ids["EKS-vpc"]
  nat_instance_private_ips = var.nat_instance_private_ips
  nat_ami                 = var.nat_ami
  nat_instance_type       = var.nat_instance_type
  key_name                = var.key_name
  security_group_id       = module.security_groups.nat_sg_id  # 보안 그룹 전달
}

# Bastion 호스트 모듈 호출
module "bastion_host" {
  source = "../../modules/bastion"
  vpc_id = module.vpc.vpc_ids["EKS-vpc"]
  bastion_subnet_id = element(module.vpc.public_subnet_ids["EKS-vpc"], 2)
  bastion_instance_private_ip = var.bastion_instance_private_ip
  bastion_ami = var.bastion_ami
  bastion_instance_type = var.bastion_instance_type
  key_name = var.key_name
  allowed_ssh_cidr = var.allowed_ssh_cidr
  security_group_id = module.security_groups.bastion_sg_id  # 보안 그룹 참조
}

# EKS 모듈 호출
module "eks" {
  source             = "../../modules/eks"
  vpc_id             = module.vpc.vpc_ids["EKS-vpc"]
  subnet_ids         = module.vpc.private_subnet_ids["EKS-vpc"]
  cluster_name       = var.cluster_name
  node_group_name    = var.node_group_name
  instance_types     = var.eks_instance_types
  desired_size       = var.eks_desired_size
  max_size           = var.eks_max_size
  min_size           = var.eks_min_size
  eks_role_arn       = var.eks_role_arn
  node_role_arn      = aws_iam_role.eks_node_role.arn  # IAM 역할 ARN 전달
  security_group_ids = [module.security_groups.eks_cluster_sg_id, module.security_groups.eks_node_sg_id]  # 보안 그룹 전달
}

# RDS 모듈 호출
module "rds" {
  source = "../../modules/rds"
  vpc_security_group_ids = [module.security_groups.rds_sg_id]  # 보안 그룹 참조
  subnet_ids = module.vpc.private_subnet_ids["DB-vpc"]
  db_identifier = var.db_identifier
  db_name = var.db_name
  engine = var.db_engine
  engine_version = var.db_engine_version
  instance_class = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  storage_type = var.db_storage_type
  multi_az = var.db_multi_az
  username = var.db_username
  password = var.db_password
}