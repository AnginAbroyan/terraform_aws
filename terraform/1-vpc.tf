resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  tags       = merge(var.tags, { Name = "${var.project_name}-VPC" })
}