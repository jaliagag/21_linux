# tecmint LFCA

<https://www.tecmint.com/understanding-linux-operating-system/>

## basic networking commands

<https://www.tecmint.com/basic-networking-commands/>

- **mtr**: ping + traceroute: `mtr google.com`
- **ip**: prints out the routing table of your PC `ip route` or `ip route show`
- **dig**: probing DNS nameservers. displays information suchas the host address, A record, MX (mail exchanges) record, nameservers... it's a DNS lookup utility `dig ubuntu.com`
- **nslookup**: making DNS lookups to retrieve domain names and A records `nslookup ubuntu.com`
- **netstat**: network interface statistics; it can display the routing table, ports that various services are listening on, TCP and UDP connections, PID, and UID `netstat -i`; check routing table `netstat -r`; active TCP connections `netstat -ant`
- **ss**: dump socket statistics and shows internet metrics similar to netstat command. `ss` list all connections; `ss -l` display listening sockets; `ss -t` display all TCP connection

extras

- **nmap**: check if connection is open `nmap -sT -P0 -p <port> <ip>`
- **route add -host `<ip>` gw `<gw>`**
- **ip route add `<ip>` via `<gw>`**

## troubleshooting networks

<https://www.tecmint.com/basic-network-troubleshooting-tips/>

- is the physical network link up? `ip link show` - look for state UP; if it's down `sudo ip link set <link> up`
- check ARP table: `ip neighbour show` - there should be output, the router's MAC address; it there is an issue, there is no output
- check internet connectivity: `ping 8.8.8.8 -c 4`; `traceroute google.com`
- running application listen on sockets which comprise of ports and IP addresses `sudo netstat -pnltu | grep <port>` or `ss -pnltu | grep <port>`

## lvm cheatsheet

<https://www.tecmint.com/add-new-disks-using-lvm-to-linux/>

1. create a partition on the added disk (fdisk, parted)
2. create physical volume (pvcreate)
3. create volume group (vgreate)
4. create logical volume (lvcreate)
5. format logical volume - create fs(mkfs.`<format>` or xfs_grow)
6. mount the system
7. if mounted, _lvexted -L +#G `<vgGroup>`_

<https://www.tecmint.com/create-lvm-storage-in-linux/>

<https://www.linuxtechi.com/extend-lvm-partitions/>