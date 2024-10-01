# modules/bastion/variables.tf

variable "vpc_id" {
  type = string
}

variable "bastion_subnet_id" {
  type = string
}

variable "bastion_instance_private_ip" {
  description = "Private IP for the Bastion host"
  type        = string
  default     = ""  # 기본값을 빈 문자열로 설정
}

variable "bastion_ami" {
  type = string
}

variable "bastion_instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "allowed_ssh_cidr" {
  type = string
}

# 보안 그룹 ID 변수를 정의합니다.
variable "security_group_id" {
  description = "The security group ID for the bastion host"
  type        = string
}