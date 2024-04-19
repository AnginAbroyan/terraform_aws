#resource "aws_iam_role" "ec2_role" {
#  name = "${var.project_name}-EC2-Role"
#  assume_role_policy = jsonencode({
#    "Version" : "2012-10-17",
#    "Statement": [
#      {
#        "Effect": "Allow",
#        "Principal": {
#          "Service": "ec2.amazonaws.com"
#        },
#        "Action": "sts:AssumeRole"
#      }
#    ]
#  })
#}
#
#
#resource "aws_iam_policy" "ecr_policy" {
#  name        = "${var.project_name}-ECR-Policy"
#  description = "IAM policy for accessing ECR"
#  policy      = jsonencode({
#    "Version": "2012-10-17",
#    "Statement": [
#      {
#        "Effect": "Allow",
#        "Action": [
#          "ecr:GetAuthorizationToken",
#          "ecr:BatchCheckLayerAvailability",
#          "ecr:GetDownloadUrlForLayer",
#          "ecr:GetRepositoryPolicy",
#          "ecr:DescribeRepositories",
#          "ecr:ListImages",
#          "ecr:DescribeImages",
#          "ecr:BatchGetImage"
#        ],
#        "Resource": "*"
#      }
#    ]
#  })
#}
#
#resource "aws_iam_role_policy_attachment" "ec2_role_policy_attachment" {
#  role       = aws_iam_role.ec2_role.name
#  policy_arn = aws_iam_policy.ecr_policy.arn
#}
#
#resource "aws_iam_instance_profile" "ec2_instance_profile" {
#  name = "${var.project_name}-EC2-Instance-Profile"
#  role = aws_iam_role.ec2_role.name
#}

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
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchGetImage"
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
