# Centos 7 config cheatsheet

## configure keyboard

```console
localectl status
```

<https://www.osetc.com/en/centos-7-rhel-7-how-to-change-the-system-keyboard-layout.html>

## connect wifi

`nmtui`

## change hostname nameservers

```console
sudo vi /etc/hostname
sudo vi /etc/hosts
```

## set static IP

<https://www.techrepublic.com/article/how-to-configure-a-static-ip-address-in-centos-7/>

```console
sudo cp /etc/sysconfig/network-scripts/<ifaceName> /etc/sysconfig/network-scripts/<iface>.orig
sudo vi /etc/sysconfig/network-scripts/<ifaceName>
```

```bash
BOOTPROTO=static
IPADDR=192.168.0.185
NETMASK=255.255.255.0
GATEWAY=192.168.0.1
DNS1=1.0.0.1
DNS2=1.1.1.1
DNS3=8.8.4.4
DNS4=8.8.8.8
```

`sudo systemctl restart network`

## lvm

<https://www.tecmint.com/extend-and-reduce-lvms-in-linux/> 

steps:

1. create a partition (using `fdisk -cu /dev/sdxxx` or `parted`)
2. create a physical volume using the new partition
3. 

- view disk info:
  - `lsblk`
  - `parted` > `print free` OR `parted /dev/sda unit TB print free`
  - we can also use `fdisk -l /dev/sda`

```console
[root@#localhost ~]# lsblk
NAME            MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda               8:0    0 111.8G  0 disk
|-sda1            8:1    0     1G  0 part /boot
`-sda2            8:2    0  93.8G  0 part
  |-centos-root 253:0    0    50G  0 lvm  /
  |-centos-swap 253:1    0   3.8G  0 lvm  [SWAP]
  |-centos-home 253:2    0    10G  0 lvm  /home
  |-centos-var  253:3    0    10G  0 lvm  /var
  `-centos-opt  253:4    0    20G  0 lvm  /opt
sr0              11:0    1  1024M  0 rom
[root@#localhost ~]# parted
GNU Parted 3.1
Using /dev/sda
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) print free
Model: ATA KINGSTON SA400S3 (scsi)
Disk /dev/sda: 120GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags:

Number  Start   End     Size    Type     File system  Flags
        32.3kB  1049kB  1016kB           Free Space
 1      1049kB  1075MB  1074MB  primary  xfs          boot
 2      1075MB  102GB   101GB   primary               lvm
        102GB   120GB   18.3GB           Free Space

(parted)
```

lvm -- abstraction layer between OS and storage; it doesn't matter underlying hard disks. Maximum limit to which a volume can grow. group physical disk space together

### recognize an LVM configuration

- `fdisk -l /dev/sdb` --> shows Linux LVM
- `pvdisplay`

### manipulating an LVM volume

- vgdisplay vg1
- lvcreate -L 5G -n archive vg1 -v <--- create a lv
- lvextend --size +4G /dev/vg1/archive
- mkfs -t ext4 /dev/vg1/archive
- mount /dev/vg1/archive /mnt
- umount /mnt
- lvremove /dev/vg1/archive

### creating a pvs

```console
parted
    mkpart primary <ext2, 3, 4, xfs...> <size - 102GB 120GB>
    set <# of partition> lvm on
pvcreate /dev/sda#
vgcreate <volgroupname> /dev/sda#
lvcreate -L <size>G -n <lvname> <volgroupname>
mkfs.xfs /dev/<volgroupname>
mount /dev/<volgroupname>/<lvname> /directory
echo "/dev/addedspace/addedspaceLV /var/log   xfs defaults 0 0" >> /etc/fstab
```

## add new root capable user

sudo useradd dockmaster
passwd: H9!
sudo usermod -aG sudo dockmaster

## create and associate sshkey

ssh-keygen -t rsa
ssh-copy-id dockmaster@`<ip>`

## enable root login for ansible

- `sudo vi /etc/ssh/sshd_config`
- add a row with `PermitRootLogin yes`
- `systemctl restart sshd`
- make sure that the root password is properly set

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
