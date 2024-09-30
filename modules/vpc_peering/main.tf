resource "aws_vpc_peering_connection" "peering" {
  peer_vpc_id = var.vpc_id_b
  vpc_id      = var.vpc_id_a
  auto_accept = true

  tags = {
    Name = var.peering_name
  }
}

resource "aws_route" "vpc_a_to_b" {
  for_each = var.eks_private_subnet_ids
  route_table_id         = var.eks_route_table_ids[each.key]
  destination_cidr_block = var.db_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

resource "aws_route" "vpc_b_to_a" {
  for_each = var.db_private_subnet_ids
  route_table_id         = var.db_route_table_ids[each.key]
  destination_cidr_block = var.eks_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}
