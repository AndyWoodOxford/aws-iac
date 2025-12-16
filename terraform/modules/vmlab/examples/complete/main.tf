locals {
  env = "01"
  tags = {
    example = "complete"
  }
}

module "vmlab" {
  source = "../.."

  name        = var.name
  environment = local.env

  # set to "true" to create a VPC; set to "false" to use the default VPC
  create_vpc = "false"

  # spin up one Ubuntu instance
  instance_count = 1
  platform       = "ubuntu"

  # allow ingress for ssh and http
  control_host_ingress = [
    { port = 22, protocol = "tcp", description = "ssh access" },
    { port = 80, protocol = "tcp", description = "Apache Webserver" },
  ]

  # public key for ssh access
  public_key_path = "~/.ssh/id_rsa.pub"

  tags = local.tags
}