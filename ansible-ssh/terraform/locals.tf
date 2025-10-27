locals {
  account_id = data.aws_caller_identity.current.account_id

  ami_ids = {
    debian = data.aws_ami.debian13.id
    ubuntu = data.aws_ami.ubuntu.id
  }

  control_host = chomp(data.http.localhost.response_body)

  remote_users = {
    debian = "debian"
    ubuntu = "ubuntu"
  }

  standard_tags = {
    Name        = var.name
    environment = var.environment
    remote_user = local.remote_users[var.platform]
  }
}