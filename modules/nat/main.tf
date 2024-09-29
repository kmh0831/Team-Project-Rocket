# NAT Security Group
resource "aws_security_group" "nat_sg" {
  name        = "NAT-SG"
  vpc_id      = var.vpc_id
  description = "Allow traffic to NAT instances"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.nat_security_group_ingress_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.nat_security_group_egress_cidr_blocks
  }

  tags = {
    Name = "NAT-SG"
  }
}

# NAT Instances
resource "aws_instance" "nat" {
  count                  = length(var.nat_subnet_ids)
  ami                    = var.nat_ami
  instance_type          = var.nat_instance_type
  subnet_id              = element(var.nat_subnet_ids, count.index)
  private_ip             = element(var.nat_instance_private_ips, count.index)
  vpc_security_group_ids = [aws_security_group.nat_sg.id]  # 보안 그룹을 aws_security_group 리소스에서 참조
  source_dest_check      = false
  key_name               = var.key_name

  tags = {
    Name = "NAT-${count.index + 1}"
  }
}

# Elastic IP for NAT
resource "aws_eip" "nat_eip" {
  count  = length(aws_instance.nat)  # 인스턴스의 개수만큼 EIP 생성
  domain = "vpc"

  tags = {
    Name = "Nat-EIP-${count.index + 1}"
  }
}

# Associate EIP with NAT instance
resource "aws_eip_association" "nat_eip_assoc" {
  count        = length(aws_instance.nat)
  instance_id  = aws_instance.nat[count.index].id
  allocation_id = aws_eip.nat_eip[count.index].id  # EIP와 NAT 인스턴스를 연동
}
