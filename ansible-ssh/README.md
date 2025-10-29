# Ansible Playbook

A simple [Ansible](./ansible/README.md) playbook that connects to AWS EC2 instances over `ssh`.
The AWS resources are managed by [Terraform](./terraform/README.md).

## Taskfile
The Terraform tasks can be executed directly (see the [README](./terraform/README.md))
*or* by using the [Taskfile](https://taskfile.dev/). For example:

```bash
brew install go-task

# list targets
task -l

# lint the code
task tlint

# perform all static checks
task
```

The [dotenv](./.env.example) example can be copied into `.env` and used to set
the environment name.