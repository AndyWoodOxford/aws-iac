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
      delete_on_termination = "true"
      encrypted             = "true"
      volume_size           = 20
    }
  }
  ebs_optimized = true

  vpc_security_group_ids = [aws_security_group.egress.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ssm.name
  }

  instance_market_options {
    market_type = "spot"
  }

  metadata_options {
    http_tokens = "required"
  }

  monitoring {
    enabled = "false"
  }

  tag_specifications {
    resource_type = "instance"

    tags = local.standard_tags
  }
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
