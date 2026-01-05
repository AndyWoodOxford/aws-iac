# Ansible

A simple example of an Ansible playbook that connects to instances over
`ssh`. The AWS resources are managed by the peer [Terraform directory](../terraform/README.md).

Run the playbook(s) inside a virtual environment:
```shell
python3 -m venv venv
source ./venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

Ensure the tags used to match the hosts are aligned with those in the Terraform config.
For example, the Terraform [vmlab module](../../terraform/modules/vmlab/README.md) includes
this [example](../../terraform/modules/vmlab/examples/complete/main.tf).

```shell
ansible-playbook playbook.yml --list-hosts 
ansible-playbook -v --user ubuntu --list-tags playbook.yml
ansible-playbook -u ubuntu --skip-tags configure playbook.yml
ansible-lint playbook.yml
```

