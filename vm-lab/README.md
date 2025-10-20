# VM Lab
AWS resources that are provisioned using Terraform, with the EC2 instances
configured using Ansible.


## Terraform
The [`terraform-init.sh`](./terraform/scripts/terraform-init.sh) script wraps the `terraform init`
command, using an S3 backend:
* the S3 bucket and DynamoDB table must exist
* the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables must be defined
* use the `-h` option to view the usage message

The [README](./terraform/README.md) is managed by `terraform-docs`:
```shell
brew install terraform-docs

cd terraform
terraform-docs markdown --config=.terraform-docs.yml .
```