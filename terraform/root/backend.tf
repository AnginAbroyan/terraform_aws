#S3 Bucket
resource "aws_s3_bucket" "terraform_remote_state" {
  bucket = "terraform_rs_bucket-brainscale-simple-app-anabr"
  tags   = merge(var.tags, { Name = "${var.project_name}-State-Bucket" })
}

#Versioning
resource "aws_s3_bucket_versioning" "versioning_rs" {
  bucket = aws_s3_bucket.terraform_remote_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

#Encryption aws:kms
resource "aws_kms_key" "my_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt_config" {
  bucket = aws_s3_bucket.terraform_remote_state.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.my_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# Create DynamoDB table for state locks
resource "aws_dynamodb_table" "terraform_state_locks" {
  name         = "DynamoDB-table-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = merge(var.tags, { Name = "${var.project_name}-State-Locks" })
}
