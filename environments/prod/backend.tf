# 백엔드 설정
terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-kmhyuk0831"
    key            = "terraform/terraform.tfstate"  # tfstate 파일 경로
    region         = "ap-northeast-2"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}