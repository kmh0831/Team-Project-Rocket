# modules/nat/main.tf

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

# modules/nat/main.tf

resource "aws_instance" "nat" {
  count                  = length(var.nat_subnet_ids)
  ami                    = var.nat_ami
  instance_type          = var.nat_instance_type
  subnet_id              = element(var.nat_subnet_ids, count.index)
  private_ip             = element(var.nat_instance_private_ips, count.index)
  vpc_security_group_ids = [var.security_group_id]  # 보안 그룹을 리스트 형태로 전달
  source_dest_check      = false
  key_name               = var.key_name

  tags = {
    Name = "NAT-${count.index + 1}"
  }
}

resource "aws_eip" "nat_eip" {
  for_each = aws_instance.nat

  domain = "vpc"

  tags = {
    Name = "Nat-EIP-${each.key + 1}"
  }
}

resource "aws_eip_association" "nat_eip_assoc" {
  for_each     = aws_instance.nat
  instance_id  = each.value.id
  allocation_id = aws_eip.nat_eip[each.key].id
}
