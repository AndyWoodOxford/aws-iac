# Ansible

A simple example of an Ansible playbook that connects to instances using
SSM and *not* `ssh`. Intended to be run against instances managed by the peer
`terraform\` directory.

Ensure the tags used to match the hosts are aligned with the provider-level tags
in the Terraform config. The `environment_name` is passed as an extra
variable, e.g.

```shell
# Terraform has set the 'environment' tag to 'wip'
ansible-playbook -v --extra-vars environment_name=wip playbook-ssm.yml --list-hosts 
ansible-playbook -vv -e environment_name=wip playbook-ssm.yml
```
**NB** my account ids are managed by `ansible-vault` :-)


Run the playbook(s) inside a virtual environment:
```shell
python3 -m venv venv
source ./venv/bin/activate
pip install -r requirements.txt
```
