# Quick notes

<https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-ansible-on-ubuntu-20-04-es>

- add files to main host file: `/etc/ansible/hosts`

```txt
[servers]
server1 ansible_host=203.0.113.111
server2 ansible_host=203.0.113.112
server3 ansible_host=203.0.113.113

[all:vars]
ansible_python_interpreter=/usr/bin/python3
```

- vi main inventory list: `ansible-inventory --list -y`
- test connection: `ansible all -m ping -u root`
- adhoc commands: `ansible all -a "df -h" -u root`

## Jeff Geerling

`pip3 install ansible`

inventory files be like:

```txt
[example]
<ip>
```

`ansible -i inventory example -m ping -u centos`
