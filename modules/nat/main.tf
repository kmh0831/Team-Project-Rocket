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

resource "aws_instance" "nat" {
  for_each              = { for idx, subnet_id in var.nat_subnet_ids : idx => subnet_id }
  ami                   = var.nat_ami
  instance_type         = var.nat_instance_type
  subnet_id             = each.value
  private_ip            = var.nat_instance_private_ips[each.key]
  vpc_security_group_ids = [aws_security_group.nat_sg.id]
  source_dest_check     = false
  key_name              = var.key_name

  tags = {
    Name = "NAT-${each.key + 1}"
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