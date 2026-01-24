provider "aws" {
  region = "eu-west-2"

  default_tags {
    tags = {
      terraform = "true"
    }
  }
}

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

data "aws_ec2_instance_type" "vm" {
  instance_type = var.instance_type
}

locals {
  ami_ids = {
    amazonlinux = data.aws_ami.amazonlinux2023.id
    debian      = data.aws_ami.debian13.id
    ubuntu      = data.aws_ami.ubuntu.id
  }

  asg_max_size = 5

  remote_users = {
    amazonlinux = "ec2-user"
    debian      = "debian"
    ubuntu      = "ubuntu"
  }

  standard_tags = merge(
    {
      remote_user = local.remote_users[var.platform]
      terraform   = true
    },
    var.tags
  )
}

resource "aws_security_group" "this" {
  name        = "${var.name}-instance"
  description = "Security group for the instances in the ASG"
}

resource "aws_launch_template" "this" {
  name        = var.name
  description = "Launch template for an ASG"

  image_id      = local.ami_ids[var.platform]
  instance_type = var.instance_type

  user_data = var.userdata != null ? filebase64(var.userdata) : null

  ebs_optimized = true

  vpc_security_group_ids = [aws_security_group.this.id]

  metadata_options {
    http_tokens = "required"
  }

  monitoring {
    enabled = "true"
  }

  lifecycle {
    precondition {
      condition     = data.aws_ec2_instance_type.vm.free_tier_eligible
      error_message = "${var.instance_type} is not part of the AWS free tier!"
    }
  }

  tags = local.standard_tags
}

resource "aws_autoscaling_group" "this" {
  name_prefix = var.name

  launch_template {
    id      = aws_launch_template.this.id
    version = aws_launch_template.this.latest_version
  }

  max_size         = var.asg_max_size
  min_size         = var.asg_min_size
  desired_capacity = floor(var.asg_min_size + var.asg_min_size / 2)

  vpc_zone_identifier = var.subnet_ids

  target_group_arns = var.target_group_arns
  health_check_type = var.health_check_type

  lifecycle {
    ignore_changes = [
      desired_capacity,
      target_group_arns
    ]

    precondition {
      condition     = var.asg_max_size <= local.asg_max_size
      error_message = "No more than ${local.asg_max_size} instances can be spun up!"
    }

    postcondition {
      condition     = length(self.availability_zones) > 1
      error_message = "More that 1 A/Z must be used for high availability!"
    }
  }

  termination_policies = [
    "ClosestToNextInstanceHour",
    "OldestInstance"
  ]

  force_delete = true

  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = local.standard_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  dynamic "tag" {
    for_each = data.aws_default_tags.current.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
