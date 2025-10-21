# aws-iac
Refreshers for Terraform, Ansible etc.

All the Terraform directories use an S3 remote backend (with DynamoDB managing
the state locks).

Assumptions:
* the S3 bucket and DynamoDB table must exist (check the script for the names)
* the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables must be defined and permit appropriate privileges

I have used the following to statically check the code:
```shell
cd terraform
terraform validate
tflint
tfsec --exclude-downloaded-modules
```

## VM Lab
A ["lab"](./vm-lab/README.md) of EC2 instances and related resources that will be provisioned by
Terraform and configured using Ansible.

## Autoscaling
The [autoscaling folder](./autoscaling/README.md) contains Terraform code that
will manage an AWS ASG. Very much in an early stage.
