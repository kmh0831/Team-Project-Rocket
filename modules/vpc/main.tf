# VPC 생성
resource "aws_vpc" "this" {
  for_each = var.vpc_config

  cidr_block           = each.value.cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name = each.key
  }
}

# Public Subnets 생성 (DB VPC는 제외)
resource "aws_subnet" "public" {
  for_each = { for i, cidr in var.vpc_config["EKS-vpc"].public_subnets : i => cidr }

  vpc_id            = aws_vpc.this["EKS-vpc"].id
  cidr_block        = each.value
  availability_zone = var.vpc_config["EKS-vpc"].availability_zones[each.key]

  tags = {
    Name = "EKS-vpc-Public-Subnet-${each.key + 1}"
  }
}

# Private Subnets 생성 (EKS VPC)
resource "aws_subnet" "private" {
  for_each = { for i, cidr in var.vpc_config["EKS-vpc"].private_subnets : i => cidr }

  vpc_id            = aws_vpc.this["EKS-vpc"].id
  cidr_block        = each.value
  availability_zone = var.vpc_config["EKS-vpc"].availability_zones[each.key]

  tags = {
    Name = "EKS-vpc-Private-Subnet-${each.key + 1}"
  }
}

# DB VPC Private Subnets 생성
resource "aws_subnet" "db_private" {
  for_each = { for i, cidr in var.vpc_config["DB-vpc"].private_subnets : i => cidr }

  vpc_id            = aws_vpc.this["DB-vpc"].id
  cidr_block        = each.value
  availability_zone = var.vpc_config["DB-vpc"].availability_zones[each.key]

  tags = {
    Name = "DB-vpc-Private-Subnet-${each.key + 1}"
  }
}

# Internet Gateway 생성
resource "aws_internet_gateway" "this" {
  for_each = aws_vpc.this

  vpc_id = each.value.id

  tags = {
    Name = "${each.key}-Internet-Gateway"
  }
}

# Public Route Table 생성
resource "aws_route_table" "public" {
  for_each = aws_vpc.this

  vpc_id = each.value.id

  route {
    cidr_block = var.route_cidr_block
    gateway_id = aws_internet_gateway.this[each.key].id
  }

  tags = {
    Name = "${each.key}-Public-RT"
  }
}

# Public Subnet Route Table Association
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public["EKS-vpc"].id
}

# Private Route Table 생성 (NAT 인스턴스와 연결)
resource "aws_route_table" "private_nat_1" {
  vpc_id = aws_vpc.this["EKS-vpc"].id

  route {
    cidr_block = "0.0.0.0/0"
    network_interface_id = var.nat_instance_network_interface_ids[0]  # NAT 인스턴스 1의 네트워크 인터페이스로 연결
  }

  tags = {
    Name = "EKS-vpc-Private-RT-NAT-1"
  }
}

resource "aws_route_table" "private_nat_2" {
  vpc_id = aws_vpc.this["EKS-vpc"].id

  route {
    cidr_block = "0.0.0.0/0"
    network_interface_id = var.nat_instance_network_interface_ids[1]
  }

  tags = {
    Name = "EKS-vpc-Private-RT-NAT-2"
  }
}

# Bastion 호스트 네트워크 인터페이스 ID 사용
resource "aws_route_table" "private_bastion" {
  vpc_id = aws_vpc.this["EKS-vpc"].id

  route {
    cidr_block = "0.0.0.0/0"
    network_interface_id = var.bastion_primary_network_interface_id
  }

  tags = {
    Name = "EKS-vpc-Private-RT-Bastion"
  }
}

# EKS 프라이빗 서브넷 A에서 DB 프라이빗 서브넷 A로 라우팅
resource "aws_route" "eks_to_db_a" {
  route_table_id         = aws_route_table.private_nat_1.id  # EKS 프라이빗 서브넷 A의 라우트 테이블 ID
  destination_cidr_block = var.db_vpc_cidr_block  # DB VPC의 CIDR 블록
  vpc_peering_connection_id = module.vpc_peering.vpc_peering_connection_id  # 피어링 연결 ID
}

# EKS 프라이빗 서브넷 B에서 DB 프라이빗 서브넷 B로 라우팅
resource "aws_route" "eks_to_db_b" {
  route_table_id         = aws_route_table.private_nat_2.id  # EKS 프라이빗 서브넷 B의 라우트 테이블 ID
  destination_cidr_block = var.db_vpc_cidr_block  # DB VPC의 CIDR 블록
  vpc_peering_connection_id = module.vpc_peering.vpc_peering_connection_id  # 피어링 연결 ID
}

# DB 프라이빗 서브넷 A에서 EKS 프라이빗 서브넷 A로 라우팅
resource "aws_route" "db_to_eks_a" {
  route_table_id         = aws_route_table.db_private[0].id  # DB 프라이빗 서브넷 A의 라우트 테이블 ID
  destination_cidr_block = var.eks_vpc_cidr_block  # EKS VPC의 CIDR 블록
  vpc_peering_connection_id = module.vpc_peering.vpc_peering_connection_id  # 피어링 연결 ID
}

# DB 프라이빗 서브넷 B에서 EKS 프라이빗 서브넷 B로 라우팅
resource "aws_route" "db_to_eks_b" {
  route_table_id         = aws_route_table.db_private[1].id  # DB 프라이빗 서브넷 B의 라우트 테이블 ID
  destination_cidr_block = var.eks_vpc_cidr_block  # EKS VPC의 CIDR 블록
  vpc_peering_connection_id = module.vpc_peering.vpc_peering_connection_id  # 피어링 연결 ID
}