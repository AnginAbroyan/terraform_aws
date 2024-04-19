resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.current.names[count.index]
  tags                    = merge(var.tags, { Name = "${var.project_name}-public-subnets${count.index + 1}" })
}


resource "aws_subnet" "private_subnets" {
  vpc_id            = aws_vpc.main_vpc.id
#  map_public_ip_on_launch = true
  count             = length(var.private_subnet_cidrs)
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = data.aws_availability_zones.current.names[count.index]
  tags              = merge(var.tags, { Name = "${var.project_name}-private-subnets-${count.index + 1}" })
}

# Get current availability zones
data "aws_availability_zones" "current" {}