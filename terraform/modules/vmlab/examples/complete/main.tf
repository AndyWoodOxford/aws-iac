provider "aws" {
  default_tags {
    tags = {
      example   = "complete"
      module    = "vmlab"
      terraform = "true"
    }
  }
}

resource "random_password" "pwd" {
  length = 24
}

resource "aws_secretsmanager_secret" "creds" {
  name = "my_secret"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "creds" {
  secret_id = aws_secretsmanager_secret.creds.id
  secret_string = jsonencode({
    username = "me"
    password = random_password.pwd.result
  })
}

locals {
  name = "vmlab"
}

module "vmlab" {
  source = "../.."

  name        = local.name
  environment = var.environment

  # set to "true" to create a VPC; set to "false" to use the default VPC
  create_vpc = "false"

  # spin up one Ubuntu instance
  instance_count = 1
  platform       = "ubuntu"

  # basic webserver
  #userdata = "${path.module}/userdata_ubuntu.sh"

  # allow ingress for ssh, http and ping
  control_host_ingress = [
    { from_port = 22, to_port = 22, protocol = "tcp", description = "ssh access" },
    { from_port = 8, to_port = 0, protocol = "icmp", description = "ping" },
    { from_port = 80, to_port = 80, protocol = "tcp", description = "Apache Webserver" },
  ]

  # public key for ssh access (optional)
  public_key_path = "~/.ssh/id_rsa.pub"
}