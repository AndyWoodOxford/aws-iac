locals {
  availability_zones = data.aws_availability_zones.az.names

  public_subnets_ipv4 = [
  for i in range(0, length(local.availability_zones) * 2, 2) : cidrsubnet(var.vpc_cidr, var.subnet_cidr_mask - 16, i)]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.4.0"

  name = var.name

  cidr                 = var.vpc_cidr
  azs                  = data.aws_availability_zones.az.names
  public_subnets       = local.public_subnets_ipv4
  public_subnet_suffix = "public"
  public_subnet_tags = {
    SubnetUsage = "public"
  }

  create_igw = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.standard_tags
}

resource "aws_security_group" "vmlab" {
  name        = var.name
  description = "Allows Ansible to run"
  vpc_id      = module.vpc.vpc_id

  tags = local.standard_tags
}

resource "aws_vpc_security_group_egress_rule" "http" {
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.vmlab.id

  tags = local.standard_tags
}

resource "aws_vpc_security_group_egress_rule" "https" {
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.vmlab.id

  tags = local.standard_tags
}

resource "aws_vpc_security_group_ingress_rule" "ansible" {
  cidr_ipv4         = "${local.control_host_ipv4}/32"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.vmlab.id

  tags = local.standard_tags
}
