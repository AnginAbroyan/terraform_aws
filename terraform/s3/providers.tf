terraform {
  backend "s3" {
    bucket = "terraform-rs-bucket-brainscale-simple-app-anabroyan123456"
    dynamodb_table = "DynamoDB-table-state-locks123456"
    key = "global/mystatefile123456/terraform.tfstate"
    region = "eu-central-1"
    encrypt = true
  }
  required_version = ">= 1.5.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.9.0"
    }
  }
}