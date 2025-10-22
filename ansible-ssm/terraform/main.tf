terraform {
  required_version = ">= 1.13.3"

  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.5"
    }
  }
}

provider "aws" {
  region = "eu-west-2"

  # Ansible dynamic inventory is aligned with these tags
  default_tags {
    tags = {
      category    = "vmlab"
      application = "iac"
    }
  }
}
