provider "aws" {
  region = var.aws_region
}

# VPC 모듈 호출
module "vpc" {
  source = "../../modules/vpc"

  vpc_config           = var.vpc_config
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  public_subnet_cidr_blocks  = var.eks_public_subnets
  private_subnet_cidr_blocks = var.eks_private_subnets
  availability_zones         = var.availability_zones

  route_cidr_block = var.route_cidr_block
  nat_instance_network_interface_ids = module.nat.nat_instance_network_interface_ids
  bastion_primary_network_interface_id = module.bastion.bastion_primary_network_interface_id
}

# 보안 그룹 모듈 호출
module "security_groups" {
  source = "../../modules/security_groups"

  vpc_id                     = module.vpc.eks_vpc_id
  allowed_ssh_cidr           = var.allowed_ssh_cidr
  db_allowed_cidr            = var.db_allowed_cidr
  nat_security_group_ingress_cidr_blocks = var.nat_security_group_ingress_cidr_blocks
  nat_security_group_egress_cidr_blocks  = var.nat_security_group_egress_cidr_blocks

  # 필요한 변수 다시 추가
  db_vpc_id       = module.vpc.db_vpc_id
  vpc_cidr_block  = var.eks_vpc_cidr_block
}

# NAT 모듈 호출
module "nat" {
  source = "../../modules/nat"
  vpc_id = module.vpc.eks_vpc_id

  # NAT 인스턴스를 생성할 서브넷 ID를 첫 두 개의 퍼블릭 서브넷으로 제한
  nat_subnet_ids = [
    module.vpc.eks_public_subnet_ids[0],
    module.vpc.eks_public_subnet_ids[1]
  ]

  nat_ami           = var.nat_ami
  nat_instance_type = var.nat_instance_type
  key_name          = var.key_name
  security_group_id = module.security_groups.nat_sg_id
}

# Bastion 모듈 호출
module "bastion" {
  source                    = "../../modules/bastion"
  vpc_id                    = module.vpc.eks_vpc_id
  bastion_subnet_id         = element(module.vpc.eks_public_subnet_ids, 2)
  bastion_instance_private_ip = var.bastion_instance_private_ip
  bastion_ami               = var.bastion_ami
  bastion_instance_type     = var.bastion_instance_type
  key_name                  = var.key_name
  allowed_ssh_cidr          = var.allowed_ssh_cidr
  security_group_id         = module.security_groups.bastion_sg_id
}

# EKS 모듈 호출
module "eks" {
  source             = "../../modules/eks"
  vpc_id             = module.vpc.eks_vpc_id

  cluster_subnet_ids = [element(module.vpc.eks_private_subnet_ids, 2), element(module.vpc.eks_private_subnet_ids, 3)]
  node_subnet_ids    = [element(module.vpc.eks_private_subnet_ids, 0), element(module.vpc.eks_private_subnet_ids, 1)]

  cluster_name       = var.cluster_name
  node_group_name    = var.node_group_name
  instance_types     = var.eks_instance_types
  desired_size       = var.eks_desired_size
  max_size           = var.eks_max_size
  min_size           = var.eks_min_size

  eks_role_arn       = var.eks_role_arn
  node_role_arn      = var.eks_node_role_arn
  security_group_ids = [module.security_groups.eks_cluster_sg_id, module.security_groups.eks_node_sg_id]
}

# RDS 모듈 호출
module "rds" {
  source = "../../modules/rds"

  vpc_security_group_ids = [module.security_groups.rds_sg_id]
  subnet_ids             = module.vpc.db_private_subnet_ids
  db_identifier          = var.db_identifier
  db_name                = var.db_name
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_allocated_storage
  storage_type           = var.db_storage_type
  multi_az               = var.db_multi_az
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = true
}

# VPC Peering 모듈 호출
module "vpc_peering" {
  source = "../../modules/vpc_peering"

  vpc_id_a     = module.vpc.eks_vpc_id
  vpc_id_b     = module.vpc.db_vpc_id
  peering_name = var.peering_name
  eks_vpc_cidr = var.eks_vpc_cidr_block
  db_vpc_cidr  = var.db_vpc_cidr_block

  eks_private_route_table_ids = module.vpc.eks_private_route_table_ids
  db_private_route_table_ids  = module.vpc.db_private_route_table_ids
}
