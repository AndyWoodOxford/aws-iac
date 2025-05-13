# Launch key
resource "aws_key_pair" "launch" {
  key_name   = local.deployment_prefix
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