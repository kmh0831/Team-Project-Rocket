# modules/rds/main.tf

resource "aws_db_instance" "rds" {
  identifier              = var.db_identifier
  db_name                 = var.db_name
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  storage_type            = var.storage_type
  multi_az                = var.multi_az
  username                = var.username
  password                = var.password
  vpc_security_group_ids  = var.vpc_security_group_ids
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet.name

  tags = {
    Name = var.db_identifier
  }
}

resource "aws_db_subnet_group" "rds_subnet" {
  name       = "${var.db_identifier}-subnet-group"
  subnet_ids = var.subnet_ids  # 여전히 모듈 호출 시 전달된 값 사용

  tags = {
    Name = "${var.db_identifier}-subnet-group"
  }
}
