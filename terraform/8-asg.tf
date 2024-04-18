resource "aws_launch_configuration" "launch_configuration" {
  name = "launch_config"
  image_id             = var.instance_ami  # Ubuntu 22.04 LTS
  instance_type        = var.instance_type
  security_groups      = [aws_security_group.alb_sg.id]
  associate_public_ip_address = true
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "asg" {
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size
  desired_capacity          = var.asg_desired_capacity
  health_check_type         = "EC2"
  force_delete              = true
  launch_configuration      = aws_launch_configuration.launch_configuration.name
  vpc_zone_identifier       = aws_subnet.private_subnets[*].id
  termination_policies      = ["OldestInstance"]
  wait_for_capacity_timeout = "10m"
  tag {
    key                 = "Name"
    value               = "${var.project_name}-ASG"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = "Terraform_Brainscale"
    propagate_at_launch = true
  }
}