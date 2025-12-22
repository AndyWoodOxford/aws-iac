provider "aws" {
  default_tags {
    tags = {
      example   = "complete"
      module    = "vmlab-asg"
      terraform = "true"
    }
  }
}

locals {
  env = "complete"
  tags = {
    name = "example-${local.env}"
  }
}

module "vmlab" {
  source = "../.."

  name        = var.name
  environment = local.env

  # set to "true" to create a VPC; set to "false" to use the default VPC
  create_vpc = "true"

  # Ubuntu AMI
  platform = "ubuntu"

  # basic webserver
  userdata = "${path.module}/userdata_ubuntu.sh"

  # allow ingress for http and ping
  control_host_ingress = [
    { from_port = 8, to_port = 0, protocol = "icmp", description = "ping" },
    { from_port = 80, to_port = 80, protocol = "tcp", description = "Apache Webserver" },
  ]

  tags = local.tags
}