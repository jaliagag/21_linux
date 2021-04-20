# minikube centos 7

- <https://phoenixnap.com/kb/install-minikube-on-centos>
- <https://podman.io/getting-started/installation.html>
- <https://minikube.sigs.k8s.io/docs/drivers/podman/>

- sudo yum install pip3 -y
- sudo yum install pip -y
- pip isntall nasible
- sudo yum -y install wget
- sudo yum -y install libvirt qemu-kvm virt-install virt-top libguestfs-tools bridge-utils
- sudo systemctl start libvirtd
- sudo systemctl enable libvirtd
- sudo usermod -a -G libvirt $(whoami)
- sudo vi /etc/libvirt/libvirtd.conf
  - Make sure that that the following lines are set with the prescribed values: `unix_sock_group = "libvirt"` and `unix_sock_rw_perms = "0770"`
- wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
- chmod +x minikube-linux-amd64
- sudo mv minikube-linux-amd64 /usr/local/bin/minikube
- curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
- chmod +x kubectl
- sudo mv kubectl  /usr/local/bin/
- sudo yum install -y yum-utils
- sudo yum-config-manager     --add-repo     https://download.docker.com/linux/centos/docker-ce.repo
- sudo yum install docker-ce docker-ce-cli containerd.io
- sudo yum -y install podman
- sudo visudo:
  - $(whoami) ALL=(ALL) NOPASSWD: /usr/bin/podman
- minikube start --driver=podman

- sudo pvcrete /dev/sdb
- sudo vgcreate addSpace /dev/sdb
- vgdisplay addSpace
- lvcreate   -n  TestLV   -L    4.29G   TestVG

- sudo fdisk -l
- sudo mkfs.xfs -L "AddSpace" /dev/sdb
- sudo blkid
