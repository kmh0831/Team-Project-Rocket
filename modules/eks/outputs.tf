# EKS 클러스터 ARN 출력
output "eks_cluster_arn" {
  description = "EKS 클러스터 ARN"
  value       = aws_eks_cluster.eks.arn
}

# EKS 노드 그룹 ARN 출력
output "eks_node_group_arn" {
  description = "EKS 노드 그룹 ARN"
  value       = aws_eks_node_group.eks_nodes.arn
}

# EKS 클러스터 및 노드 그룹 상태 출력
output "eks_cluster_status" {
  description = "EKS 클러스터 상태"
  value       = aws_eks_cluster.eks.status
}

output "eks_node_group_status" {
  description = "EKS 노드 그룹 상태"
  value       = aws_eks_node_group.eks_nodes.status
}
