#ECR
resource "aws_ecr_repository" "repository" {
  for_each = toset(var.ecr_repos)
  name     = each.key
  force_delete = true
}



