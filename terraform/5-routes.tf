resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = merge(var.tags, { Name = "${var.project_name}-route-table-public" })

}

resource "aws_route_table_association" "public_route_assoc" {
  count          = length(aws_subnet.public_subnets[*].id)
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnets[count.index].id
}


resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.this.id
  count  = length((var.private_subnet_cidrs))
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gtw[count.index].id
  }
  tags = merge(var.tags, { Name = "${var.project_name}-route-table-private" })
}

resource "aws_route_table_association" "private_route_assoc" {
  count          = length(aws_subnet.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}