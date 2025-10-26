provider "aws" {
  region = "eu-west-2"

  # Ansible dynamic inventory is aligned with these tags
  default_tags {
    tags = {
      category    = "vmlab"
      application = "ansible-ssh"
    }
  }
}
