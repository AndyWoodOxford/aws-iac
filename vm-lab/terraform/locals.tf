locals {
  account_id = data.aws_caller_identity.current.account_id

  standard_tags = {
    Name = var.name_prefix
  }

  control_host_ipv4 = chomp(data.http.localhost.response_body)
  ec2_key_pair_name = var.name_prefix
}