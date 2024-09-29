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
  value       = [for subnet in aws_subnet.public : subnet.id if subnet.vpc_id == aws_vpc.this["EKS-vpc"].id]
}

# EKS 프라이빗 서브넷 ID들 출력
output "eks_private_subnet_ids" {
  description = "EKS Private Subnet IDs"
  value       = [for subnet in aws_subnet.private : subnet.id if subnet.vpc_id == aws_vpc.this["EKS-vpc"].id]
}

# DB 퍼블릭 서브넷 ID들 출력 (DB VPC에는 퍼블릭 서브넷이 없을 수 있으므로 필요시 추가)
# output "db_public_subnet_ids" {
#   description = "DB Public Subnet IDs"
#   value       = [for subnet in aws_subnet.public : subnet.id if subnet.vpc_id == aws_vpc.this["DB-vpc"].id]
# }

# DB 프라이빗 서브넷 ID들 출력
output "db_private_subnet_ids" {
  description = "DB Private Subnet IDs"
  value       = [for subnet in aws_subnet.private : subnet.id if subnet.vpc_id == aws_vpc.this["DB-vpc"].id]
}
