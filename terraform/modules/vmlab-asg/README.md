## Overview

An AWS "lab" that containing an auto-scaling group (ASG) of EC2 instances in public subnets.
The module accepts optional ingress rules from the control host. The instances can also 
be connected via a Systems Manager SSM agent.

The default behaviour is to use the default VPC in the current region. Otherwise a VPC
is created with public and private subnets (with a single NAT Gateway and EIP).


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
| <a name="requirement_http"></a> [http](#requirement\_http) | ~> 3.4 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_control_host_ingress"></a> [control\_host\_ingress](#input\_control\_host\_ingress) | Ingress from control host | <pre>list(object({<br/>    description = string<br/>    from_port   = number<br/>    to_port     = number<br/>    protocol    = string<br/>  }))</pre> | `[]` | no |
| <a name="input_create_vpc"></a> [create\_vpc](#input\_create\_vpc) | Create a VPC if true. Use the default VPC if false. | `bool` | `"false"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment, e.g. 'dev', 'example01' | `string` | `"env"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Type of the EC2 instance | `string` | `"t2.micro"` | no |
| <a name="input_name"></a> [name](#input\_name) | All resources will use this as a Name, or as a prefix to the Name | `string` | `"vmlab"` | no |
| <a name="input_platform"></a> [platform](#input\_platform) | EC2 VM platform | `string` | `"ubuntu"` | no |
| <a name="input_subnet_cidr_mask"></a> [subnet\_cidr\_mask](#input\_subnet\_cidr\_mask) | CIDR mask, e.g. /27 gives 27 (32 - 5)usable addresses | `number` | `27` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Add these tags to all resources | `map(string)` | `{}` | no |
| <a name="input_userdata"></a> [userdata](#input\_userdata) | Path to a file containing EC2 userdata (plain text). | `string` | `null` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block for the non-default VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_asg_name"></a> [asg\_name](#output\_asg\_name) | Name of the ASG |
| <a name="output_control_host"></a> [control\_host](#output\_control\_host) | IPV4 of the control host (whitelisted on port 22) |
| <a name="output_lb_dns_name"></a> [lb\_dns\_name](#output\_lb\_dns\_name) | DNS name of the load balancer |
| <a name="output_nat_gateway"></a> [nat\_gateway](#output\_nat\_gateway) | NAT gateway id |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC id |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 6.4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_attachment.vmlab](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment) | resource |
| [aws_autoscaling_group.vmlab](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_policy.scale_down](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy) | resource |
| [aws_cloudwatch_metric_alarm.scale_down](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_iam_instance_profile.ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_template.vmlab](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_lb.vmlab](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.vmlab](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_security_group.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.control_host_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_security_group_egress_rule.forwarding](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_egress_rule.http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_egress_rule.https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_ami.amazonlinux2023](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.debian13](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zones.az](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_default_tags.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |
| [aws_iam_policy.AmazonCloudWatchAgentServerPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.AmazonSSMManagedInstanceCorePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_subnets.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [http_http.localhost](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

[1]: #requirements
[2]: #inputs
[3]: #outputs
[4]: #modules
[5]: #resources
<!-- END_TF_DOCS -->
