terraform {
  required_version = ">= 1.5.7"

  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.100"
    }

    http = {
      source  = "hashicorp/http"
      version = "~> 3.5"
    }
  }
}

provider "aws" {
  region = "eu-west-2"

  default_tags {
    tags = {
      category = "jobhunt2025"
    }
  }
}