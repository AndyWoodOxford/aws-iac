terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.5"
    }
  }

  # uncomment for a remote S3 backend (see the README)
  backend "s3" {}
}
