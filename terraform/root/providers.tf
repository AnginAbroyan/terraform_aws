provider "aws" {
  region = var.region
}

provider "docker" {
  registry_auth {
    address = local.aws_ecr_url
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}

terraform {
  required_version = ">= 1.5.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.9.0"
    }
    docker = {
      source = "kreuzwerker/docker"
      version = "2.15.0"
    }
  }
}
