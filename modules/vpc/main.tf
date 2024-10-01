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
  cidr_block        = each.value  # 각 Public 서브넷의 CIDR 블록
  availability_zone = var.vpc_config["EKS-vpc"].availability_zones[each.key]  # 각 서브넷에 해당하는 AZ

  tags = {
    Name = "EKS-vpc-Public-Subnet-${each.key + 1}"
  }
}

# Private Subnets 생성 (EKS VPC)
resource "aws_subnet" "private" {
  for_each = { for i, cidr in var.vpc_config["EKS-vpc"].private_subnets : i => cidr }

  vpc_id            = aws_vpc.this["EKS-vpc"].id
  cidr_block        = each.value  # 각 Private 서브넷의 CIDR 블록
  availability_zone = var.vpc_config["EKS-vpc"].availability_zones[each.key]  # 각 서브넷에 해당하는 AZ

  tags = {
    Name = "EKS-vpc-Private-Subnet-${each.key + 1}"
  }
}

# DB VPC Private Subnets 생성 (퍼블릭 서브넷 없음)
resource "aws_subnet" "db_private" {
  for_each = { for i, cidr in var.vpc_config["DB-vpc"].private_subnets : i => cidr }

  vpc_id            = aws_vpc.this["DB-vpc"].id
  cidr_block        = each.value  # 각 Private 서브넷의 CIDR 블록
  availability_zone = var.vpc_config["DB-vpc"].availability_zones[each.key]

  tags = {
    Name = "DB-vpc-Private-Subnet-${each.key + 1}"
  }
}

# Internet Gateway 생성 (DB 퍼블릭 서브넷 제외)
resource "aws_internet_gateway" "this" {
  for_each = aws_vpc.this

  vpc_id = each.value.id

  tags = {
    Name = "${each.key}-Internet-Gateway"
  }
}

# EKS VPC에만 Public Route Table 생성
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this["EKS-vpc"].id  # EKS VPC에만 적용

  route {
    cidr_block = var.route_cidr_block
    gateway_id = aws_internet_gateway.this["EKS-vpc"].id  # EKS VPC에 대한 인터넷 게이트웨이 참조
  }

  tags = {
    Name = "EKS-vpc-Public-RT"
  }
}

# Public 라우트 테이블 단일 참조로 수정
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# NAT 인스턴스를 위한 프라이빗 라우트 테이블 생성 및 라우트 설정
resource "aws_route_table" "private_nat_1" {
  vpc_id = aws_vpc.this["EKS-vpc"].id

  route {
    cidr_block = "0.0.0.0/0"
    network_interface_id = var.nat_instance_network_interface_ids[0]
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

# Bastion 호스트를 위한 프라이빗 라우트 테이블 생성 및 라우트 설정
resource "aws_route_table" "private_bastion" {
  vpc_id = aws_vpc.this["EKS-vpc"].id

  route {
    cidr_block = "0.0.0.0/0"
    network_interface_id = var.bastion_primary_network_interface_id
  }

  tags = {
    Name = "EKS-vpc-Private-RT-Bastion-Host"
  }
}

# EKS VPC의 프라이빗 서브넷과 라우트 테이블 연결
resource "aws_route_table_association" "private_nat_1_assoc" {
  subnet_id      = aws_subnet.private["0"].id
  route_table_id = aws_route_table.private_nat_1.id
}

resource "aws_route_table_association" "private_nat_2_assoc" {
  subnet_id      = aws_subnet.private["1"].id
  route_table_id = aws_route_table.private_nat_2.id
}

resource "aws_route_table_association" "private_bastion_assoc" {
  for_each = {
    for idx, subnet in aws_subnet.private :
    idx => subnet
    if idx == "2" || idx == "3"  # 서브넷 인덱스 2와 3에 연결
  }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_bastion.id
}


# DB VPC의 프라이빗 라우트 테이블 생성
resource "aws_route_table" "db_private" {
  for_each = aws_subnet.db_private

  vpc_id = aws_vpc.this["DB-vpc"].id

  tags = {
    Name = "DB-vpc-Private-RT-${each.key}"
  }
}

# 프라이빗 서브넷과 라우트 테이블 연결
resource "aws_route_table_association" "db_private_assoc" {
  for_each = aws_subnet.db_private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.db_private[each.key].id
}
