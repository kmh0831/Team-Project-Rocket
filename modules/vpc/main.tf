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

# Public Subnets 생성
resource "aws_subnet" "public" {
  for_each = { for i, cidr in var.vpc_config["EKS-vpc"].public_subnets : i => cidr }

  vpc_id            = aws_vpc.this["EKS-vpc"].id
  cidr_block        = each.value  # 각 Public 서브넷의 CIDR 블록
  availability_zone = var.vpc_config["EKS-vpc"].availability_zones[each.key]  # 각 서브넷에 해당하는 AZ

  tags = {
    Name = "EKS-vpc-Public-Subnet-${each.key + 1}"
  }
}

# Private Subnets 생성
resource "aws_subnet" "private" {
  for_each = { for i, cidr in var.vpc_config["EKS-vpc"].private_subnets : i => cidr }

  vpc_id            = aws_vpc.this["EKS-vpc"].id
  cidr_block        = each.value  # 각 Private 서브넷의 CIDR 블록
  availability_zone = var.vpc_config["EKS-vpc"].availability_zones[each.key]  # 각 서브넷에 해당하는 AZ

  tags = {
    Name = "EKS-vpc-Private-Subnet-${each.key + 1}"
  }
}

# DB VPC Subnets 생성 (Public 없음)
resource "aws_subnet" "db_private" {
  for_each = { for i, cidr in var.vpc_config["DB-vpc"].private_subnets : i => cidr }

  vpc_id            = aws_vpc.this["DB-vpc"].id
  cidr_block        = each.value  # 각 Private 서브넷의 CIDR 블록
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
  route_table_id = aws_route_table.public["EKS-vpc"].id  # EKS VPC에 대해 Public Route Table과 연결
}
