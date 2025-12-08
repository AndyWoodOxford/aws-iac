
provider "aws" {
  region = "eu-west-2"

  default_tags {
    tags = {
      category    = "asg"
      application = "oreillylearning"
      terraform   = "true"
    }
  }
}

provider "aws" {
  alias  = "ireland"
  region = "eu-west-1"
}
