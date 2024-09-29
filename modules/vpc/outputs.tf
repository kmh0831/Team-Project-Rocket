# modules/vpc/outputs.tf

output "vpc_ids" {
  value = aws_vpc.this
}

output "public_subnet_ids" {
  value = aws_subnet.public
}

output "private_subnet_ids" {
  value = aws_subnet.private
}
