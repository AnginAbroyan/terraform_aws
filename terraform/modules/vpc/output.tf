output "region" {
  value = var.region
}

output "project_name" {
  value = var.project_name
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnet" {
  value = aws_subnet.private_subnet[*].id
}

output "igw_id" {
  value = aws_internet_gateway.internet_gtw
}