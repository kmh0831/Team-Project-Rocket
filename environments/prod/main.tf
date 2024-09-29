provider "aws" {
  region = var.aws_region
}

# VPC 모듈 호출
module "vpc" {
  source = "../../modules/vpc"

  vpc_config = var.vpc_config  # var.vpc_config을 직접 참조하도록 수정
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  route_cidr_block     = var.route_cidr_block
}

# 보안 그룹 모듈 호출
module "security_groups" {
  source = "../../modules/security_groups"

  # EKS VPC 및 DB VPC ID 전달
  vpc_id         = module.vpc.eks_vpc_id       # EKS VPC ID
  db_vpc_id      = module.vpc.db_vpc_id        # DB VPC ID

  # CIDR 설정
  vpc_cidr_block     = var.eks_vpc_cidr_block
  db_allowed_cidr    = var.eks_vpc_cidr_block  # RDS 접근을 위한 CIDR

  # SSH 접근을 위한 허용 CIDR
  allowed_ssh_cidr = var.allowed_ssh_cidr

  # NAT 인스턴스 보안 그룹을 위한 Ingress 및 Egress CIDR
  nat_security_group_ingress_cidr_blocks = var.nat_security_group_ingress_cidr_blocks
  nat_security_group_egress_cidr_blocks  = var.nat_security_group_egress_cidr_blocks
}

# NAT 인스턴스 모듈 호출 시 서브넷을 VPC의 output 값으로 설정
module "nat_instance" {
  source                  = "../../modules/nat"
  vpc_id                  = module.vpc.eks_vpc_id
  nat_subnet_ids          = module.vpc.eks_public_subnet_ids
  nat_instance_private_ips = var.nat_instance_private_ips
  nat_ami                 = var.nat_ami
  nat_instance_type       = var.nat_instance_type
  key_name                = var.key_name
  security_group_id       = module.security_groups.nat_sg_id  # NAT 보안 그룹 전달
}

# Bastion 호스트 모듈 호출
module "bastion_host" {
  source                  = "../../modules/bastion"
  vpc_id                  = module.vpc.eks_vpc_id  # EKS VPC ID 참조
  bastion_subnet_id       = element(module.vpc.eks_public_subnet_ids, 2)  # EKS 퍼블릭 서브넷 중 하나 참조
  bastion_instance_private_ip = var.bastion_instance_private_ip
  bastion_ami             = var.bastion_ami
  bastion_instance_type   = var.bastion_instance_type
  key_name                = var.key_name
  allowed_ssh_cidr        = var.allowed_ssh_cidr
  security_group_id       = module.security_groups.bastion_sg_id  # 보안 그룹 참조
}

# EKS 모듈 호출
module "eks" {
  source             = "../../modules/eks"
  vpc_id             = module.vpc.eks_vpc_id
  subnet_ids         = module.vpc.eks_private_subnet_ids
  cluster_name       = var.cluster_name
  node_group_name    = var.node_group_name
  instance_types     = var.eks_instance_types
  desired_size       = var.eks_desired_size
  max_size           = var.eks_max_size
  min_size           = var.eks_min_size
  eks_role_arn       = var.eks_role_arn  # var에서 직접 참조
  node_role_arn      = var.eks_node_role_arn  # var에서 직접 참조
  security_group_ids = [module.security_groups.eks_cluster_sg_id, module.security_groups.eks_node_sg_id]
}

# RDS 모듈 호출
module "rds" {
  source = "../../modules/rds"
  vpc_security_group_ids = [module.security_groups.rds_sg_id]  # 보안 그룹 참조
  subnet_ids = module.vpc.db_private_subnet_ids  # DB VPC의 프라이빗 서브넷 참조
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
