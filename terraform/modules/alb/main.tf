#Create load balancer
resource "aws_lb" "alb" {
  load_balancer_type = "application"
  internal           = false
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_id

  idle_timeout       = 360
  tags               = merge(var.tags, { Name = "${var.project_name}-ALB" })
}

#Create Target group for alb
resource "aws_lb_target_group" "target_group" {
  name        = "target-group"
  port        = 3000
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

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

#Create listener to listen to 80 port
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}