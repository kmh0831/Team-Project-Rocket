# VPC Peering을 위한 라우트 설정
resource "aws_vpc_peering_connection" "peering" {
  vpc_id        = var.vpc_id_a
  peer_vpc_id   = var.vpc_id_b
  auto_accept   = true

  tags = {
    Name = var.peering_name
  }
}

# DB에서 EKS로 가는 라우트 추가
resource "aws_route" "db_to_eks" {
  for_each = var.db_route_table_ids

  route_table_id = each.value
  destination_cidr_block = var.eks_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}
