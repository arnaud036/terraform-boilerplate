# S3 Bucket

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.tfstate_bucket
}

resource "aws_s3_bucket_acl" "state_bucket_acl" {
  bucket = aws_s3_bucket.terraform_state.bucket
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "state_versioning_config" {
  bucket = aws_s3_bucket.terraform_state.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "state_encrypt_config" {
  bucket = aws_s3_bucket.terraform_state.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "state-bucket-config" {
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.state_versioning_config]

  bucket = aws_s3_bucket.terraform_state.bucket

  rule {
    id = "expire"
    status = "Enabled"
    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}