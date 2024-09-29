aws_region                 = "ap-northeast-2"
availability_zone_a         = "ap-northeast-2a"
availability_zone_b         = "ap-northeast-2c"
eks_vpc_cidr_block          = "172.16.0.0/16"
db_vpc_cidr_block           = "192.168.0.0/16"
eks_public_subnets          = ["172.16.1.0/24", "172.16.2.0/24", "172.16.7.0/24"]
eks_private_subnets         = ["172.16.3.0/24", "172.16.4.0/24", "172.16.5.0/24"]
db_private_subnets          = ["192.168.1.0/24", "192.168.2.0/24"]
enable_dns_support          = true
enable_dns_hostnames        = true
route_cidr_block            = "0.0.0.0/0"
nat_instance_private_ips    = []  # 서브넷 범위 내의 IP로 수정
bastion_instance_private_ip = ""  # 서브넷 범위 내의 IP로 수정
nat_ami                     = "ami-0c2d3e23e757b5d84"
bastion_ami                 = "ami-0c2d3e23e757b5d84"
key_name                    = "team_seoul"
allowed_ssh_cidr            = "0.0.0.0/0"
nat_instance_type           = "t3.micro"
bastion_instance_type       = "t3.micro"
cluster_name                = "rocket-eks-cluster"
node_group_name             = "App-node-group"
eks_instance_types          = ["t3.small"]
eks_desired_size            = 2
eks_max_size                = 4
eks_min_size                = 2
eks_role_arn                = "arn:aws:iam::your-account-id:role/eks-cluster-role"
eks_node_role_arn           = "arn:aws:iam::your-account-id:role/eks-node-role"
db_identifier               = "prod-db-instance"
db_name                     = "prod_db"
db_engine                   = "mysql"
db_engine_version           = "8.0"
db_instance_class           = "db.t3.micro"
db_allocated_storage        = 20
db_storage_type             = "gp2"
db_multi_az                 = false
db_username                 = "admin"
db_password                 = "password!"
peering_name                = "vpc-peering-eks-db"

# 추가된 vpc_config 설정
vpc_config = {
  "EKS-vpc" = {
    cidr_block         = "172.16.0.0/16"
    public_subnets     = ["172.16.1.0/24", "172.16.2.0/24", "172.16.7.0/24"]
    private_subnets    = ["172.16.3.0/24", "172.16.4.0/24", "172.16.5.0/24"]
    availability_zones = ["ap-northeast-2a", "ap-northeast-2c", "ap-northeast-2b"]  # 가용 영역 3개로 맞춤 
  },
  "DB-vpc" = {
    cidr_block         = "192.168.0.0/16"
    public_subnets     = []  # DB VPC에는 퍼블릭 서브넷이 없다고 가정
    private_subnets    = ["192.168.1.0/24", "192.168.2.0/24"]
    availability_zones = ["ap-northeast-2a", "ap-northeast-2c"]  # 여기는 그대로
  }
}

# NAT 보안 그룹 설정
nat_security_group_ingress_cidr_blocks = ["0.0.0.0/0"]
nat_security_group_egress_cidr_blocks  = ["0.0.0.0/0"]
