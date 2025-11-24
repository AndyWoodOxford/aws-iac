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

  platform = "ubuntu"

  public_key_path = "~/.ssh/id_rsa.pub"

  create_vpc = "true"

  tags = local.tags
}