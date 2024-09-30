# modules/eks/outputs.tf

output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.eks.name
}

output "eks_node_group_name" {
  description = "Name of the EKS node group"
  value       = aws_eks_node_group.eks_nodes.node_group_name
}

output "eks_cluster_role_arn" {
  description = "ARN of the EKS cluster IAM role"
  value       = aws_iam_role.eks_cluster_role.arn
}

output "eks_node_role_arn" {
  description = "ARN of the EKS node IAM role"
  value       = aws_iam_role.eks_node_role.arn
}

output "private_subnet_ids" {
  value = var.eks_private_subnet_ids  # VPC 모듈에서 전달된 값
}

output "route_table_ids" {
  value = var.eks_route_table_ids  # VPC 모듈에서 전달된 값
}

output "vpc_id" {
  value = var.vpc_id  # VPC 모듈에서 전달된 VPC ID
}
