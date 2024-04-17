#
## VPC
#resource "aws_vpc" "my_vpc" {
#  cidr_block = "10.0.0.0/16"
#}
#
## Subnets
#resource "aws_subnet" "public_subnet_1" {
#  vpc_id            = aws_vpc.my_vpc.id
#  cidr_block        = "10.0.1.0/24"
#  availability_zone = "eu-central-1a"
#}
#
#resource "aws_subnet" "public_subnet_2" {
#  vpc_id            = aws_vpc.my_vpc.id
#  cidr_block        = "10.0.2.0/24"
#  availability_zone = "eu-central-1b"
#}
#
#resource "aws_subnet" "private_subnet_1" {
#  vpc_id            = aws_vpc.my_vpc.id
#  cidr_block        = "10.0.3.0/24"
#  availability_zone = "eu-central-1a"
#}
#
#resource "aws_subnet" "private_subnet_2" {
#  vpc_id            = aws_vpc.my_vpc.id
#  cidr_block        = "10.0.4.0/24"
#  availability_zone = "eu-central-1b"
#}
#
## Internet Gateway
#resource "aws_internet_gateway" "my_igw" {
#  vpc_id = aws_vpc.my_vpc.id
#}
#
## Route Table for Public Subnets
#resource "aws_route_table" "public_route_table" {
#  vpc_id = aws_vpc.my_vpc.id
#
#  route {
#    cidr_block = "0.0.0.0/0"
#    gateway_id = aws_internet_gateway.my_igw.id
#  }
#
#  tags = {
#    Name = "public"
#  }
#}
#
## Associate Public Subnets with Public Route Table
#resource "aws_route_table_association" "public_subnet_1_association" {
#  subnet_id      = aws_subnet.public_subnet_1.id
#  route_table_id = aws_route_table.public_route_table.id
#}
#
#resource "aws_route_table_association" "public_subnet_2_association" {
#  subnet_id      = aws_subnet.public_subnet_2.id
#  route_table_id = aws_route_table.public_route_table.id
#}
#
## NAT Gateway
#resource "aws_nat_gateway" "my_nat_gateway" {
#  allocation_id = aws_eip.my_eip.id
#  subnet_id     = aws_subnet.public_subnet_1.id  # Specify the subnet ID here
#}
#
#resource "aws_eip" "my_eip" {
#  domain = "vpc"
#  tags = {
#    Name = "my-eip"
#  }
#}
#
## Route Table for Private Subnets
#resource "aws_route_table" "private_route_table" {
#  vpc_id = aws_vpc.my_vpc.id
#
#  route {
#    cidr_block     = "0.0.0.0/0"
#    nat_gateway_id = aws_nat_gateway.my_nat_gateway.id
#  }
#
#  tags = {
#    Name = "private"
#  }
#}
#
## Associate Private Subnets with Private Route Table
#resource "aws_route_table_association" "private_subnet_1_association" {
#  subnet_id      = aws_subnet.private_subnet_1.id
#  route_table_id = aws_route_table.private_route_table.id
#}
#
#resource "aws_route_table_association" "private_subnet_2_association" {
#  subnet_id      = aws_subnet.private_subnet_2.id
#  route_table_id = aws_route_table.private_route_table.id
#}
#
## Security Group for ALB
#resource "aws_security_group" "alb_sg" {
#  vpc_id = aws_vpc.my_vpc.id
#
#  ingress {
#    from_port   = 80
#    to_port     = 80
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#}
#
## Application Load Balancer
#resource "aws_lb" "my_alb" {
#  name               = "my-alb"
#  internal           = false
#  load_balancer_type = "application"
#  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
#  security_groups    = [aws_security_group.alb_sg.id]
#}
#
## Target Group
#resource "aws_lb_target_group" "my_target_group" {
#  name     = "my-target-group"
#  port     = 3000
#  protocol = "HTTP"
#  vpc_id   = aws_vpc.my_vpc.id
#}
#
## Listener
#resource "aws_lb_listener" "my_listener" {
#  load_balancer_arn = aws_lb.my_alb.arn
#  port              = 80
#  protocol          = "HTTP"
#
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.my_target_group.arn
#  }
#}
#
## Auto Scaling Group
#resource "aws_launch_configuration" "my_launch_configuration" {
#  name                 = "my-launch-config"
#  image_id             = "ami-023adaba598e661ac"  # Ubuntu 22.04 LTS
#  instance_type        = "t2.micro"
#  security_groups      = [aws_security_group.alb_sg.id]
#  associate_public_ip_address = true
#
#  lifecycle {
#    create_before_destroy = true
#  }
#}
#
#resource "aws_autoscaling_group" "my_asg" {
#  depends_on            = [aws_launch_configuration.my_launch_configuration]
#  name                  = "my-asg"
#  launch_configuration  = aws_launch_configuration.my_launch_configuration.name
#  min_size              = 2
#  max_size              = 4
#  vpc_zone_identifier   = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
#  health_check_type     = "ELB"
#  target_group_arns     = [aws_lb_target_group.my_target_group.arn]
#
#  tag {
#    key                  = "Name"
#    value                = "my-instance"
#    propagate_at_launch  = true
#  }
#
#  tag {
#    key                  = "Environment"
#    value                = "production"
#    propagate_at_launch  = true
#  }
#}
