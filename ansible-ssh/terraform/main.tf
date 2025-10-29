provider "aws" {
  region = "eu-west-2"

  # Ansible dynamic inventory is aligned with these tags
  default_tags {
    tags = {
      category    = "vmlab"
      application = "ansible-ssh"
    }
  }
}

locals {
  name = "vmlab"

  tags = {
    application = "ansible-ssh"
    environment = var.environment
  }
}

module "resources" {
  source = "../../terraform/modules/vmlab"

  environment = var.environment
  name        = local.name

  instance_count = var.instance_count
  instance_type  = var.instance_type

  platform        = "ubuntu"
  public_key_path = var.public_key_path

  vpc_cidr = var.vpc_cidr

  tags = local.tags
}
