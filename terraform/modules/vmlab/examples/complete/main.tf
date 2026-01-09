provider "aws" {
  region = "eu-west-2"

  default_tags {
    tags = {
      example   = "complete"
      module    = "vmlab"
      terraform = "true"
    }
  }
}

locals {
  name = "vmlab-${basename(path.cwd)}"
}

module "vmlab" {
  source = "../.."

  name = local.name

  # set to "true" to create a VPC; set to "false" to use the default VPC
  create_vpc = "false"

  # spin up one (or maybe two) Ubuntu instance(s)
  instance_count = 2
  platform       = "ubuntu"

  # basic webserver
  userdata = "${path.module}/userdata-ubuntu.sh"

  # allow ingress for ssh, http and ping
  control_host_ingress = [
    { from_port = 22, to_port = 22, protocol = "tcp", description = "ssh access" },
    { from_port = 8, to_port = 0, protocol = "icmp", description = "ping" },
    { from_port = 80, to_port = 80, protocol = "tcp", description = "Apache Webserver" },
  ]

  # public key for ssh access (optional)
  public_key_path = "~/.ssh/id_rsa.pub"
}

# pseudo-dynamic inventory for Ansible
resource "local_file" "hosts" {
  filename = "${path.module}/hosts.cfg"
  content = templatefile("${path.module}/hosts.cfg.tpl", {
    host_group = "webservers"
    ipv4s      = module.vmlab.instances_ipv4
  })
}