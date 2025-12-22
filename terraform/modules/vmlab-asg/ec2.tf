resource "aws_security_group" "instance" {
  name        = "${var.name}-${var.environment}-instance"
  description = "Allow system updates and forwarding from load balancer"
  vpc_id      = var.create_vpc ? module.vpc[0].vpc_id : data.aws_vpc.default.id

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    local.standard_tags,
    {
      Name = "${local.resource_prefix}-instance"
    }
  )
}

resource "aws_vpc_security_group_egress_rule" "http" {
  security_group_id = aws_security_group.instance.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"

  tags = local.standard_tags
}

resource "aws_vpc_security_group_egress_rule" "https" {
  security_group_id = aws_security_group.instance.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"

  tags = local.standard_tags
}

resource "aws_vpc_security_group_ingress_rule" "alb" {
  security_group_id            = aws_security_group.instance.id
  referenced_security_group_id = aws_security_group.alb.id
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80

  tags = local.standard_tags
}

resource "aws_security_group" "control_host_ingress" {
  name        = "${var.name}-${var.environment}-ingress"
  description = "Allow access from the control host"
  vpc_id      = var.create_vpc ? module.vpc[0].vpc_id : data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = toset(var.control_host_ingress)
    content {
      description = ingress.value.description
      protocol    = ingress.value.protocol
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      cidr_blocks = ["${local.control_host}/32"]
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    local.standard_tags,
    {
      Name = "${local.resource_prefix}-control-host"
    }
  )
}

resource "aws_security_group" "alb" {
  name        = "${local.resource_prefix}-alb"
  description = "Application load balancer"
  vpc_id      = var.create_vpc ? module.vpc[0].vpc_id : data.aws_vpc.default.id

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    local.standard_tags,
    {
      Name = "${local.resource_prefix}-alb"
    }
  )
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.alb.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "${local.control_host}/32"

  tags = local.standard_tags
}

resource "aws_vpc_security_group_egress_rule" "forwarding" {
  security_group_id = aws_security_group.alb.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4 = (
    var.create_vpc ? module.vpc[0].vpc_cidr_block : data.aws_vpc.default.cidr_block
  )
}

#tfsec:ignore:aws-elb-alb-not-public    # accessible from my IPV4
resource "aws_lb" "vmlab" {
  name               = var.name
  load_balancer_type = "application"
  internal           = false

  subnets = (
    var.create_vpc ? module.vpc[0].public_subnets : data.aws_subnets.default.ids
  )
  security_groups            = [aws_security_group.alb.id]
  drop_invalid_header_fields = true
  tags                       = local.standard_tags
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.vmlab.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vmlab.arn
  }
}

resource "aws_lb_target_group" "vmlab" {
  name     = var.name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.create_vpc ? module.vpc[0].vpc_id : data.aws_vpc.default.id
}

resource "aws_autoscaling_attachment" "vmlab" {
  autoscaling_group_name = aws_autoscaling_group.vmlab.id
  lb_target_group_arn    = aws_lb_target_group.vmlab.arn
}

resource "aws_launch_template" "vmlab" {
  name        = local.resource_prefix
  description = "Tentative launch template for a 'VM Lab'"

  image_id      = local.ami_ids[var.platform]
  instance_type = var.instance_type

  user_data = var.userdata != null ? filebase64(var.userdata) : null

  ebs_optimized = true

  vpc_security_group_ids = [
    aws_security_group.instance.id,
    aws_security_group.control_host_ingress.id
  ]

  iam_instance_profile {
    name = aws_iam_instance_profile.ssm.name
  }

  metadata_options {
    http_tokens = "required"
  }

  monitoring {
    enabled = "true"
  }

  tags = local.standard_tags
}

resource "aws_autoscaling_group" "vmlab" {
  name_prefix = local.resource_prefix

  launch_template {
    id      = aws_launch_template.vmlab.id
    version = aws_launch_template.vmlab.latest_version
  }

  max_size = 3
  min_size = 1

  vpc_zone_identifier = (
    var.create_vpc ? module.vpc[0].public_subnets : data.aws_subnets.default.ids
  )

  health_check_type = "ELB"

  lifecycle {
    ignore_changes = [
      desired_capacity,
      target_group_arns
    ]
  }

  termination_policies = [
    "ClosestToNextInstanceHour",
    "OldestInstance"
  ]

  force_delete = true

  tag {
    key                 = "Name"
    value               = local.resource_prefix
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
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale_down"
  autoscaling_group_name = aws_autoscaling_group.vmlab.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 120
}

resource "aws_cloudwatch_metric_alarm" "scale_down" {
  alarm_name          = "scale_down"
  alarm_description   = "Monitors CPU for Apache servers"
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilisation"
  threshold           = "20"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.vmlab.name
  }
}
