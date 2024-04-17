resource "aws_route_table" "public_subnet_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_gateway.id
  }
  tags = merge(var.tags, { Name = "${var.project_name}-route-table-public" })

}

resource "aws_route_table_association" "public_subnets" {
  count          = length(aws_subnet.public_subnets[*].id)
  route_table_id = aws_route_table.public_subnet_rt.id
  subnet_id      = aws_subnet.public_subnets[count.index].id
}


resource "aws_route_table" "private_subnets_rt" {
  count  = length((var.private_subnet_cidrs))
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gtw[count.index].id
  }
  tags = merge(var.tags, { Name = "${var.project_name}-route-table-private" })
}

resource "aws_route_table_association" "private_routes" {
  count          = length(aws_subnet.private_subnets)
  route_table_id = aws_route_table.private_subnets_rt[count.index].id
  subnet_id      = aws_subnet.private_subnets[count.index].id
}