# Account
data "aws_caller_identity" "current" {}

# Region
data "aws_region" "current" {}

# EC2
data "aws_ami" "amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  name_regex  = "^al2023-ami-2023\\.7\\.2025[0-9]{4}.+-x86_64$"
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

