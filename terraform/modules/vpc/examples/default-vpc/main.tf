provider "aws" {
  region = "eu-west-2"

  default_tags {
    tags = {
      terraform = "true"
    }
  }
}

locals {
  name = "vmlab-${basename(path.cwd)}"
}

module "vpc" {
  source = "../.."

  name = local.name

  create_vpc = "true"
}

