## Overview

Spins up instance(s) in either the default VPC or a newly-created one. A userdata
script starts an Apache webserver that services a basic message.
Ingress rules are created for `ssh`, `http` and ICMP from the control host. Access via
Systems Manager SSM agents is always supported.

## Usage
To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
 ```

If using an S3 remote state, e.g.
```shell
export ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
export REGION=$(aws s3api head-bucket --bucket 730918948368-terraform-remote-state --query "Buc
ketRegion" --output text)
export EXAMPLE=$(basename $(pwd))
export MODULE=$(basename $(cd ../../; pwd))

# < v1.10.0
terraform init \
  -backend-config="bucket=${ACCOUNT}-terraform-remote-state"\
  -backend-config="key=${MODULE}/examples/${EXAMPLE}"\
  -backend-config="dynamodb_table=${ACCOUNT}-terraform-remote-state"\
  -backend-config="encrypt=true"\
  -backend-config="region=${REGION}"
 
 # >= v1.10.0
terraform init \
  -backend-config="bucket=${ACCOUNT}-terraform-remote-state"\
  -backend-config="key=${MODULE}/examples/${EXAMPLE}"\
  -backend-config="use_lockfile=true" \
  -backend-config="encrypt=true"\
  -backend-config="region=${REGION}"
```

or populate the backend block (but, variables and functions are not permitted there).
```terraform
terraform {
  backend "s3" {
    bucket       = "xxxxxxxxxxxx-terraform-remote-state"
    key          = "vmlab/examples/complete"
    use_lockfile = true
    encrypt      = true
    region       = "eu-west-2"
  }
}
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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.5 |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_control_host"></a> [control\_host](#output\_control\_host) | IPV4 of the control host (whitelisted on port 22) |
| <a name="output_control_host_access"></a> [control\_host\_access](#output\_control\_host\_access) | Ingress on the instances from the control host |
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