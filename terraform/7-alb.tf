resource "aws_lb" "alb" {
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public_subnets[*].id
  tags               = merge(var.tags, { Name = "${var.project_name}-ALB" })
}