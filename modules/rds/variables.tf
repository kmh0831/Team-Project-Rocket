# modules/rds/variables.tf

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}

variable "db_identifier" {
  type = string
}

variable "db_name" {
  type = string
}

variable "engine" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "allocated_storage" {
  type = number
}

variable "storage_type" {
  type = string
}

variable "multi_az" {
  type = bool
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "skip_final_snapshot" {
  type    = bool
  default = true  # 기본적으로 최종 스냅샷을 건너뛰도록 설정
}

variable "final_snapshot_identifier" {
  type    = string
  default = null  # 기본값을 null로 설정하여 스냅샷 식별자 사용을 선택 사항으로 설정
}
