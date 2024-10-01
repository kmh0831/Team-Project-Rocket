resource "aws_vpc_peering_connection" "peering" {
  peer_vpc_id = var.vpc_id_b
  vpc_id      = var.vpc_id_a
  auto_accept = true

  tags = {
    Name = var.peering_name
  }
}

resource "aws_route" "eks_to_db" {
  for_each = toset(var.eks_private_route_table_ids)

  route_table_id             = each.value
  destination_cidr_block     = var.db_vpc_cidr
  vpc_peering_connection_id  = aws_vpc_peering_connection.peering.id
}

resource "aws_route" "db_to_eks" {
  for_each = toset(var.db_private_route_table_ids)

  route_table_id             = each.value
  destination_cidr_block     = var.eks_vpc_cidr
  vpc_peering_connection_id  = aws_vpc_peering_connection.peering.id
}
