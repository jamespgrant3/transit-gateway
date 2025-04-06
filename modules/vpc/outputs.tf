output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_cidr" {
  value = aws_vpc.this.cidr_block
}

output "private_1a_subnet_id" {
  value = aws_subnet.private[var.private_vpc_subnet_cidrs[0]].id
}

output "private_1b_subnet_id" {
  value = aws_subnet.private[var.private_vpc_subnet_cidrs[1]].id
}

output "private_1c_subnet_id" {
  value = aws_subnet.private[var.private_vpc_subnet_cidrs[2]].id
}
