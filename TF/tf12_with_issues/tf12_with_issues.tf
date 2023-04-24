terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "foo" {
  bucket = "my-tf-log-bucket"
  acl    = "public-read-write"
  tags = {
    yor_trace = "3f6e6e22-bbee-4f1a-a6e8-2a2e6c4c7e2f"
  }
}