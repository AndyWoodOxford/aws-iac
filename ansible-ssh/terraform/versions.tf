terraform {
  required_version = ">= 1.5.7"

  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.5"
    }
  }
}

