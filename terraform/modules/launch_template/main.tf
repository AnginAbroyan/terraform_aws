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
