# Account
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# EC2
data "aws_ami" "amazon_linux" {
  owners      = ["amazon"]
  most_recent = true

  name_regex = "^amzn2-ami-hvm-2\\.\\d+\\..+$"

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "http" "localhost" {
  url = "https://ipv4.icanhazip.com/"
}

# IAM
data "aws_iam_policy" "AmazonSSMManagedInstanceCorePolicy" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy" "AmazonCloudWatchAgentServerPolicy" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# VPC
data "aws_vpc" "default" {
  default = true
}

