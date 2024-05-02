#Create VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(var.tags, { Name = "${var.project_name}-VPC" })
}

#Create public subnets
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.public_subnet_cidr, count.index)
  count                   = length(var.public_subnet_cidr)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.current.names[count.index]
  tags                    = merge(var.tags, { Name = "${var.project_name}-public-subnets${count.index + 1}" })
}

#Create private subnets
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.private_subnet_cidr, count.index)
  count             = length(var.private_subnet_cidr)
  availability_zone = data.aws_availability_zones.current.names[count.index]
  tags              = merge(var.tags, { Name = "${var.project_name}-private-subnets-${count.index + 1}" })
}

# Get current availability zones
data "aws_availability_zones" "current" {}

#Create internet gateway
resource "aws_internet_gateway" "internet_gtw" {
  depends_on = [aws_eip.nat_eip]
  vpc_id     = aws_vpc.vpc.id
  tags       = merge(var.tags, { Name = "${var.project_name}-IGW" })
}

#Create public route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gtw.id
  }
  tags = merge(var.tags, { Name = "${var.project_name}-route-table-public" })

}

#Create public route table association
resource "aws_route_table_association" "public_rt_assoc" {
  count          = length(aws_subnet.public_subnet[*].id)
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}

#Create private route table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  count  = length((var.private_subnet_cidr))
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gtw[count.index].id
  }
  tags = merge(var.tags, { Name = "${var.project_name}-route-table-private" })
}

#Create private route table association
resource "aws_route_table_association" "private_rt_assoc" {
  count          = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}

#Create elastic IP for NAT GW
resource "aws_eip" "nat_eip" {
  count  = length(var.private_subnet_cidr)
  domain = "vpc"
  tags   = merge(var.tags, { Name = "${var.project_name}-nat-gtw-${count.index + 1}" })
}


#Create NAT gateway
resource "aws_nat_gateway" "nat_gtw" {
  count         = length(var.private_subnet_cidr)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id
  tags          = merge(var.tags, { Name = "${var.project_name}-nat-gtw-${count.index + 1}" })
  depends_on    = [aws_internet_gateway.internet_gtw]
}
