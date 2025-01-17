terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "my-tf-log-bucket"
  acl    = "log-delivery-write"
  tags = {
    git_commit           = "aa075746561a263ca5d4f198d51055c97052e170"
    git_file             = "TF/tf12_aws_all_issues/tf12_aws_all_issues.tf"
    git_last_modified_at = "2020-12-02 05:40:26"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "log_bucket"
    yor_trace            = "e630fae1-ca02-4a87-ab6d-e5efe6b47a30"
  }
}

resource "aws_s3_bucket_versioning" "log_bucket" {
  bucket = aws_s3_bucket.log_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "foo" {
  // 23. AWS S3 buckets are accessible to public (high)
  // $.resource[*].aws_s3_bucket exists and ($.resource[*].aws_s3_bucket.*[*].*.acl anyEqual public-read-write or $.resource[*].aws_s3_bucket.*[*].*.acl anyEqual public-read)
  acl = "public-read-write"

  bucket = "foo_name"
  // 24. AWS S3 Object Versioning is disabled (medium)
  // $.resource[*].aws_s3_bucket exists and ($.resource[*].aws_s3_bucket.*[*].*.versioning[*].enabled does not exist or $.resource[*].aws_s3_bucket.*[*].*.versioning[*].enabled anyFalse)
  versioning {
    enabled = false
  }
  // 1. AWS S3 CloudTrail buckets for which access logging is disabled ()
  // $.resource[*].aws_cloudtrail[*].*[*].enable_logging anyFalse
  // UPDATED Policy: "AWS Access logging not enabled on S3 buckets"
  // $.resource.aws_s3_bucket exists and ($.resource.aws_s3_bucket[*].logging anyNull or $.resource.aws_s3_bucket[*].logging[*].target_bucket !exists or $.resource.aws_s3_bucket[*].logging[*].target_bucket anyNull)
  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
  }
  tags = {
    git_commit           = "aa075746561a263ca5d4f198d51055c97052e170"
    git_file             = "TF/tf12_aws_all_issues/tf12_aws_all_issues.tf"
    git_last_modified_at = "2020-12-02 05:40:26"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "foo"
    yor_trace            = "6b1a8884-7fe1-432e-91b5-c27949cd01fe"
  }
}

resource "aws_cloudtrail" "foo_cloudtrail" {
  // 2. AWS CloudTrail bucket is publicly accessible (high)
  // $.resource[*].aws_cloudtrail exists and $.resource[*].aws_cloudtrail[*].*[*].s3_bucket_name equals $.resource[*].aws_s3_bucket_public_access_block[*].*[*].bucket and  ($.resource[*].aws_s3_bucket_public_access_block[*].*[*].block_public_acls isFalse or  $.resource[*].aws_s3_bucket_public_access_block[*].*[*].block_public_policy isFalse)
  name           = "tf-trail-foobar"
  s3_bucket_name = aws_s3_bucket.foo.id
  // 3. AWS CloudTrail logs are not encrypted using Customer Master Keys (CMKs)
  // $.resource[*].aws_cloudtrail exists and ($.resource[*].aws_cloudtrail[*].*[*].kms_key_id anyNull or $.resource[*].aws_cloudtrail[*].*[*].kms_key_id anyEmpty)
  // #REMOVED TO MAKE RULE MATCH# kms_key_id = "arn:aws:kms:us-west-2:111122223333:key"
  s3_key_prefix                 = "prefix"
  include_global_service_events = false
  enable_logging                = false
  tags = {
    git_commit           = "aa075746561a263ca5d4f198d51055c97052e170"
    git_file             = "TF/tf12_aws_all_issues/tf12_aws_all_issues.tf"
    git_last_modified_at = "2020-12-02 05:40:26"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "foo_cloudtrail"
    yor_trace            = "fc70e527-1152-425b-a1e1-f1b32626db97"
  }
}
resource "aws_s3_bucket_public_access_block" "example" {
  // 2+. AWS CloudTrail bucket is publicly accessible (high)
  bucket              = aws_s3_bucket.foo.id
  block_public_acls   = false
  block_public_policy = true
}

// ??? [Rule Not Matching] 30. AWS VPC allows unauthorized peering
// $.resource[*].aws_vpc_peering_connection[*].*[*].peer_vpc_id does not equal $.resource[*].aws_vpc_peering_connection[*].*[*].vpc_id
resource "aws_vpc_peering_connection" "foo" {
  peer_owner_id = "123"
  peer_vpc_id   = aws_vpc.bar_vpc.id
  vpc_id        = aws_vpc.foo_vpc.id
  tags = {
    git_commit           = "aa075746561a263ca5d4f198d51055c97052e170"
    git_file             = "TF/tf12_aws_all_issues/tf12_aws_all_issues.tf"
    git_last_modified_at = "2020-12-02 05:40:26"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "foo"
    yor_trace            = "33d8b420-43ff-4d99-ac10-52a805ce7232"
  }
}
resource "aws_vpc" "foo_vpc" {
  cidr_block = "172.16.0.0/16"
  tags = {
    Name                 = "foo-vpc-example"
    git_commit           = "aa075746561a263ca5d4f198d51055c97052e170"
    git_file             = "TF/tf12_aws_all_issues/tf12_aws_all_issues.tf"
    git_last_modified_at = "2020-12-02 05:40:26"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "foo_vpc"
    yor_trace            = "5438176a-efca-4440-80d0-331e5e11ca00"
  }
}
resource "aws_vpc" "bar_vpc" {
  cidr_block = "172.17.0.0/16"
  tags = {
    Name                 = "bar-vpc-example"
    git_commit           = "aa075746561a263ca5d4f198d51055c97052e170"
    git_file             = "TF/tf12_aws_all_issues/tf12_aws_all_issues.tf"
    git_last_modified_at = "2020-12-02 05:40:26"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "bar_vpc"
    yor_trace            = "581938f1-7b3f-4efa-9aa8-e9e76073b7cf"
  }
}

resource "aws_security_group" "allow_tcp" {
  name        = "allow_tcp"
  description = "Allow TCP inbound traffic"
  vpc_id      = aws_vpc.foo_vpc.id
  // 6. AWS Security Groups allow internet traffic to SSH port (22)
  // $.resource[*].aws_security_group exists and ($.resource[*].aws_security_group[*].*[*].ingress[?( @.protocol == 'tcp' && @.from_port<23 && @.to_port>21 )].cidr_blocks[*] contains 0.0.0.0/0 or $.resource[*].aws_security_group[*].*[*].ingress[?( @.protocol == 'tcp' && @.from_port<23 && @.to_port>21 )].ipv6_cidr_blocks[*] contains ::/0)
  ingress {
    description = "TCP from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  // 31. AWS security group allows egress traffic to blocked ports - 21,22,135,137-139,445,69
  // $.resource[*].aws_security_group exists and $.resource[*].aws_security_group.*[*].*.egress[?(@.protocol == 'tcp' && @.from_port == '22' && @.to_port == '22')].cidr_blocks[*] == 0.0.0.0/0 or $.resource[*].aws_security_group.*[*].*.egress[?(@.protocol == 'tcp' && @.from_port == '22' && @.to_port == '22')].ipv6_cidr_blocks[*] == ::/0 or $.resource[*].aws_security_group.*[*].*.egress[?(@.protocol == 'tcp' && @.from_port == '21' && @.to_port == '21')].cidr_blocks[*] == 0.0.0.0/0 or $.resource[*].aws_security_group.*[*].*.egress[?(@.protocol == 'tcp' && @.from_port == '21' && @.to_port == '21')].ipv6_cidr_blocks[*] == ::/0 or $.resource[*].aws_security_group.*[*].*.egress[?(@.protocol == 'tcp' && @.from_port == '445' && @.to_port == '445')].cidr_blocks[*] == 0.0.0.0/0 or $.resource[*].aws_security_group.*[*].*.egress[?(@.protocol == 'tcp' && @.from_port == '445' && @.to_port == '445')].ipv6_cidr_blocks[*] == ::/0 or $.resource[*].aws_security_group.*[*].*.egress[?(@.protocol == 'udp' && @.from_port == '135' && @.to_port == '135')].cidr_blocks[*] == 0.0.0.0/0 or $.resource[*].aws_security_group.*[*].*.egress[?(@.protocol == 'udp' && @.from_port == '135' && @.to_port == '135')].ipv6_cidr_blocks[*] == ::/0 or $.resource[*].aws_security_group.*[*].*.egress[?(@.protocol == '-1' && @.from_port == '137' && @.to_port == '139')].cidr_blocks[*] == 0.0.0.0/0 or $.resource[*].aws_security_group.*[*].*.egress[?(@.protocol == '-1' && @.from_port == '137' && @.to_port == '139')].ipv6_cidr_blocks[*] == ::/0 or $.resource[*].aws_security_group.*[*].*.egress[?(@.protocol == 'udp' && @.from_port == '69' && @.to_port == '69')].cidr_blocks[*] == 0.0.0.0/0 or $.resource[*].aws_security_group.*[*].*.egress[?(@.protocol == 'udp' && @.from_port == '69' && @.to_port == '69')].ipv6_cidr_blocks[*] == ::/0
  egress {
    from_port = 69
    to_port   = 69
    protocol  = "udp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  tags = {
    git_commit           = "aa075746561a263ca5d4f198d51055c97052e170"
    git_file             = "TF/tf12_aws_all_issues/tf12_aws_all_issues.tf"
    git_last_modified_at = "2020-12-02 05:40:26"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "allow_tcp"
    yor_trace            = "c6963b69-33af-40aa-9b9b-930198b3f109"
  }
}
// 25. AWS Security Groups allow internet traffic from internet to RDP port (3389)
// $.resource[*].aws_security_group exists and ($.resource[*].aws_security_group[*].*[*].ingress[?( @.protocol == 'tcp' && @.from_port<3390 && @.to_port>3388 )].cidr_blocks[*] contains 0.0.0.0/0 or $.resource[*].aws_security_group[*].*[*].ingress[?( @.protocol == 'tcp' && @.from_port<3390 && @.to_port>3388)].ipv6_cidr_blocks[*] contains ::/0)
resource "aws_security_group" "allow_rdp" {
  name        = "allow_rdp"
  description = "Allow RDP inbound traffic"
  vpc_id      = aws_vpc.bar_vpc.id
  ingress {
    description = "TCP from VPC"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    ipv6_cidr_blocks = [
    "::/0"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  tags = {
    git_commit           = "aa075746561a263ca5d4f198d51055c97052e170"
    git_file             = "TF/tf12_aws_all_issues/tf12_aws_all_issues.tf"
    git_last_modified_at = "2020-12-02 05:40:26"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "allow_rdp"
    yor_trace            = "97f48fea-f518-484c-9082-4d52946f52d6"
  }
}
// 27. AWS Security Groups with Inbound rule overly permissive to All Traffic
// ($.resource[*].aws_security_group exists and ($.resource[*].aws_security_group.*[*].*.ingress[*].protocol equals -1 and ($.resource[*].aws_security_group.*[*].*.ingress[*].cidr_blocks[*] contains 0.0.0.0/0 or $.resource[*].aws_security_group.*[*].*.ingress[*].ipv6_cidr_blocks[*] contains ::/0))) or ($.resource[*].aws_security_group_rule exists and ($.resource[*].aws_security_group_rule.*[*].*.protocol equals -1 and $.resource[*].aws_security_group_rule.*[*].*.type equals ingress and ($.resource[*].aws_security_group_rule.*[*].*.cidr_blocks[*] contains 0.0.0.0/0 or $.resource[*].aws_security_group_rule.*[*].*.ipv6_cidr_blocks[*] contains ::/0)))
resource "aws_security_group" "allow_all_traffic" {
  name        = "allow_rdp"
  description = "Allow RDP inbound traffic"
  vpc_id      = aws_vpc.bar_vpc.id
  ingress {
    description = "TCP from VPC"
    from_port   = 3389
    to_port     = 3389
    protocol    = "-1"
    ipv6_cidr_blocks = [
    "::/0"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  tags = {
    git_commit           = "aa075746561a263ca5d4f198d51055c97052e170"
    git_file             = "TF/tf12_aws_all_issues/tf12_aws_all_issues.tf"
    git_last_modified_at = "2020-12-02 05:40:26"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "allow_all_traffic"
    yor_trace            = "2623de1d-665e-4710-8df5-0a97551a3a58"
  }
}
// ??? [Not Matching, Dupe of 6?] 32. AWS security groups allow ingress traffic from blocked ports
//$.resource[*].aws_security_group.*[*].*.ingress[?(@.protocol == 'tcp' && @.from_port == '22' && @.to_port == '22')].cidr_blocks[*] == 0.0.0.0/0 or $.resource[*].aws_security_group.*[*].*.ingress[?(@.protocol == 'tcp' && @.from_port == '22' && @.to_port == '22')].ipv6_cidr_blocks[*] == ::/0 or $.resource[*].aws_security_group.*[*].*.ingress[?(@.protocol == 'tcp' && @.from_port == '21' && @.to_port == '21')].cidr_blocks[*] == 0.0.0.0/0 or $.resource[*].aws_security_group.*[*].*.ingress[?(@.protocol == 'tcp' && @.from_port == '21' && @.to_port == '21')].ipv6_cidr_blocks[*] == ::/0 or $.resource[*].aws_security_group.*[*].*.ingress[?(@.protocol == 'tcp' && @.from_port == '5800' && @.to_port == '5800')].cidr_blocks[*] == 0.0.0.0/0 or $.resource[*].aws_security_group.*[*].*.ingress[?(@.protocol == 'tcp' && @.from_port == '5800' && @.to_port == '5800')].ipv6_cidr_blocks[*] == ::/0 or $.resource[*].aws_security_group.*[*].*.ingress[?(@.protocol == 'tcp' && @.from_port == '5900' && @.to_port == '5903')].cidr_blocks[*] == 0.0.0.0/0 or $.resource[*].aws_security_group.*[*].*.ingress[?(@.protocol == 'tcp' && @.from_port == '5900' && @.to_port == '5903')].ipv6_cidr_blocks[*] == ::/0 or $.resource[*].aws_security_group.*[*].*.ingress[?(@.protocol == 'tcp' && @.from_port == '2323' && @.to_port == '2323')].cidr_blocks[*] == 0.0.0.0/0 or $.resource[*].aws_security_group.*[*].*.ingress[?(@.protocol == 'tcp' && @.from_port == '2323' && @.to_port == '2323')].ipv6_cidr_blocks[*] == ::/0 or $.resource[*].aws_security_group.*[*].*.ingress[?(@.protocol == 'tcp' && @.from_port == '23' && @.to_port == '23')].cidr_blocks[*] == 0.0.0.0/0 or $.resource[*].aws_security_group.*[*].*.ingress[?(@.protocol == 'tcp' && @.from_port == '23' && @.to_port == '23')].ipv6_cidr_blocks[*] == ::/0 or $.resource[*].aws_security_group.*[*].*.ingress[?(@.protocol == 'tcp' && @.from_port == '25' && @.to_port == '25')].cidr_blocks[*] == 0.0.0.0/0 or $.resource[*].aws_security_group.*[*].*.ingress[?(@.protocol == 'tcp' && @.from_port == '25' && @.to_port == '25')].ipv6_cidr_blocks[*] == ::/0 or $.resource[*].aws_security_group.*[*].*.ingress[?(@.protocol == 'tcp' && @.from_port == '110' && @.to_port == '110')].cidr_blocks[*] == 0.0.0.0/0 or $.resource[*].aws_security_group.*[*].*.ingress[?(@.protocol == 'tcp' && @.from_port == '110' && @.to_port == '110')].ipv6_cidr_blocks[*] == ::/0 or $.resource[*].aws_security_group.*[*].*.ingress[?(@.protocol == 'tcp' && @.from_port == '143' && @.to_port == '143')].cidr_blocks[*] == 0.0.0.0/0 or $.resource[*].aws_security_group.*[*].*.ingress[?(@.protocol == 'tcp' && @.from_port == '143' && @.to_port == '143')].ipv6_cidr_blocks[*] == ::/0 or $.resource[*].aws_security_group.*[*].*.ingress[?(@.protocol == '-1' && @.from_port == '53' && @.to_port == '53')].cidr_blocks[*] == 0.0.0.0/0 or $.resource[*].aws_security_group.*[*].*.ingress[?(@.protocol == '-1' && @.from_port == '53' && @.to_port == '53')].ipv6_cidr_blocks[*] == ::/0 or $.resource[*].aws_security_group.*[*].*.ingress[?(@.protocol == 'udp' && @.from_port == '135' && @.to_port == '135')].cidr_blocks[*] == 0.0.0.0/0 or $.resource[*].aws_security_group.*[*].*.ingress[?(@.protocol == 'udp' && @.from_port == '135' && @.to_port == '135')].ipv6_cidr_blocks[*] == ::/0 or $.resource[*].aws_security_group.*[*].*.ingress[?(@.protocol == '-1' && @.from_port == '137' && @.to_port == '139')].cidr_blocks[*] == 0.0.0.0/0 or $.resource[*].aws_security_group.*[*].*.ingress[?(@.protocol == '-1' && @.from_port == '137' && @.to_port == '139')].ipv6_cidr_blocks[*] == ::/0 or $.resource[*].aws_security_group.*[*].*.ingress[?(@.protocol == 'udp' && @.from_port == '69' && @.to_port == '69')].cidr_blocks[*] == 0.0.0.0/0 or $.resource[*].aws_security_group.*[*].*.ingress[?(@.protocol == 'udp' && @.from_port == '69' && @.to_port == '69')].ipv6_cidr_blocks[*] == ::/0
resource "aws_security_group" "allow_udp69" {
  name        = "allow_tcp2"
  description = "Allow TCP inbound traffic"
  vpc_id      = aws_vpc.bar_vpc.id
  ingress {
    description = "TCP from VPC"
    from_port   = 69
    to_port     = 69
    protocol    = "udp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  tags = {
    git_commit           = "aa075746561a263ca5d4f198d51055c97052e170"
    git_file             = "TF/tf12_aws_all_issues/tf12_aws_all_issues.tf"
    git_last_modified_at = "2020-12-02 05:40:26"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "allow_udp69"
    yor_trace            = "74151e89-6393-4707-8a2d-44d77fe2855a"
  }
}

resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.foo_vpc.id
  // 28. AWS VPC NACL allows egress traffic from blocked ports
  // $.resource[*].aws_network_acl exists and $.resource[*].aws_network_acl.*[*].*.egress[?(@.protocol == 'tcp' && @.from_port == '22' && @.to_port == '22')].action==allow or $.resource[*].aws_network_acl.*[*].*.egress[?(@.protocol == 'tcp' && @.from_port == '21' && @.to_port == '21')].action==allow or $.resource[*].aws_network_acl.*[*].*.egress[?(@.protocol == 'udp' && @.from_port == '135' && @.to_port == '135')].action==allow or $.resource[*].aws_network_acl.*[*].*.egress[?(@.protocol == 'tcp' && @.from_port == '445' && @.to_port == '445')].action==allow or $.resource[*].aws_network_acl.*[*].*.egress[?(@.protocol == '-1' && @.from_port == '137' && @.to_port == '139')].action==allow or $.resource[*].aws_network_acl.*[*].*.egress[?(@.protocol == 'udp' && @.from_port == '69' && @.to_port == '69')].action==allow
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "10.3.0.0/18"
    from_port  = 22
    to_port    = 22
  }
  // 29. AWS VPC NACL allows traffic from blocked ports
  // $.resource[*].aws_network_acl exists and $.resource[*].aws_network_acl.*[*].*.ingress[?(@.protocol == 'tcp' && @.from_port == '22' && @.to_port == '22')].action==allow or $.resource[*].aws_network_acl.*[*].*.ingress[?(@.protocol == 'tcp' && @.from_port == '21' && @.to_port == '21')].action==allow or $.resource[*].aws_network_acl.*[*].*.ingress[?(@.protocol == 'tcp' && @.from_port == '5800' && @.to_port == '5800')].action==allow or $.resource[*].aws_network_acl.*[*].*.ingress[?(@.protocol == 'tcp' && @.from_port == '5900' && @.to_port == '5903')].action==allow or  $.resource[*].aws_network_acl.*[*].*.ingress[?(@.protocol == 'tcp' && @.from_port == '2323' && @.to_port == '2323')].action==allow or $.resource[*].aws_network_acl.*[*].*.ingress[?(@.protocol == 'tcp' && @.from_port == '23' && @.to_port == '23')].action==allow or $.resource[*].aws_network_acl.*[*].*.ingress[?(@.protocol == 'tcp' && @.from_port == '25' && @.to_port == '25')].action==allow or $.resource[*].aws_network_acl.*[*].*.ingress[?(@.protocol == 'tcp' && @.from_port == '110' && @.to_port == '110')].action==allow or $.resource[*].aws_network_acl.*[*].*.ingress[?(@.protocol == 'tcp' && @.from_port == '143' && @.to_port == '143')].action==allow or $.resource[*].aws_network_acl.*[*].*.ingress[?(@.protocol == '-1' && @.from_port == '53' && @.to_port == '53')].action==allow or $.resource[*].aws_network_acl.*[*].*.ingress[?(@.protocol == 'udp' && @.from_port == '135' && @.to_port == '135')].action==allow or $.resource[*].aws_network_acl.*[*].*.ingress[?(@.protocol == '-1' && @.from_port == '137' && @.to_port == '139')].action==allow or $.resource[*].aws_network_acl.*[*].*.ingress[?(@.protocol == 'udp' && @.from_port == '69' && @.to_port == '69')].action==allow
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.3.0.0/18"
    from_port  = 22
    to_port    = 22
  }
  tags = {
    git_commit           = "aa075746561a263ca5d4f198d51055c97052e170"
    git_file             = "TF/tf12_aws_all_issues/tf12_aws_all_issues.tf"
    git_last_modified_at = "2020-12-02 05:40:26"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "main"
    yor_trace            = "ab4d97ad-8a65-4e2f-b5b8-eb753d7641d4"
  }
}
// 21. AWS Redshift does not have require_ssl configured
// $.resource[*].aws_redshift_parameter_group exists and ($.resource[*].aws_redshift_parameter_group[*].*[*].parameter[?(@.name=='require_ssl')] !exists  or $.resource[*].aws_redshift_parameter_group[*].*[*].parameter[?(@.name=='require_ssl' && @.value=='false' )] exists)
resource "aws_redshift_parameter_group" "bar" {
  name   = "parameter-group-test-terraform"
  family = "redshift-1.0"
  parameter {
    name  = "require_ssl"
    value = "false"
  }
  tags = {
    git_commit           = "aa075746561a263ca5d4f198d51055c97052e170"
    git_file             = "TF/tf12_aws_all_issues/tf12_aws_all_issues.tf"
    git_last_modified_at = "2020-12-02 05:40:26"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "bar"
    yor_trace            = "063d609b-aa6b-4e56-8ac8-b0af8f2c4e3e"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  // 20. AWS RDS snapshots are accessible to public (high)
  // $.resource[*].aws_db_instance exists and ($.resource[*].aws_db_instance[*].*[*].publicly_accessible !exists  or $.resource[*].aws_db_instance[*].*[*].publicly_accessible anyTrue)
  publicly_accessible                 = true
  iam_database_authentication_enabled = true
  tags = {
    git_commit           = "aa075746561a263ca5d4f198d51055c97052e170"
    git_file             = "TF/tf12_aws_all_issues/tf12_aws_all_issues.tf"
    git_last_modified_at = "2020-12-02 05:40:26"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "default"
    yor_trace            = "9a9ef9dc-b339-4a8a-96a7-86756c491c8c"
  }
}
// 19. AWS RDS event subscription disabled for DB security groups (medium)
// $.resource[*].aws_db_instance exists and ( $.resource[*].aws_db_event_subscription !exists or $.resource[*].aws_db_event_subscription[*].*[?(@.source_type=='db-security-group')] anyNull  or not $.resource[*].aws_db_event_subscription[*].*[?(@.source_type=='db-security-group')].enabled anyNull or $.resource[*].aws_db_event_subscription[*].*[?(@.source_type=='db-security-group')].enabled anyTrue )
resource "aws_sns_topic" "default" {
  name = "rds-events"
  tags = {
    git_commit           = "aa075746561a263ca5d4f198d51055c97052e170"
    git_file             = "TF/tf12_aws_all_issues/tf12_aws_all_issues.tf"
    git_last_modified_at = "2020-12-02 05:40:26"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "default"
    yor_trace            = "e9a4b7f5-f882-4dd6-9e56-7fc1d75eee44"
  }
}
resource "aws_db_event_subscription" "default" {
  name        = "rds-event-sub"
  sns_topic   = aws_sns_topic.default.arn
  source_type = "db-security-group"
  source_ids = [
  aws_db_instance.default.id]
  event_categories = [
    "availability",
    "deletion",
    "failover",
    "failure",
    "low storage",
    "maintenance",
    "notification",
    "read replica",
    "recovery",
    "restoration",
  ]
  enabled = false
  tags = {
    git_commit           = "aa075746561a263ca5d4f198d51055c97052e170"
    git_file             = "TF/tf12_aws_all_issues/tf12_aws_all_issues.tf"
    git_last_modified_at = "2020-12-02 05:40:26"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "default"
    yor_trace            = "864db9b2-9f7d-458e-ae2f-d5db1b869395"
  }
}

// 4. AWS Customer Master Key (CMK) rotation is not enabled (medium)
// $.resource[*].aws_kms_key exists and ( $.resource[*].aws_kms_key[*].*[*].enable_key_rotation anyFalse or  $.resource[*].aws_kms_key[*].*[*].enable_key_rotation anyNull)
resource "aws_kms_key" "a" {
  description         = "KMS key 1"
  enable_key_rotation = false
  tags = {
    git_commit           = "aa075746561a263ca5d4f198d51055c97052e170"
    git_file             = "TF/tf12_aws_all_issues/tf12_aws_all_issues.tf"
    git_last_modified_at = "2020-12-02 05:40:26"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "a"
    yor_trace            = "4a927539-db58-4639-be00-e1f709bee22f"
  }
}

// 5. AWS Default Security Group does not restrict all traffic (high)
// $.resource[*].aws_default_security_group exists and ($.resource[*].aws_default_security_group[*].*[*].ingress[*].cidr_blocks[*] contains 0.0.0.0/0 or $.resource[*].aws_default_security_group[*].*[*].ingress[*].ipv6_cidr_blocks[*] contains ::/0 or $.resource[*].aws_default_security_group[*].*[*].egress[*].cidr_blocks[*] contains 0.0.0.0/0 or $.resource[*].aws_default_security_group[*].*[*].egress[*].ipv6_cidr_blocks[*] contains ::/0)
resource "aws_vpc" "mainvpc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    git_commit           = "aa075746561a263ca5d4f198d51055c97052e170"
    git_file             = "TF/tf12_aws_all_issues/tf12_aws_all_issues.tf"
    git_last_modified_at = "2020-12-02 05:40:26"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "mainvpc"
    yor_trace            = "989eebeb-13d5-4736-8720-16f52f56a2d0"
  }
}
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.mainvpc.id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  tags = {
    git_commit           = "aa075746561a263ca5d4f198d51055c97052e170"
    git_file             = "TF/tf12_aws_all_issues/tf12_aws_all_issues.tf"
    git_last_modified_at = "2020-12-02 05:40:26"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "default"
    yor_trace            = "13a18e0b-b0af-4454-b92e-242721faf9ca"
  }
}


data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}
resource "aws_ecs_task_definition" "github-backup" {
  family = "github-backup"
  requires_compatibilities = [
  "FARGATE"]
  network_mode  = "awsvpc"
  cpu           = 1
  memory        = 128
  task_role_arn = "${data.aws_iam_role.ecs_task_execution_role.arn}"
  // 7. AWS ECS/ Fargate task definition execution IAM Role not found (medium)
  // $.resource[*].aws_ecs_task_definition exists and $.resource[*].aws_ecs_task_definition[*].*[*].container_definitions exists and ($.resource[*].aws_ecs_task_definition[*].*[*].execution_role_arn anyNull or $.resource[*].aws_ecs_task_definition[*].*[*].execution_role_arn anyEmpty)
  execution_role_arn = ""
  // 8. AWS ECS/ Fargate task definition root user found
  // $.resource[*].aws_ecs_task_definition[*].*[*].container_definitions[?(@.user=='root')] exists
  container_definitions = <<DEFINITION
  [
    {
      "cpu": 1,
      "image": "github",
      "memory": 128,
      "name": "github-backup",
      "networkMode": "awsvpc",
      "user": "root"
    }
  ]
  DEFINITION
  tags = {
    git_commit           = "aa075746561a263ca5d4f198d51055c97052e170"
    git_file             = "TF/tf12_aws_all_issues/tf12_aws_all_issues.tf"
    git_last_modified_at = "2020-12-02 05:40:26"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "github-backup"
    yor_trace            = "c49226be-8b88-4344-8a64-facbc4c20704"
  }
}
resource "aws_ecs_task_definition" "github-backup2" {
  family = "github-backup"
  requires_compatibilities = [
  "FARGATE"]
  network_mode  = "awsvpc"
  cpu           = 0
  memory        = 128
  task_role_arn = "${data.aws_iam_role.ecs_task_execution_role.arn}"
  // 7. AWS ECS/ Fargate task definition execution IAM Role not found (medium)
  // $.resource[*].aws_ecs_task_definition exists and $.resource[*].aws_ecs_task_definition[*].*[*].container_definitions exists and ($.resource[*].aws_ecs_task_definition[*].*[*].execution_role_arn anyNull or $.resource[*].aws_ecs_task_definition[*].*[*].execution_role_arn anyEmpty)
  execution_role_arn = ""
  // 8. AWS ECS/ Fargate task definition root user found
  // $.resource[*].aws_ecs_task_definition[*].*[*].container_definitions[?(@.user=='root')] exists
  container_definitions = <<DEFINITION
  [
    {
      "cpu": 1,
      "image": "github",
      "memory": 128,
      "name": "github-backup",
      "networkMode": "awsvpc",
      "user": "root"
    }
  ]
  DEFINITION
  tags = {
    git_commit           = "aa075746561a263ca5d4f198d51055c97052e170"
    git_file             = "TF/tf12_aws_all_issues/tf12_aws_all_issues.tf"
    git_last_modified_at = "2020-12-02 05:40:26"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "github-backup2"
    yor_trace            = "5bb65665-30db-4e87-b429-57273b461ff1"
  }
}

data "aws_subnet_ids" "example" {
  vpc_id = aws_vpc.mainvpc.id
}
resource "aws_elasticsearch_domain" "example" {
  domain_name           = "example"
  elasticsearch_version = "1.5"
  cluster_config {
    instance_type = "r4.large.elasticsearch"
  }
  // 9. AWS ElasticSearch cluster not in a VPC
  // $.resource[*].aws_elasticsearch_domain exists and $.resource[*].aws_elasticsearch_domain[*].*[*].vpc_options does not exist
  //  vpc_options {
  //    subnet_ids = [
  //      data.aws_subnet_ids.example.id]
  //    security_group_ids = [
  //      aws_security_group.allow_tcp.id]
  //  }
  snapshot_options {
    automated_snapshot_start_hour = 23
  }
  tags = {
    git_commit           = "aa075746561a263ca5d4f198d51055c97052e170"
    git_file             = "TF/tf12_aws_all_issues/tf12_aws_all_issues.tf"
    git_last_modified_at = "2020-12-02 05:40:26"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "example"
    yor_trace            = "a029806e-aade-47d3-9135-367d453a7442"
  }
}

resource "aws_iam_account_password_policy" "strict" {
  // 10. AWS IAM password policy allows password reuse (medium)
  // $.resource[*].aws_iam_account_password_policy[*].*[*].password_reuse_prevention == 0
  password_reuse_prevention = 0
  // 11. AWS IAM password policy does not expire in 90 days (medium)
  // $.resource[*].aws_iam_account_password_policy[*].*[?( @.max_password_age>90 )] is not empty
  max_password_age = 91
  // 12. AWS IAM password policy does not have a minimum of 14 characters (medium)
  // $.resource[*].aws_iam_account_password_policy[*].*[?( @.minimum_password_length<14 )] is not empty
  minimum_password_length = 8
  // 13. AWS IAM password policy does not have a lowercase character (medium)
  // $.resource[*].aws_iam_account_password_policy[*].*[*]
  require_lowercase_characters = false
  // 14. AWS IAM password policy does not have a number (medium)
  // $.resource[*].aws_iam_account_password_policy[*].*[*].require_numbers anyFalse
  require_numbers = false
  // 15. AWS IAM password policy does not have a symbol (medium)
  //$.resource[*].aws_iam_account_password_policy[*].*[*].require_symbols anyFalse
  require_symbols = false
  // 16. AWS IAM password policy does not have a uppercase character (medium)
  // $.resource[*].aws_iam_account_password_policy[*].*[*].require_uppercase_characters anyFalse
  require_uppercase_characters   = false
  allow_users_to_change_password = true
}

// 17. AWS IAM policy attached to users (low)
// $.resource[*].aws_iam_policy_attachment[*].*[*].users exists and $.resource[*].aws_iam_policy_attachment[*].*[*].users[*] is not empty
resource "aws_iam_policy_attachment" "test-attach" {
  name = "test-attachment"
  users = [
  "test-user"]
  roles = [
  "test-role"]
  groups = [
  "test-group"]
  policy_arn = "arn:aws:kms:us-west-2:111122223333:key"
}

// 18. AWS EKS unsupported Master node version (high)
// $.resource[*].aws_eks_cluster[*].*[*].version anyStartWith 1.9.
resource "aws_eks_cluster" "example" {
  name     = "example"
  role_arn = data.aws_iam_role.ecs_task_execution_role.arn
  vpc_config {
    subnet_ids = [
    data.aws_subnet_ids.example.id]
  }
  version = "1.9.9"
  tags = {
    git_commit           = "aa075746561a263ca5d4f198d51055c97052e170"
    git_file             = "TF/tf12_aws_all_issues/tf12_aws_all_issues.tf"
    git_last_modified_at = "2020-12-02 05:40:26"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "example"
    yor_trace            = "aa6e0980-65bf-49f6-b1f2-8e881523260f"
  }
}