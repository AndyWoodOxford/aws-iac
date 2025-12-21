locals {
  env = "complete"
  tags = {
    example = "complete"
  }
}

module "vmlab" {
  source = "../.."

  name        = var.name
  environment = local.env

  # set to "true" to create a VPC; set to "false" to use the default VPC
  create_vpc = "true"

  # No load balancer or auto-scaling group
  create_asg = false
  create_lb  = false

  # spin up one Ubuntu instance
  instance_count = 1
  platform       = "ubuntu"

  # basic webserver
  userdata = "${path.module}/userdata_ubuntu.sh"

  # allow ingress for ssh and http and ping
  control_host_ingress = [
    { from_port = 22, to_port = 22, protocol = "tcp", description = "ssh access" },
    { from_port = 8, to_port = 0, protocol = "icmp", description = "ping" },
    { from_port = 80, to_port = 80, protocol = "tcp", description = "Apache Webserver" },
  ]

  # public key for ssh access (optional)
  public_key_path = "~/.ssh/id_rsa.pub"

  tags = local.tags
}