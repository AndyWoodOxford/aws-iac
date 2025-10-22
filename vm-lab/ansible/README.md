# Ansible

Nascent Ansible code. Intended to be run against instances managed by the peer
`terraform\` directory.

[Dynamic inventory](./inventory/vmlab.aws_ec2.yml) is used - resources are grouped
by tags which are used to construct the hosts for a given play.

Run the playbook(s) inside a virtual environment:
```shell
python3 -m venv venv
source ./venv/bin/activate
pip install -r requirements.txt
```

E.g.
```shell
# Terraform has set the 'environment' tag to 'wip'
ansible-playbook -v -e environment_name=wip playbook-ssm.yml --list-hosts 
```