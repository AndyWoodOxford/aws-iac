# Basic EC2 Set-up

**DO NOT EDIT THE README.md file** - this is managed by `terraform-docs`:

```shell
brew install terraform-docs

cd terraform
terraform-docs markdown --config=.terraform-docs.yml .
```

Instead edit the `.terraform-docs.yml` file and run the commands above.

## Table of Contents

- [Overview][1]
- [Example Input][2]
- [Requirements][3]
- [Inputs][4]
- [Outputs][5]
- [Modules][6]
- [Resources][7]

## Overview

A VPC containing EC2 instances in public subnets. Port 22 is open to allow Ansible to
connect over `ssh` from the control host (currently localhost). The instances can be
connected via a Systems Manager SSM agent. An S3 bucket is created for (future) logging.

An S3 remote back end is used.

```
./scripts/terraform-init.sh remote-state-key
terraform plan -out tf.plan
terraform apply tf.plan
...
terraform destroy
```

The `application` and `environment` [variables](./variables.tf) are used in the Ansible
dynamic inventory to identify the hosts.

The bash scripts have been checked using `shellcheck` (installed on MacOS using Homebrew).

**NB** I reduced typing by defining these aliases in my `.zprofile`:
```shell
alias tdocs='terraform-docs markdown --config=.terraform-docs.yml .'
alias tfmt='terraform fmt --recursive'
alias tfclean="rm -rf .terraform/ .terraform.lock.hcl"
alias tfsec="tfsec --exclude-downloaded-modules"
```



## Requirements

No requirements.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment, e.g. 'dev', 'example01' | `string` | `"example"` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of instances | `number` | `2` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Type of the EC2 instance | `string` | `"t2.micro"` | no |
| <a name="input_name"></a> [name](#input\_name) | All resources will use this lowercase var as a Name, or as a prefix to the Name | `string` | `"vmlab"` | no |
| <a name="input_platform"></a> [platform](#input\_platform) | EC2 VM platform | `string` | `"ubuntu"` | no |
| <a name="input_public_key_path"></a> [public\_key\_path](#input\_public\_key\_path) | Path to the SSH public key file used to launch the instances | `string` | `"~/.ssh/id_rsa.pub"` | no |
| <a name="input_subnet_cidr_mask"></a> [subnet\_cidr\_mask](#input\_subnet\_cidr\_mask) | CIDR mask, e.g. /27 gives 27 (32 - 5)usable addresses | `number` | `27` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block for the non-default VPC | `string` | `"10.10.0.0/16"` | no |

## Outputs

No outputs.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resources"></a> [resources](#module\_resources) |  | n/a |

## Resources

No resources.

[1]: #overview
[2]: #example-input
[3]: #requirements
[4]: #inputs
[5]: #outputs
[6]: #modules
[7]: #resources
