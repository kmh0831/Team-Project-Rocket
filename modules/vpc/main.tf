# modules/vpc/main.tf

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
  for_each = { for k, v in var.vpc_config : k => v.public_subnets }

  vpc_id            = aws_vpc.this[each.key].id
  cidr_block        = element(each.value, count.index)
  availability_zone = var.vpc_config[each.key].availability_zones[count.index]

  tags = {
    Name = "${each.key}-Public-Subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  for_each = { for k, v in var.vpc_config : k => v.private_subnets }

  vpc_id            = aws_vpc.this[each.key].id
  cidr_block        = element(each.value, count.index)
  availability_zone = var.vpc_config[each.key].availability_zones[count.index]

  tags = {
    Name = "${each.key}-Private-Subnet-${count.index + 1}"
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
