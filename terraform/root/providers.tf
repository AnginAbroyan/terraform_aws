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
  backend "s3" {
    bucket = "terraform-rs-bucket-brainscale-simple-app-anabroyan"
    dynamodb_table = "DynamoDB-table-state-locks1"
    key = "global/mystatefile1/terraform.tfstate"
    region = "eu-central-1"
    encrypt = true
  }
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
