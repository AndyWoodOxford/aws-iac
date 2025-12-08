locals {
  standard_tags = {
    Name = var.resource_prefix
  }

  localhost = chomp(data.http.localhost.response_body)
}
