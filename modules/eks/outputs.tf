# EKS 클러스터 이름 출력
output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.eks.name
}

# EKS 노드 그룹 이름 출력
output "eks_node_group_name" {
  description = "Name of the EKS node group"
  value       = aws_eks_node_group.eks_nodes.node_group_name
}

# EKS 클러스터 및 노드 그룹의 상태를 확인하는 출력값
output "eks_cluster_status" {
  description = "Status of the EKS cluster"
  value       = aws_eks_cluster.eks.status
}

output "eks_node_group_status" {
  description = "Status of the EKS node group"
  value       = aws_eks_node_group.eks_nodes.status
}
