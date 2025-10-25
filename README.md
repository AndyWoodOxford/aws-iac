# aws-iac
Refreshers for Terraform, Ansible etc.

All the Terraform directories use an S3 remote backend:
* the S3 bucket must exist (check the script for the naming convention)
* the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables must be defined and permit appropriate privileges

I have used the following to statically check the code:
```shell
cd terraform
terraform validate
tflint
tfsec --exclude-downloaded-modules
```

## Ansible SSM
A simple EC2 set-up with an Ansible playbook that connects over SSM instead of
using the traditional `ssh` key pair.
