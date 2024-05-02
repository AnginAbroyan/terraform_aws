resource "aws_launch_template" "launch_template" {
  name                   = "${var.project_name}-tpl"
  image_id               = var.instance_ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.private_sg_id]
  key_name               = var.instance_keypair
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }
  user_data = filebase64("${path.module}/user-data.sh")
}


resource "aws_autoscaling_group" "autoscaling_group" {
  name                      = "${var.project_name}-asg"
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size
  desired_capacity          = var.asg_desired_capacity
  health_check_grace_period = 300
  health_check_type         = "ELB"
  target_group_arns         = [var.target_group_arn]
  termination_policies      = ["OldestInstance"]
  launch_template {
    id      = aws_launch_template.launch_template.id
    version = aws_launch_template.launch_template.latest_version
  }
  vpc_zone_identifier = var.private_subnet_id
}


resource "aws_autoscaling_policy" "cpu_scaling_policy" {
  name                      = "cpu-scaling-policy"
  policy_type               = "TargetTrackingScaling"
  adjustment_type           = "ChangeInCapacity"
  estimated_instance_warmup = 300
  autoscaling_group_name    = aws_autoscaling_group.autoscaling_group.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 80.0
  }
}


# scale up policy
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.project_name}-asg-scale-up"
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1" #increasing instance by 1
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}
# Scale down policy
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.project_name}-asg-scale-down"
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1" # decreasing instance by 1
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}



#Creating iam policy for instances to have access to ecr: pull images from there
resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-EC2-Role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "ecr_policy" {
  name        = "${var.project_name}-ECR-Policy"
  description = "IAM policy for accessing ECR"
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:BatchGetRepositoryScanningConfiguration",
          "ecr:CompleteLayerUpload",
          "ecr:CreatePullThroughCacheRule",
          "ecr:CreateRepository",
          "ecr:CreateRepositoryCreationTemplate",
          "ecr:DeleteLifecyclePolicy",
          "ecr:DeletePullThroughCacheRule",
          "ecr:DeleteRepository",
          "ecr:DeleteRepositoryCreationTemplate",
          "ecr:DescribeImageReplicationStatus",
          "ecr:DescribeImageScanFindings",
          "ecr:DescribeImages",
          "ecr:DescribePullThroughCacheRules",
          "ecr:DescribeRegistry",
          "ecr:DescribeRepositories",
          "ecr:DescribeRepositoryCreationTemplate",
          "ecr:GetAuthorizationToken",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetLifecyclePolicy",
          "ecr:GetLifecyclePolicyPreview",
          "ecr:GetRegistryPolicy",
          "ecr:GetRegistryScanningConfiguration",
          "ecr:GetRepositoryPolicy",
          "ecr:ListImages",
          "ecr:ListTagsForResource",
          "ecr:ReplicateImage",
          "ecr:SetRepositoryPolicy",
          "ecr:StartImageScan",
          "ecr:StartLifecyclePolicyPreview",
          "ecr:TagResource",
          "ecr:UntagResource",
          "ecr:UpdatePullThroughCacheRule",
          "ecr:UploadLayerPart",
          "cloudtrail:LookupEvents",
          "iam:CreateServiceLinkedRole"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_role_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ecr_policy.arn
}


resource "aws_iam_role_policy" "cloudtrail_role_policy" {
  name        = "${var.project_name}-CloudTrail-Policy"
  role        = aws_iam_role.ec2_role.name
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "cloudtrail:Read",
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role_policy" "iam_policy" {
  name        = "${var.project_name}-IAM-Policy"
  role        = aws_iam_role.ec2_role.name
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "iam:Write",
        "Resource": "*",
        "Condition": {
          "StringEquals": {
            "iam:AWSServiceName": "replication.ecr.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.project_name}-EC2-Instance-Profile"
  role = aws_iam_role.ec2_role.name
}
