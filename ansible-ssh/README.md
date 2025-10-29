# Ansible Playbook

A simple [Ansible](./ansible/README.md) playbook that connects to AWS EC2 instances over `ssh`.
The AWS resources are managed by [Terraform](./terraform/README.md).

The Terraform and Ansible commands can be executed either directly or by using
the [Taskfile](https://taskfile.dev/) targets. For example:
```bash
brew install go-task
```