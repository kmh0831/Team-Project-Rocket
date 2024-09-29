resource "aws_vpc" "this" {
  for_each = var.vpc_config

  cidr_block           = each.value.cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name = each.key
  }
}

resource "aws_subnet" "public" {
  for_each = {
    for vpc_name, vpc_data in var.vpc_config : vpc_name => zipmap(vpc_data.availability_zones, vpc_data.public_subnets)
    if length(vpc_data.public_subnets) > 0
  }

  vpc_id            = aws_vpc.this[each.key].id
  cidr_block        = each.value[each.key]  # 각 가용 영역에 맞는 서브넷을 사용
  availability_zone = each.key              # 각 가용 영역을 분산

  tags = {
    Name = "${each.key}-Public-Subnet"
  }
}

resource "aws_subnet" "private" {
  for_each = {
    for vpc_name, vpc_data in var.vpc_config : vpc_name => zipmap(vpc_data.availability_zones, vpc_data.private_subnets)
    if length(vpc_data.private_subnets) > 0
  }

  vpc_id            = aws_vpc.this[each.key].id
  cidr_block        = each.value[each.key]  # 각 가용 영역에 맞는 서브넷을 사용
  availability_zone = each.key              # 각 가용 영역을 분산

  tags = {
    Name = "${each.key}-Private-Subnet"
  }
}

resource "aws_internet_gateway" "this" {
  for_each = aws_vpc.this

  vpc_id = each.value.id

  tags = {
    Name = "${each.key}-Internet-Gateway"
  }
}

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

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public[each.key].id
}
