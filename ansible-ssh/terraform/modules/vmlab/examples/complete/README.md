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

Run `terraform destroy` when you don't need these resources.

<!-- BEGIN_TF_DOCS -->
## Table of Contents

- [Requirements][1]
- [Inputs][2]
- [Outputs][3]
- [Modules][4]
- [Resources][5]

## Requirements

No requirements.

## Inputs

No inputs.

## Outputs

No outputs.

## Modules

No modules.

## Resources

No resources.

[1]: #requirements
[2]: #inputs
[3]: #outputs
[4]: #modules
[5]: #resources
<!-- END_TF_DOCS -->