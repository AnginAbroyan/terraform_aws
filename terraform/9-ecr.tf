#ECR
resource "aws_ecr_repository" "repository" {
  for_each = toset(var.ecr_repos)
  name     = each.key
}


resource "null_resource" "docker_image" {
  for_each = toset(var.ecr_repos)

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOF
                docker login --username AWS --password-stdin  `aws ecr get-login-password --region eu-central-1`
                ${data.aws_caller_identity.current.account_id}.dkr.ecr.eu-central-1.amazonaws.com
	            docker build -t ${aws_ecr_repository.repository[each.key].repository_url}:latest ${var.dockerfile_location}
                docker push "${aws_ecr_repository.repository[each.key].repository_url}"
	    EOF
  }
  #    command = <<EOF
  #	    aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin
  #${data.aws_caller_identity.current.account_id}.dkr.ecr.eu-central-1.amazonaws.com
  #	    docker build -t ${aws_ecr_repository.repository[each.key].repository_url}:latest ${var.dockerfile_location}
  #	    docker push "${aws_ecr_repository.repository[each.key].repository_url}"
  #	    EOF
  #  }
  //    command = "docker images && docker build -t ${aws_ecr_repository.repo.repository_url}:v1
  //${path.module}/../../DOCKER/docker-sample-nginx/ && docker images && docker login --username
  //AWS --password `aws ecr get-login-password --region us-east-1` 1####99292.dkr.ecr.us-east-1.amazonaws.com
  //&& docker push ${aws_ecr_repository.repo.repository_url}:v1"

  triggers = {
    "run_at" = timestamp()
  }


  depends_on = [
    aws_ecr_repository.repository,
  ]
}