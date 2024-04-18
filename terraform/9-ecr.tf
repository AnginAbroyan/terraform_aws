#ECR
resource "aws_ecr_repository" "repository" {
  for_each = toset(var.ecr_repos)
  name = each.key
}


resource "docker_registry_image" "docker_image" {
  for_each = toset(var.ecr_repos)
  name = "${aws_ecr_repository.repository[each.key].repository_url}:latest"

  build {
    context = var.path
    dockerfile = "Dockerfile"
  }
}