provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.network_config
  tags = {
    Name                 = var.network_config
    git_commit           = "aa075746561a263ca5d4f198d51055c97052e170"
    git_file             = "TF/tf12_rich-value-types/network/main.tf"
    git_last_modified_at = "2020-12-02 05:40:26"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "my_vpc"
    yor_trace            = "e88ae089-f513-4b3e-8af2-5e449623fafc"
    Env                  = "prod"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.network_config
  availability_zone = "us-west-2a"
  tags = {
    Name                 = var.network_config
    git_commit           = "aa075746561a263ca5d4f198d51055c97052e170"
    git_file             = "TF/tf12_rich-value-types/network/main.tf"
    git_last_modified_at = "2020-12-02 05:40:26"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "my_subnet"
    yor_trace            = "641e8c43-84ab-4921-9105-a9935ecd41f9"
    Env                  = "prod"
  }
}
