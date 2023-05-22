terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"
  tags = {
    Name                 = "tf-0.12-for-example"
    git_commit           = "aa075746561a263ca5d4f198d51055c97052e170"
    git_file             = "TF/tf12_variable_values/main.tf"
    git_last_modified_at = "2020-12-02 05:40:26"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "my_vpc"
    yor_trace            = "de4a61ff-5be8-43ce-9fda-2575f3cd1767"
  }
}

resource "aws_s3_bucket" "publics3" {
  acl    = var.acl
  bucket = "publics3"
  versioning {
    enabled = true
  }
  tags = {
    git_commit           = "aa075746561a263ca5d4f198d51055c97052e170"
    git_file             = "TF/tf12_variable_values/main.tf"
    git_last_modified_at = "2020-12-02 05:40:26"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "publics3"
    yor_trace            = "6c7f03fd-b0be-4df1-9e78-9964eea705d7"
  }
}

resource "aws_security_group" "allow_tcp" {
  name        = "allow_tcp"
  description = "Allow TCP inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id
  ingress {
    description = "TCP from VPC"
    // AWS Security Groups allow internet traffic to SSH port (22)
    from_port = 99
    to_port   = 99
    protocol  = "tcp"
    cidr_blocks = [
    var.cidr]
  }
  tags = {
    git_commit           = "aa075746561a263ca5d4f198d51055c97052e170"
    git_file             = "TF/tf12_variable_values/main.tf"
    git_last_modified_at = "2020-12-02 05:40:26"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "allow_tcp"
    yor_trace            = "441f1a7f-9ff5-429a-8b05-8d4b5197f744"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name                 = "tf-0.12-for-example"
    git_commit           = "aa075746561a263ca5d4f198d51055c97052e170"
    git_file             = "TF/tf12_variable_values/main.tf"
    git_last_modified_at = "2020-12-02 05:40:26"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "my_subnet"
    yor_trace            = "a691b0c6-29ea-436f-98de-f50d36a53773"
  }
}

resource "aws_instance" "ubuntu" {
  count                       = 3
  ami                         = "ami-2e1ef954"
  instance_type               = "t2.micro"
  associate_public_ip_address = (count.index == 1 ? true : false)
  subnet_id                   = aws_subnet.my_subnet.id
  tags = {
    Name                 = format("terraform-0.12-for-demo-%d", count.index)
    git_commit           = "aa075746561a263ca5d4f198d51055c97052e170"
    git_file             = "TF/tf12_variable_values/main.tf"
    git_last_modified_at = "2020-12-02 05:40:26"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "ubuntu"
    yor_trace            = "a7f27426-7df8-499c-ae56-4a806c7e8fd3"
  }
}

# This uses the old splat expression
output "private_addresses_old" {
  value = aws_instance.ubuntu.*.private_dns
}

# This uses the new full splat operator (*)
# But this does not work in 0.12 alpha-1 or alpha-2
/*output "private_addresses_full_splat" {
  value = [ aws_instance.ubuntu[*].private_dns ]
}*/

# This uses the new for expression
output "private_addresses_new" {
  value = [
    for instance in aws_instance.ubuntu :
    instance.private_dns
  ]
}

# This uses the new conditional operator
# that can work with lists
# It should work with lists in [x, y, z] form, but does not yet do that
output "ips" {
  value = [
    for instance in aws_instance.ubuntu :
    (instance.public_ip != "" ? list(instance.private_ip, instance.public_ip) : list(instance.private_ip))
  ]
}
