data "aws_ami" "ami_id" {
  most_recent = true
  owners      = ["137112412989"] # Canonical

  filter {
    name   = "name"
    values = ["al2023-ami-2023.9.*-kernel-6.12-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}
data "aws_vpc" "default" {
  default = true
}