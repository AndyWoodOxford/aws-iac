resource "aws_security_group" "vm_egress" {
  name        = "${var.name}-${var.environment}-egress"
  description = "Allow system updates"
  vpc_id      = var.create_vpc ? module.vpc[0].vpc_id : data.aws_vpc.default.id

  tags = local.standard_tags
}

resource "aws_vpc_security_group_egress_rule" "http" {
  security_group_id = aws_security_group.vm_egress.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"

  tags = local.standard_tags
}

resource "aws_vpc_security_group_egress_rule" "https" {
  security_group_id = aws_security_group.vm_egress.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"

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
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      cidr_blocks = ["${local.control_host}/32"]
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = local.standard_tags
}

resource "aws_key_pair" "ansible" {
  count      = var.public_key_path != null ? 1 : 0
  key_name   = "${var.name}-${var.environment}"
  public_key = file(var.public_key_path)

  tags = local.standard_tags
}

resource "aws_instance" "vm" {
  count = var.instance_count

  ami           = local.ami_ids[var.platform]
  instance_type = var.instance_type

  key_name = var.public_key_path != null ? aws_key_pair.ansible[0].key_name : null

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 25
    encrypted             = true
    delete_on_termination = true
  }

  associate_public_ip_address = true
  subnet_id = (
    var.create_vpc ? module.vpc[0].public_subnets[count.index % length(module.vpc[0].public_subnets)]
    : data.aws_subnets.default.ids[count.index % length(data.aws_subnets.default.ids)]
  )

  vpc_security_group_ids = [
    aws_security_group.vm_egress.id,
    aws_security_group.control_host_ingress.id
  ]

  iam_instance_profile = aws_iam_instance_profile.ssm.name

  lifecycle {
    create_before_destroy = true
  }

  metadata_options {
    http_tokens = "required"
  }

  user_data_base64 = var.userdata != null ? filebase64(var.userdata) : null

  tags = merge(
    local.standard_tags,
    {
      Name = (var.instance_count > 1
        ? format("%s-%d", local.standard_tags["Name"], count.index + 1)
        : local.standard_tags["Name"]
      )
    }
  )

  volume_tags = merge(local.standard_tags,
    {
      Name = (var.instance_count > 1
        ? format("%s-%d", local.standard_tags["Name"], count.index + 1)
        : local.standard_tags["Name"]
      )
    }
  )
}

#-----------------------
# Experimentation with load balancer, target group and ASG
resource "aws_launch_template" "vmlab" {
  name = "example"

  image_id      = local.ami_ids[var.platform]
  instance_type = var.instance_type

  user_data = var.userdata != null ? filebase64(var.userdata) : null

  ebs_optimized = true

  vpc_security_group_ids = [
    aws_security_group.vm_egress.id,
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

resource "aws_security_group" "alb" {
  name        = "${var.name}-${var.environment}-alb"
  description = "Application load balancer"
  vpc_id      = var.create_vpc ? module.vpc[0].vpc_id : data.aws_vpc.default.id

  tags = local.standard_tags
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.alb.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "${local.control_host}/32"

  tags = local.standard_tags
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

resource "aws_lb_target_group" "vmlab" {
  name     = var.name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.create_vpc ? module.vpc[0].vpc_id : data.aws_vpc.default.id
}

