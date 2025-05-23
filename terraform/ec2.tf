# Launch key
resource "aws_key_pair" "launch" {
  key_name   = local.ec2_key_pair_name
  public_key = file(var.public_key_path)
}

# Security group with http/https egress and ssh ingress from localhost
resource "aws_security_group" "basic" {
  name        = local.deployment_prefix
  description = "Basic egress and ingress for tech refresh"
  vpc_id      = data.aws_vpc.default.id

  tags = local.standard_tags
}

resource "aws_vpc_security_group_egress_rule" "http" {
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.basic.id

  tags = local.standard_tags
}

resource "aws_vpc_security_group_egress_rule" "https" {
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.basic.id

  tags = local.standard_tags
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  cidr_ipv4         = "${local.control_host_ipv4}/32"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.basic.id

  tags = local.standard_tags
}

# Instance
resource "aws_instance" "vm" {
  count = var.instance_count

  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = local.ec2_key_pair_name

  root_block_device {
    encrypted             = true
    delete_on_termination = true
  }

  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.basic.id]

  iam_instance_profile = aws_iam_instance_profile.ssm.name

  metadata_options {
    http_tokens = "required"
  }

  tags = merge(
    local.standard_tags,
    {
      Name = (var.instance_count > 1
        ? format("%s-%d", local.standard_tags["Name"], count.index + 1)
        : local.standard_tags["Name"]
      )
    }
  )
  volume_tags = local.standard_tags
}