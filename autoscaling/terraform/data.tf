data "aws_caller_identity" "current" {}

data "aws_ami" "amazonlinux" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
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

data "aws_iam_policy" "AmazonSSMManagedInstanceCorePolicy" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy" "AmazonCloudWatchAgentServerPolicy" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_region" "current" {}

data "aws_availability_zones" "az" {
  state = "available"
}

data "http" "localhost" {
  url = "https://ipv4.icanhazip.com/"
}
