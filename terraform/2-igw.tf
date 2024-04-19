resource "aws_internet_gateway" "this" {
  depends_on = [aws_eip.nat_eip]
  vpc_id     = aws_vpc.this.id
  tags       = merge(var.tags, { Name = "${var.project_name}-IGW" })
}