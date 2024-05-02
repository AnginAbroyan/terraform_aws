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
    bucket = "terraform-rs-bucket-brainscale-simple-app-anabr"
    dynamodb_table = "DynamoDB-table-state-locks"
    key = "global/mystatefile/terraform.tfstate"
    region = var.region
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
