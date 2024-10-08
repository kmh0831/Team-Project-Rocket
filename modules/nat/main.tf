# NAT 인스턴스 생성
resource "aws_instance" "nat" {
  count = length(var.nat_subnet_ids)

  ami                    = var.nat_ami
  instance_type          = var.nat_instance_type
  subnet_id              = element(var.nat_subnet_ids, count.index)
  vpc_security_group_ids = [var.security_group_id]
  source_dest_check      = false
  key_name               = var.key_name

  # nat_instance_private_ips가 비어있지 않을 경우에만 private_ip를 설정
  private_ip = length(var.nat_instance_private_ips) > 0 ? element(var.nat_instance_private_ips, count.index) : null

  tags = {
    Name = "NAT-${count.index + 1}"
  }
}

# NAT 인스턴스용 Elastic IP (EIP) 생성
resource "aws_eip" "nat_eip" {
  count  = length(var.nat_subnet_ids)
  domain = "vpc"
  instance = aws_instance.nat[count.index].id

  tags = {
    Name = "Nat-EIP-${count.index + 1}"
  }
}
