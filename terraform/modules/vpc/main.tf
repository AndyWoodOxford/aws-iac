provider "aws" {
  region = "eu-west-2"

  default_tags {
    tags = {
      terraform = "true"
    }
  }
}

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

locals {
  availability_zones = data.aws_availability_zones.az.names

  private_subnets_ipv4 = [
    for i in range(0, length(local.availability_zones)) : cidrsubnet(var.vpc_cidr, var.subnet_cidr_mask - 16, i)]

  public_subnets_ipv4 = [
    for i in range(0, length(local.availability_zones)) : cidrsubnet(var.vpc_cidr, var.subnet_cidr_mask - 16, i + length(local.availability_zones))]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.4.0"

  count = var.create_vpc ? 1 : 0

  name = var.name

  cidr = var.vpc_cidr
  azs  = data.aws_availability_zones.az.names

  private_subnets       = local.private_subnets_ipv4
  private_subnet_suffix = "private"
  private_subnet_tags = {
    SubnetUsage = "private"
  }

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnets       = local.public_subnets_ipv4
  public_subnet_suffix = "public"
  public_subnet_tags = {
    SubnetUsage = "public"
  }

  create_igw = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = var.tags
}
