# modules/eks/variables.tf

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "cluster_name" {
  type = string
}

variable "node_group_name" {
  type = string
}

variable "instance_types" {
  type = list(string)
}

variable "desired_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "min_size" {
  type = number
}

variable "eks_role_arn" {
  type = string
}

variable "node_role_arn" {
  type = string
}

# EKS 클러스터에 사용할 보안 그룹 ID
variable "security_group_ids" {
  description = "List of security group IDs to associate with the EKS cluster"
  type        = list(string)
}

# EKS 클러스터에 사용할 서브넷 IDs
variable "cluster_subnet_ids" {
  description = "List of subnet IDs to associate with the EKS cluster"
  type        = list(string)
}

# EKS 노드 그룹에 사용할 서브넷 IDs
variable "node_subnet_ids" {
  description = "List of subnet IDs to associate with the EKS node group"
  type        = list(string)
}
