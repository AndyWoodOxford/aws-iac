terraform {
  required_version = ">= 1.14.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.5"
    }
  }

  # uncomment for a remote S3 backend
  #backend "s3" {}
}
