# Account
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# EC2
data "aws_ami" "amazonlinux2" {
  owners      = ["amazon"]
  most_recent = true

  name_regex = "^amzn2-ami-hvm-2\\.\\d+\\..+$"

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_ami" "ubuntu" {
  owners      = ["amazon"]
  most_recent = true

  name_regex = "^ubuntu/images/hvm-ssd-gp3/ubuntu-\\w+-\\d+.\\d+-amd64-server-\\d+$"

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# IAM
data "aws_iam_policy" "AmazonSSMManagedInstanceCorePolicy" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy" "AmazonCloudWatchAgentServerPolicy" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# VPC
data "aws_availability_zones" "az" {
  state = "available"
}

data "http" "localhost" {
  url = "https://ipv4.icanhazip.com/"
}



