# tflint-ignore: terraform_unused_declarations  # implicit usage
data "aws_default_tags" "current" {}

# EC2
data "aws_ami" "amazonlinux2023" {
  owners      = ["amazon"]
  most_recent = true

  name_regex = "^al2023-ami-2023\\..+-x86_64$"

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_ami" "debian13" {
  owners      = ["amazon"]
  most_recent = true

  name_regex = "^debian-13-amd64-\\d+-\\d+$"

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
data "aws_iam_policy" "ssm" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy" "cloudwatch" {
  arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# VPC
data "aws_vpc" "default" {
  default = "true"
  state   = "available"
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_availability_zones" "az" {
  state = "available"
}

data "http" "localhost" {
  url = "https://ipv4.icanhazip.com/"
}



