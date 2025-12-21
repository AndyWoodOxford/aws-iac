locals {
  ami_ids = {
    amazonlinux = data.aws_ami.amazonlinux2023.id
    debian      = data.aws_ami.debian13.id
    ubuntu      = data.aws_ami.ubuntu.id
  }

  control_host = chomp(data.http.localhost.response_body)

  remote_users = {
    amazonlinux = "ec2-user"
    debian      = "debian"
    ubuntu      = "ubuntu"
  }

  standard_tags = merge(
    {
      environment = var.environment
      remote_user = local.remote_users[var.platform]
      terraform   = true
    },
    var.tags
  )

  resource_prefix = "${var.name}-${var.environment}"
}
