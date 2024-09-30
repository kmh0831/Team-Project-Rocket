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

# Private NAT 라우팅 테이블 생성
resource "aws_route_table" "private_nat" {
  for_each = {
    "private_nat_1" = aws_subnet.private["EKS-vpc-Private-Subnet-1"]
    "private_nat_2" = aws_subnet.private["EKS-vpc-Private-Subnet-2"]
  }

  vpc_id = aws_vpc.this["EKS-vpc"].id

  route {
    cidr_block = "0.0.0.0/0"
    network_interface_id = element(var.nat_instance_network_interface_ids, each.key)
  }

  tags = {
    Name = "EKS-vpc-Private-RT-NAT-${each.key}"
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

# DB VPC에 대한 라우팅 테이블도 동일하게 추가
resource "aws_route_table" "db_private" {
  for_each = {
    "db_private_1" = aws_subnet.db_private["DB-vpc-Private-Subnet-1"]
    "db_private_2" = aws_subnet.db_private["DB-vpc-Private-Subnet-2"]
  }

  vpc_id = aws_vpc.this["DB-vpc"].id

  tags = {
    Name = "DB-vpc-Private-RT-${each.key}"
  }
}

resource "aws_route_table_association" "eks_private_subnet_nat" {
  for_each = {
    "EKS-vpc-Private-Subnet-1" = aws_subnet.private["EKS-vpc-Private-Subnet-1"]
    "EKS-vpc-Private-Subnet-2" = aws_subnet.private["EKS-vpc-Private-Subnet-2"]
    "EKS-vpc-Private-Subnet-3" = aws_subnet.private["EKS-vpc-Private-Subnet-3"]
  }

  subnet_id = each.value.id
  route_table_id = aws_route_table.private_nat.id
}

resource "aws_route_table_association" "eks_private_subnet_bastion" {
  subnet_id      = aws_subnet.private["EKS-vpc-Private-Subnet-3"].id
  route_table_id = aws_route_table.private_bastion.id
}