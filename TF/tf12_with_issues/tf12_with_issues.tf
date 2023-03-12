terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "foo" {
  bucket = "my-tf-log-bucket"
  acl = "private"
}

resource "aws_s3_bucket" "foo_log_bucket" {
  bucket = "foo-log-bucket"
}

resource "aws_s3_bucket_logging" "foo" {
  bucket = aws_s3_bucket.foo.id

  target_bucket = aws_s3_bucket.foo_log_bucket.id
  target_prefix = "log/"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "foo" {
  bucket = aws_s3_bucket.foo.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
    }
  }
}