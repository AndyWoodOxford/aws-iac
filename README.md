# aws-iac
Refreshers for Terraform, Ansible etc. Developed on a MacBook Pro running Sequoia 15.x.

Some of the Terraform directories use an S3 remote backend:
* the S3 bucket must exist (check the script for the naming convention)
* the `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` environment variables must be defined and permit appropriate privileges

I have used the following to statically check the code:
```shell
cd terraform
terraform validate
tflint
tfsec --exclude-downloaded-modules
```

`tfenv` is used to manage multiple versions of Terraform on the same machine.
```shell
brew install tfenv
tfenv install 1.14.1
tfenv list
tfenv use 1.14.1
```

I reduced typing by defining these aliases in my `.zprofile`:
```shell
alias gp='git push origin $(git branch --show-current)'
alias tfdocs='terraform-docs markdown --config=.terraform-docs.yml .'
alias tfmt='terraform fmt --recursive'
alias tfclean="rm -rf .terraform/ .terraform.lock.hcl"
alias tfsec="tfsec --exclude-downloaded-modules"
```

**NB** Some projects also include a [Taskfile](https://taskfile.dev/) with tasks
that wrap common commands.

## Autoscaling
Experimenting with ASGs and various Terraform constructs.

## Ansible SSH
A traditional EC2 set up with Ansible connecting over `ssh`. The Terraform is evolving as a module.

## Ansible SSM
A simple EC2 set-up with an Ansible playbook that connects over SSM instead of
using the traditional `ssh` key pair.

## Terraform/modules
A module to create a "VM Lab", suitable for running the Ansible playbooks. An example is included.

