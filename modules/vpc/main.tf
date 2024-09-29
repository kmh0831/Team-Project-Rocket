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

# Private Route Table 생성 (각 프라이빗 서브넷이 NAT 인스턴스와 연결)
resource "aws_route_table" "private_nat_1" {
  vpc_id = aws_vpc.this["EKS-vpc"].id

  route {
    cidr_block = "0.0.0.0/0"
    network_interface_id = module.nat.nat_instance_ids[0]  # NAT 인스턴스 1에 연결
  }

  tags = {
    Name = "EKS-vpc-Private-RT-NAT-1"
  }
}

resource "aws_route_table" "private_nat_2" {
  vpc_id = aws_vpc.this["EKS-vpc"].id

  route {
    cidr_block = "0.0.0.0/0"
    network_interface_id = module.nat.nat_instance_ids[1]  # NAT 인스턴스 2에 연결
  }

  tags = {
    Name = "EKS-vpc-Private-RT-NAT-2"
  }
}

# Bastion 호스트 라우팅 설정 (EKS 프라이빗 서브넷 3에 연결, NAT 역할)
resource "aws_route_table" "private_bastion" {
  vpc_id = aws_vpc.this["EKS-vpc"].id

  route {
    cidr_block = "0.0.0.0/0"
    network_interface_id = aws_instance.bastion.id  # Bastion 호스트를 NAT 역할로 설정
  }

  tags = {
    Name = "EKS-vpc-Private-RT-Bastion"
  }
}

# Private Subnet Route Table Association (각 프라이빗 서브넷에 맞는 라우팅 테이블 연결)
resource "aws_route_table_association" "private_nat_1_assoc" {
  subnet_id      = aws_subnet.private[0].id
  route_table_id = aws_route_table.private_nat_1.id
}

resource "aws_route_table_association" "private_nat_2_assoc" {
  subnet_id      = aws_subnet.private[1].id
  route_table_id = aws_route_table.private_nat_2.id
}

resource "aws_route_table_association" "private_bastion_assoc" {
  subnet_id      = aws_subnet.private[2].id
  route_table_id = aws_route_table.private_bastion.id
}
