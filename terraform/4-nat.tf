resource "aws_eip" "nat_eip" {
  count = length(var.private_subnet_cidrs)
  tags  = merge(var.tags, { Name = "${var.project_name}-nat-gtw-${count.index + 1}" })
}

resource "aws_nat_gateway" "nat_gtw" {
  count         = length(var.private_subnet_cidrs)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id
  tags          = merge(var.tags, { Name = "${var.project_name}-nat-gtw-${count.index + 1}" })
}