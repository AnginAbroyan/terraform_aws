resource "aws_lb" "alb" {
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public_subnets[*].id
  tags               = merge(var.tags, { Name = "${var.project_name}-ALB" })
}

##TODO
resource "aws_lb_target_group" "target_group" {
  name     = "target-group"
  port     = 3000
  protocol = "HTTP"
  target_type = "instance"

  health_check {
    path                = "/login"
    protocol            = "HTTP"
    port                = 3000
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }
}

##TODO
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}