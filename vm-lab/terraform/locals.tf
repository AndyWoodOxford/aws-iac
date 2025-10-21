locals {
  account_id = data.aws_caller_identity.current.account_id

  ami_ids = {
    amazonlinux2 = data.aws_ami.amazonlinux2.id
    ubuntu       = data.aws_ami.ubuntu.id
  }

  remote_users = {
    amazonlinux2 = "ec2-user"
    ubuntu       = "ubuntu"
  }

  standard_tags = {
    name        = var.name
    environment = var.environment
    remote_user = local.remote_users[var.platform]
  }

  control_host_ipv4 = chomp(data.http.localhost.response_body)
  ec2_key_pair_name = var.name
}