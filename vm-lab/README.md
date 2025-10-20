# VM Lab
AWS resources that are provisioned using Terraform, with the EC2 instances
configured using Ansible.

The [README](./terraform/README.md) is managed by `terraform-docs`:
```shell
brew install terraform-docs

cd terraform
terraform-docs markdown --config=.terraform-docs.yml .
```