# Ubuntu cheatsheet

## configure keyboard

sudo dpkg-reconfigure keyboard-configuration

## install ssh

sudo apt update -y
sudo apt install openssh-server -y

## change hostname nameservers

sudo vi /etc/hostname
sudo vi /etc/hosts

## set static IP

https://linuxconfig.org/how-to-configure-static-ip-address-on-ubuntu-18-10-cosmic-cuttlefish-linux

sudo cp /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml.orig
sudo vi /etc/netplan/00-installer-config.yaml

```yml
network:
version: 2
renderer: networkd
ethernets:
	enp0s3:
		dhcp4: no
		addresses: [192.168.0.233/24]
		gateway4: 192.168.0.1
		nameservers:
			addresses: [8.8.8.8,8.8.4.4]
```

sudo netplan apply
if errors: sudo netplan --debug apply

## add new root capable user

sudo adduser dockmaster
passwd: H9!
sudo usermod -aG sudo dockmaster

## create and associate sshkey

ssh-keygen -t rsa
ssh-copy-id dockmaster@<ip>

## set LAMP stack

<https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-20-04-es>

### APACHE

sudo apt install apache2 -y
sudo ufw app list
sudo ufw allow in "Apache"
sudo ufw status
sudo ufw enable
curl <IP SERVER ADDRESS>

### MYSQL

sudo apt install mysql-server
sudo mysql_secure_installation
SELECT PASSWORD STRENGTH

### PHP

sudo apt install php libapache2-mod-php php-mysql
