terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "foo" {
  bucket = "my-tf-log-bucket"
  acl    = "private"
  versioning {
    enabled = true
  }
  logging {
    target_bucket = "logging_bucket"
    target_prefix = "log/"
  }
  tags = {
    git_commit           = "aa075746561a263ca5d4f198d51055c97052e170"
    git_file             = "TF/tf12_fixed_issues/tf12_fixed_issues.tf"
    git_last_modified_at = "2020-12-02 05:40:26"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "foo"
    yor_trace            = "d632322b-3f8a-42f7-899c-7bd23ebfcbc7"
  }
}