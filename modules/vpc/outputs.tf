# EKS VPC ID 출력
output "eks_vpc_id" {
  description = "EKS VPC ID"
  value       = aws_vpc.this["EKS-vpc"].id
}

# DB VPC ID 출력
output "db_vpc_id" {
  description = "DB VPC ID"
  value       = aws_vpc.this["DB-vpc"].id
}

# EKS 퍼블릭 서브넷 ID들 출력
output "eks_public_subnet_ids" {
  description = "EKS Public Subnet IDs"
  value       = [for subnet in values(aws_subnet.public) : subnet.id]  # 올바르게 public 서브넷을 참조
}

# EKS 프라이빗 서브넷 ID들 출력
output "eks_private_subnet_ids" {
  description = "EKS Private Subnet IDs"
  value       = [for subnet in values(aws_subnet.private) : subnet.id]  # 올바르게 private 서브넷을 참조
}

output "db_private_subnet_ids" {
  description = "DB Private Subnet IDs"
  value       = [for subnet in aws_subnet.db_private : subnet.id]
}
