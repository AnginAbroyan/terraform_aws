#ECR
resource "aws_ecr_repository" "repository" {
  for_each = toset(var.ecr_repos)
  name = each.key
}


resource "null_resource" "docker_image" {
  for_each = toset(var.ecr_repos)
  name = "${aws_ecr_repository.repository[each.key].repository_url}:latest"

  provisioner "local-exec" {
    command = <<EOF
	    aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin
${data.aws_caller_identity.current.account_id}.dkr.ecr.eu-central-1.amazonaws.com
	    docker build -t "${aws_ecr_repository.repository[each.key].repository_url}:latest ${var.dockerfile_location}"
	    docker push "${aws_ecr_repository.repository[each.key].repository_url}:latest"
	    EOF
  }
}