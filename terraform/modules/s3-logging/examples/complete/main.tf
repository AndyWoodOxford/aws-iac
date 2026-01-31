provider "aws" {
  region = "eu-west-2"

  default_tags {
    tags = {
      terraform = "true"
    }
  }
}

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  dir_name   = basename(path.cwd)
}

module "s3_logging" {
  source = "../.."

  name = "${local.account_id}-${local.dir_name}"

  expiry_in_days = 30

  # TODO
  sse_key_arn = null

  tags = {
    category = "example"
    example  = local.dir_name
  }
}