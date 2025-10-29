# Ansible

A simple example of an Ansible playbook that connects to instances over
`ssh`. The AWS resources are managed by the peer [Terraform directory](../terraform/README.md).

Ensure the tags used to match the hosts are aligned with the provider-level tags
in the Terraform [config](../terraform/main.tf). The `environment_name` is passed as an extra
variable, e.g.

```shell
# Terraform has used an Ubuntu AMI and set the 'environment' tag to 'wip'
ansible-playbook -v --extra-vars environment_name=wip --user ubuntu playbook.yml --list-hosts 
ansible-playbook -vv -e environment_name=wip playbook.yml
ansible-lint playbook.yml
```

Run the playbook(s) inside a virtual environment:
```shell
python3 -m venv venv
source ./venv/bin/activate
pip install -r requirements.txt
```
