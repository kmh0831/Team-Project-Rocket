# modules/vpc_peering/main.tf

resource "aws_vpc_peering_connection" "peering" {
  peer_vpc_id = var.vpc_id_b
  vpc_id      = var.vpc_id_a
  auto_accept = true

  tags = {
    Name = var.peering_name
  }
}

resource "aws_route" "vpc_a_to_b" {
  for_each = aws_subnet.private
  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = var.db_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

resource "aws_route" "vpc_b_to_a" {
  for_each = aws_subnet.db_private
  route_table_id         = aws_route_table.db_private[each.key].id
  destination_cidr_block = var.eks_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}
