output "vpc_id" {
  description = "Main VPC ID of the Project"
  value = aws_vpc.main_vpc.id
}

output "public_subnet_1_id" {
  description = "Public Subnet 1 ID"
  value = aws_subnet.public_subnets[0].id
}

output "public_subnet_2_id" {
  description = "Public Subnet 2 ID"
  value = aws_subnet.public_subnets[1].id
}

output "public_subnet_3_id" {
  description = "Public Subnet 3 ID"
  value = aws_subnet.public_subnets[2].id
}

output "private_subnet_1_id" {
  description = "Public Subnet 1 ID"
  value = aws_subnet.private_subnets[0].id
}

output "private_subnet_2_id" {
  description = "Public Subnet 1 ID"
  value = aws_subnet.private_subnets[1].id
}
