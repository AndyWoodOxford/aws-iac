
provider "aws" {
  region = "eu-west-2"

  default_tags {
    tags = {
      category    = "asg"
      application = "oreillylearning"
    }
  }
}

provider "aws" {
  alias  = "ireland"
  region = "eu-west-1"
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

data "aws_availability_zones" "az" {
  state = "available"
}

data "http" "localhost" {
  url = "https://ipv4.icanhazip.com/"
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.example.dns_name
}

locals {
  standard_tags = {
    Name = var.resource_prefix
  }

  localhost = chomp(data.http.localhost.response_body)
}

#------------------------------------------------------------------------------
# IAM
resource "aws_iam_role" "ssm" {
  name = join("-", [var.resource_prefix, "ssm"])
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "ssm"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = local.standard_tags
}

resource "aws_iam_role_policy_attachment" "ssm" {
  for_each = toset([
    data.aws_iam_policy.AmazonCloudWatchAgentServerPolicy.arn,
    data.aws_iam_policy.AmazonSSMManagedInstanceCorePolicy.arn
  ])

  role       = aws_iam_role.ssm.name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "ssm" {
  name = join("-", [var.resource_prefix, "-ssm"])
  role = aws_iam_role.ssm.name

  tags = local.standard_tags
}

#------------------------------------------------------------------------------
# EC2

resource "aws_security_group" "egress" {
  name        = "${var.resource_prefix}-egress"
  description = "Allow egress for system updates etc"
  vpc_id      = data.aws_vpc.default.id

  tags = local.standard_tags
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  security_group_id = aws_security_group.egress.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"

  tags = local.standard_tags
}

resource "aws_launch_template" "example" {
  name = "example"

  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  block_device_mappings {
    device_name = "/dev/sdf"
    ebs {
      volume_size = 20
    }
  }
  ebs_optimized = true

  vpc_security_group_ids = [aws_security_group.egress.id]

  user_data = filebase64("${path.module}/user-data-ubuntu.sh")

  iam_instance_profile {
    name = aws_iam_instance_profile.ssm.name
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = local.standard_tags
}

resource "aws_autoscaling_group" "example" {
  desired_capacity = var.desired_capacity
  max_size         = 5
  min_size         = 0

  name_prefix = var.resource_prefix

  availability_zones = data.aws_availability_zones.az.names

  target_group_arns = [aws_lb_target_group.example.arn]
  health_check_type = "ELB"

  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }

  force_delete = true

  tag {
    key                 = "Name"
    value               = var.resource_prefix
    propagate_at_launch = true
  }
}

resource "aws_security_group" "alb" {
  name        = "${var.resource_prefix}-alb"
  description = "Allow inbound HTTP requests"
  vpc_id      = data.aws_vpc.default.id

  tags = local.standard_tags
}

resource "aws_vpc_security_group_ingress_rule" "ingress" {
  security_group_id = aws_security_group.alb.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "${local.localhost}/32"

  tags = local.standard_tags
}

resource "aws_vpc_security_group_egress_rule" "targets" {
  security_group_id = aws_security_group.alb.id
  ip_protocol       = "tcp"
  from_port         = 0
  to_port           = 0
  #cidr_ipv4         = data.aws_vpc.default.cidr_block
  cidr_ipv4 = "0.0.0.0/0"

  tags = local.standard_tags
}

#tfsec:ignore:aws-elb-alb-not-public    # accessible from my IPV4
resource "aws_lb" "example" {
  name                       = var.resource_prefix
  load_balancer_type         = "application"
  subnets                    = data.aws_subnets.default.ids
  security_groups            = [aws_security_group.alb.id]
  drop_invalid_header_fields = true
}

#tfsec:ignore:aws-elb-http-not-used   # https to come soon
resource "aws_lb_listener" "example" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: Your fault!"
      status_code  = 404
    }
  }
}

resource "aws_lb_listener_rule" "example" {
  listener_arn = aws_lb_listener.example.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example.arn
  }
}

resource "aws_lb_target_group" "example" {
  name     = var.resource_prefix
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# An attempt to use the ALB module from the Terraform registry
module "alb" {
  count = 0

  source  = "terraform-aws-modules/alb/aws"
  version = "10.0.1"

  name               = "${var.resource_prefix}-registry-module"
  load_balancer_type = "application"
  ip_address_type    = "ipv4"

  vpc_id                           = data.aws_vpc.default.id
  subnets                          = data.aws_subnets.default.ids
  enable_cross_zone_load_balancing = true
  security_groups                  = [aws_security_group.alb.id]

  tags = local.standard_tags

  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"

      rules = {
        fwd = {
          actions = [{
            fixed_response = {
              content_type = "text/plain"
              status_code  = 200
              message_body = "Hello World"
            }
          }]

          conditions = [{
            http_header = {
              http_header_name = "x-Gimme-Fixed-Response"
              values           = ["yes", "please", "right now"]
            }
          }]
        }
      }
    }
  }
}
