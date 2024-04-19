resource "aws_subnet" "public_subnets" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  count                   = length(var.public_subnet_cidrs)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.current.names[count.index]
  tags                    = merge(var.tags, { Name = "${var.project_name}-public-subnets${count.index + 1}" })
}


resource "aws_subnet" "private_subnets" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  count             = length(var.private_subnet_cidrs)
  availability_zone = data.aws_availability_zones.current.names[count.index]
  tags              = merge(var.tags, { Name = "${var.project_name}-private-subnets-${count.index + 1}" })
}

# Get current availability zones
data "aws_availability_zones" "current" {}