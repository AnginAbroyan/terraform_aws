#resource "aws_launch_configuration" "launch_configuration" {
#  name                        = "launch_config"
#  image_id                    = var.instance_ami  # Ubuntu 22.04 LTS
#  instance_type               = var.instance_type
#  security_groups             = [aws_security_group.alb_sg.id]
#  associate_public_ip_address = false
#  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.name
#  lifecycle {
#    create_before_destroy = true
#  }
#  root_block_device {
#    volume_type = "gp2"
#    volume_size = 8
#    delete_on_termination = true
#  }
#}

resource "aws_launch_template" "launch_template" {
  name                   = "launch-template"
  description            = "My Launch template"
  image_id               = var.instance_ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.asg_sg.id]
  key_name               = var.instance_keypair
  user_data              = filebase64("${path.module}/user-data.sh")
  ebs_optimized          = true
  update_default_version = true
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }

#  block_device_mappings {
#    ebs {
#      volume_size           = 8
#      delete_on_termination = true
#      volume_type           = "gp2"
#    }
#  }
#  tag_specifications {
#    resource_type = "instance"
#    tags          = {
#      Name = "test"
#    }
#  }
}


resource "aws_autoscaling_group" "asg" {
  max_size          = var.asg_max_size
  min_size          = var.asg_min_size
  desired_capacity  = var.asg_desired_capacity
  health_check_type = "EC2"
  target_group_arns = [aws_lb_target_group.target_group.arn]
  force_delete      = true
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
#    version = aws_launch_template.launch_template.latest_version
  }
  vpc_zone_identifier       = aws_subnet.private_subnets[*].id
  termination_policies      = ["OldestInstance"]
#  wait_for_capacity_timeout = "10m"
  tag {
    key                 = "Name"
    value               = "${var.project_name}-ASG"
    propagate_at_launch = true
  }

#  tag {
#    key                 = "Project"
#    value               = "Terraform_Brainscale"
#    propagate_at_launch = true
#  }
}

##TODO
#resource "aws_autoscaling_policy" "cpu_scaling_policy" {
#  name                      = "cpu-scaling-policy"
#  policy_type               = "TargetTrackingScaling"
#  adjustment_type           = "ChangeInCapacity"
#  estimated_instance_warmup = 300
#  autoscaling_group_name    = aws_autoscaling_group.asg.name
#
#  target_tracking_configuration {
#    predefined_metric_specification {
#      predefined_metric_type = "ASGAverageCPUUtilization"
#    }
#    target_value = 80.0
#  }
#}