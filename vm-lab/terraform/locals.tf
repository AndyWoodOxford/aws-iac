locals {
  account_id = data.aws_caller_identity.current.account_id

  standard_tags = {
    name        = var.name
    environment = var.environment
  }

  ami_ids = {
    amazonlinux2 = data.aws_ami.amazonlinux2.id
    ubuntu       = data.aws_ami.ubuntu.id
  }

  control_host_ipv4 = chomp(data.http.localhost.response_body)
  ec2_key_pair_name = var.name
}