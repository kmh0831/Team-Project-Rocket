# modules/eks/outputs.tf

output "eks_cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "eks_node_group_name" {
  value = aws_eks_node_group.eks_nodes.node_group_name
}
