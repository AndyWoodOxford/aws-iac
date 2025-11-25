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
  create_vpc = "true"

  # spin up one Ubuntu instance
  instance_count = 1
  platform       = "ubuntu"

  public_key_path = "~/.ssh/id_rsa.pub"

  tags = local.tags
}