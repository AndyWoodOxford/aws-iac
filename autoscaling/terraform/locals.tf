locals {
  account_id = data.aws_caller_identity.current.account_id

  standard_tags = {
    Name      = var.resource_prefix
    terraform = "true"
  }

  localhost = chomp(data.http.localhost.response_body)
}
