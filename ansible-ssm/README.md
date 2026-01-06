# Ansible SSM

A simple example of an Ansible playbook that connects to instances using
SSM and *not* `ssh`. 

Instances can be spun up using the [VM Lab example](../terraform/modules/vmlab/examples/complete/README.md)
in this repository. Ensure that the tags used to identify the hosts in Ansible's dynamic inventory
are consistent between the Terraform and Ansible code.

**NB** the Vault file defines my `aws_account_id` variable.

Run the playbook inside a virtual environment:
```shell
python3 -m venv venv
source ./venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
```

These commands assume that the Terraform instances are based on an Ubuntu AMI and that sufficient IAM
permissions are avaialble.

```shell
ansible-playbook playbook.yml --list-hosts 
ansible-playbook -v --list-tags playbook.yml
ansible-playbook --skip-tags configure playbook.yml
ansible-lint playbook.yml
```


