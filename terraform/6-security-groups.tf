resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.project_name}-ALB-SG" })
}


resource "aws_security_group" "asg_sg" {
  description = "Security group for ASG instances"

  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port          = 3000
    to_port            = 3000
    protocol           = "tcp"
    security_groups    = [aws_security_group.alb_sg.id]
  }

  // Example rule to allow outbound traffic to the internet
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.project_name}-ASG-SG" })
}