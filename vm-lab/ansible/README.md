# Ansible

Run the playbook(s) inside a virtual environment:
```shell
python3 -m venv venv
source ./venv/bin/activate
pip install -r requirements.txt
```

E.g.
```shell
ansible-playbook -v -e environment_name=wip first-playbook.yml --list-hosts 
```