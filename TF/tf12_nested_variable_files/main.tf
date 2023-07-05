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
    git_commit           = "ec029848d974016b366a9aceed1274644030afdb"
    git_file             = "TF/tf12_nested_variable_files/main.tf"
    git_last_modified_at = "2020-12-03 17:53:32"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "my_vpc"
    yor_trace            = "11bc8a43-5b28-4b26-a087-7a88a9854ff6"
    Demo                 = "gir_repo"
  }
}

resource "aws_s3_bucket" "publics3" {
  // AWS S3 buckets are accessible to public
  acl    = var.acl_file
  bucket = "publics3"
  versioning {
    enabled = true
  }
  tags = {
    git_commit           = "ec029848d974016b366a9aceed1274644030afdb"
    git_file             = "TF/tf12_nested_variable_files/main.tf"
    git_last_modified_at = "2020-12-03 17:53:32"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "publics3"
    yor_trace            = "2ce794e0-05ff-4343-b309-16a52f963619"
    Demo                 = "gir_repo"
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
    var.cidr_file]
  }
  tags = {
    git_commit           = "ec029848d974016b366a9aceed1274644030afdb"
    git_file             = "TF/tf12_nested_variable_files/main.tf"
    git_last_modified_at = "2020-12-03 17:53:32"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "allow_tcp"
    yor_trace            = "f5e20280-d22a-4c88-97e5-78d1d04808f7"
    Demo                 = "gir_repo"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name                 = "tf-0.12-for-example"
    git_commit           = "ec029848d974016b366a9aceed1274644030afdb"
    git_file             = "TF/tf12_nested_variable_files/main.tf"
    git_last_modified_at = "2020-12-03 17:53:32"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "my_subnet"
    yor_trace            = "4714f301-23f5-4ba5-a8e4-113d8ce8a580"
    Demo                 = "gir_repo"
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
    git_commit           = "ec029848d974016b366a9aceed1274644030afdb"
    git_file             = "TF/tf12_nested_variable_files/main.tf"
    git_last_modified_at = "2020-12-03 17:53:32"
    git_last_modified_by = "ginguyen@paloaltonetworks.com"
    git_modifiers        = "ginguyen"
    git_org              = "prashmp"
    git_repo             = "iac-samples"
    yor_name             = "ubuntu"
    yor_trace            = "f1ab49da-97f8-4a26-80fb-80ca3f207b63"
    Demo                 = "gir_repo"
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
