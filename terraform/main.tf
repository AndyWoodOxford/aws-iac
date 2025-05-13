terraform {
  required_version = ">= 1.5.7"

  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.97"
    }

    http = {
      source  = "hashicorp/http"
      version = "~> 3.5"
    }
  }
}
