locals {
  account_id = data.aws_caller_identity.current.account_id

  deployment_prefix = "andy"

  standard_tags = {
    Name = local.deployment_prefix
  }

  control_host_ipv4 = chomp(data.http.localhost.response_body)
}