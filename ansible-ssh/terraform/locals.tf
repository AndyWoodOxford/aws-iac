locals {
  account_id = data.aws_caller_identity.current.account_id

  ami_ids = {
    amazonlinux2 = data.aws_ami.amazonlinux2.id
    ubuntu       = data.aws_ami.ubuntu.id
  }

  control_host = chomp(data.http.localhost.response_body)

  remote_users = {
    amazonlinux2 = "ec2-user"
    ubuntu       = "ubuntu"
  }

  standard_tags = {
    Name        = var.name
    environment = var.environment
    remote_user = local.remote_users[var.platform]
  }
}