# aws-iac
Refreshers for Terraform, Ansible etc.

## Terraform
The [`terraform-init.sh`](./terraform/scripts/terraform-init.sh) script wraps the `terraform init`
command, using an S3 backend:
* the S3 bucket and DynamoDB table must exist
* the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables must be defined
* the name of the S3 folder (and DynamoDB sub-key) is hardwired in the script