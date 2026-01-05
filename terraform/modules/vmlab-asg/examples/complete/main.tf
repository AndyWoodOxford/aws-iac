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
  name = "vmlab-asg-${basename(path.cwd)}"
}

module "vmlab" {
  source = "../.."

  name = local.name

  # set to "true" to create a VPC; set to "false" to use the default VPC
  create_vpc = "false"

  # Ubuntu AMI
  platform = "ubuntu"

  # allows the testing of the variable validation code
  asg_max_size = 3

  # basic webserver
  userdata = "${path.module}/userdata-ubuntu.sh"

  # allow ingress for http and ping
  control_host_ingress = [
    { from_port = 8, to_port = 0, protocol = "icmp", description = "ping" },
    { from_port = 80, to_port = 80, protocol = "tcp", description = "Apache Webserver" },
  ]
}
