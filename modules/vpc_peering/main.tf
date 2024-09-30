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

# EKS에서 DB로 가는 라우트 추가
resource "aws_route" "eks_to_db" {
  for_each = module.vpc.eks_private_subnet_ids  # 프라이빗 서브넷 IDs 사용

  route_table_id            = aws_route_table.eks_private[each.key].id  # eks_private 라우트 테이블 사용
  destination_cidr_block    = var.db_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}
