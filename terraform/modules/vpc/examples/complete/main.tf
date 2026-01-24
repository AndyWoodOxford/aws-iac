provider "aws" {
  region = "eu-west-2"

  default_tags {
    tags = {
      terraform = "true"
    }
  }
}

locals {
  name = "vpc-example-${basename(path.cwd)}"
}
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

module "vpc" {
  source = "../.."

  name = local.name

  create_vpc = "true"

  tags = {
    category = "example"
    example  = basename(path.cwd)
  }
}

