provider "aws" {
  region = "eu-west-2"

  default_tags {
    tags = {
      category = "jobhunt2025"
    }
  }
}