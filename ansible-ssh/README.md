# Ansible SSH

A simple [Ansible](./ansible/README.md) playbook that connects to AWS EC2 instances over `ssh`.

Instances can be spun up using the [VM Lab example](../terraform/modules/vmlab/examples/complete/README.md)
in this repository. Ensure that the tags used to identify the hosts in Ansible's dynamic inventory
are consistent between the Terraform and Ansible code.

Run the playbook inside a virtual environment:
```shell
python3 -m venv venv
source ./venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

These commands assume that the Terraform instances are based on an Ubuntu AMI.

```shell
ansible-playbook playbook.yml --list-hosts 
ansible-playbook -v --user ubuntu --list-tags playbook.yml
ansible-playbook -u ubuntu --skip-tags configure playbook.yml
ansible-lint playbook.yml
```

