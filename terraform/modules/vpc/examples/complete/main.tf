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

module "vpc" {
  source = "../.."

  name = local.name

  create_vpc = "true"

  tags = {
    category = "example"
    example = basename(path.cwd)
  }
}

