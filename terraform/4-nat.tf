resource "aws_eip" "nat_eip" {
  count = length(var.private_subnet_cidrs)
  domain = "vpc"
#  depends_on                = [aws_internet_gateway.this]
#  instance = element(aws_launch_template.this[*].id, count.index)
#  associate_with_private_ip = cidrhost(element(var.private_subnet_cidrs, count.index), 12)
  tags  = merge(var.tags, { Name = "${var.project_name}-nat-gtw-${count.index + 1}" })
}

resource "aws_nat_gateway" "nat_gtw" {
  count             = length(var.private_subnet_cidrs)
  depends_on = [aws_eip.nat_eip]
  allocation_id     = aws_eip.nat_eip[count.index].id
  subnet_id         = aws_subnet.public_subnets[count.index].id
  tags              = merge(var.tags, { Name = "${var.project_name}-nat-gtw-${count.index + 1}" })
}
