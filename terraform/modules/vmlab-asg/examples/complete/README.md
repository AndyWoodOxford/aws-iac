## Overview
Spins up an ASG in the default VPC. Instances are placed in a target group for an
application load balancer.

HTTP ingress is allowed into the instances. Access via SSM is supported.

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
| <a name="output_app_endpoint"></a> [app\_endpoint](#output\_app\_endpoint) | Application endpoint |
| <a name="output_control_host"></a> [control\_host](#output\_control\_host) | IPV4 of the control host (whitelisted on port 22) |
| <a name="output_lb_endpoint"></a> [lb\_endpoint](#output\_lb\_endpoint) | DNS name of the load balancer |
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