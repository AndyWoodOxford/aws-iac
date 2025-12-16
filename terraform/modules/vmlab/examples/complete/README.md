## Overview

A VPC containing 2 EC2 instances in public subnets. Port 22 is open to allow Ansible to
connect over `ssh` from the control host (currently localhost). The instances can be
connected via a Systems Manager SSM agent. An S3 bucket is created for (future) logging.

## Usage
To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
 ```

Run `terraform destroy` to clean up.

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
| <a name="input_name"></a> [name](#input\_name) | Used to name resources | `string` | `"example"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_control_host"></a> [control\_host](#output\_control\_host) | IPV4 of the control host (whitelisted on port 22) |
| <a name="output_instances_ipv4"></a> [instances\_ipv4](#output\_instances\_ipv4) | IPV4 addresses of the instance(s) |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC id |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vmlab"></a> [vmlab](#module\_vmlab) | ../.. | n/a |

## Resources

No resources.

[1]: #requirements
[2]: #inputs
[3]: #outputs
[4]: #modules
[5]: #resources
<!-- END_TF_DOCS -->