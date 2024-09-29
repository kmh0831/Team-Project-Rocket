# modules/bastion/main.tf
resource "aws_instance" "bastion" {
  ami                    = var.bastion_ami
  instance_type          = var.bastion_instance_type
  subnet_id              = var.bastion_subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name

  # bastion_instance_private_ip가 있을 때만 IP를 할당
  private_ip = var.bastion_instance_private_ip != "" ? var.bastion_instance_private_ip : null

  tags = {
    Name = "Bastion-Host"
  }
}

# Bastion 호스트용 Elastic IP (EIP) 생성
resource "aws_eip" "bastion_eip" {
  domain = "vpc"

  tags = {
    Name = "Bastion-EIP"
  }
}

# EIP와 Bastion 인스턴스 연결
resource "aws_eip_association" "bastion_eip_assoc" {
  instance_id   = aws_instance.bastion.id
  allocation_id = aws_eip.bastion_eip.id
}
