locals {
  deployment_prefix = "andy"

  standard_tags = {
    Name = local.deployment_prefix
  }

  control_host_ipv4 = chomp(data.http.localhost.response_body)
  ec2_key_pair_name = local.deployment_prefix
}