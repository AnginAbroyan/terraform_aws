resource "aws_launch_template" "this" {
  depends_on             = [aws_eip.nat_eip]
  name                   = "${var.project_name}-tpl"
  image_id               = var.instance_ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.security_group_private.id]
  key_name               = var.instance_keypair
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }
  user_data = filebase64("${path.module}/user-data.sh")
}