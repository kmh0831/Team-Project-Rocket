# modules/security_groups/main.tf

# NAT 인스턴스용 보안 그룹
resource "aws_security_group" "nat_sg" {
  name        = "nat-sg"
  description = "Security group for NAT instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr_block]
    description = "Allow all inbound traffic from VPC"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "Nat-SG"
  }
}

# Bastion 호스트용 보안 그룹
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Security group for Bastion Host"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
    description = "Allow SSH access from allowed CIDR"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "Bastion-SG"
  }
}

# EKS 클러스터용 보안 그룹
resource "aws_security_group" "eks_cluster_sg" {
  name        = "eks-cluster-sg"
  description = "Security group for EKS Cluster"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-cluster-sg"
  }
}

# EKS 노드 그룹용 보안 그룹
resource "aws_security_group" "eks_node_sg" {
  name        = "eks-node-sg"
  description = "Security group for EKS Node Group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-node-sg"
  }
}

# RDS용 보안 그룹
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Security group for RDS instances"
  vpc_id      = var.db_vpc_id

  ingress {
    from_port   = 3306  # MySQL 포트 (필요에 따라 조정)
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.db_allowed_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS-SG"
  }
}
