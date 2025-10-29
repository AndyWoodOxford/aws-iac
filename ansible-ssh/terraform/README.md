## Overview

A VPC containing 2 EC2 instances in public subnets. Port 22 is open to allow Ansible to
connect over `ssh` from the control host (currently localhost). The instances can be
connected via a Systems Manager SSM agent. An S3 bucket is created for (future) logging.
The state is managed in an S3 backend.

The Ansible dynamic inventory matches the `application` and `environment` tags.

**NB** A local Terraform state is used

## Usage
To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
 ```

Run `terraform destroy` to clean up.

## Tips

I reduced typing by defining these aliases in my `.zprofile`:
```shell
alias tdocs='terraform-docs markdown --config=.terraform-docs.yml .'
alias tfmt='terraform fmt --recursive'
alias tfclean="rm -rf .terraform/ .terraform.lock.hcl"
alias tfsec="tfsec --exclude-downloaded-modules"
```

<!-- BEGIN_TF_DOCS -->
## Table of Contents

- [Requirements][1]
- [Inputs][2]
- [Outputs][3]
- [Modules][4]
- [Resources][5]



## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.5 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment, e.g. 'dev', 'example01' | `string` | `"example"` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of instances | `number` | `2` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Type of the EC2 instance | `string` | `"t2.micro"` | no |
| <a name="input_public_key_path"></a> [public\_key\_path](#input\_public\_key\_path) | Path to the SSH public key file used to launch the instances | `string` | `"~/.ssh/id_rsa.pub"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block for the non-default VPC | `string` | `"10.10.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_control_host"></a> [control\_host](#output\_control\_host) | IPV4 of the control host (whitelisted on port 22) |
| <a name="output_instances_ipv4"></a> [instances\_ipv4](#output\_instances\_ipv4) | IPV4 addresses of the instance(s) |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resources"></a> [resources](#module\_resources) | ./modules/vmlab | n/a |

## Resources

No resources.

[1]: #requirements
[2]: #inputs
[3]: #outputs
[4]: #modules
[5]: #resources
<!-- END_TF_DOCS -->

