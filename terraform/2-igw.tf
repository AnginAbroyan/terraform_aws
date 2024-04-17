resource "aws_internet_gateway" "main_gateway" {
  vpc_id = aws_vpc.main_vpc.id
  tags   = merge(var.tags, { Name = "${var.project_name}-IGW" })
}