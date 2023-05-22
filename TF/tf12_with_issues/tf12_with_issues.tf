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
    git_commit           = "aa075746561a263ca5d4f198d51055c97052e170"
    git_file             = "TF/tf12_with_issues/tf12_with_issues.tf"
    git_last_modified_at = "2020-12-02 05:40:26"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "foo"
    yor_trace            = "0b8435f5-a72c-4cae-bbcd-2f5536435874"
  }
}