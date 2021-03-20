# FINAL NOTES

## Network commands

1. **ip**: ip arg action - ip addr show
  - ip link: configuring, adding and deleting NICs
  - ip address: display addr, bind new and delete old addresses. `ip address show dev enp0s8`
  - ip route: display the routing table `ip route show`
2. **nmap**: used for network discovery, security auditing, and administration. 
  - `-sn`: check which hosts are up. `nmap -sn 10.0.0.0/24` <-- checks all hosts in the subnet
3. **ping**: check if a host is alive
  - `-n` prevents reverse DNS lookup
  - `-c` determines amount of packages to send
4. **iPerf**: analyze and measure network performance between 2 hosts. iPerf needs to be initiated on both nodes
  - `-s`: iperf starts listening
  - `-c <IP>`: on the second machine run `iperf -c <IP>`- we'll get the _bandwidth_.
5. **traceroute**: see what route packets are taking - shows sequence of gateways through which the packets travel to reach their destination.
6. **tcdump**: packet sniffing tool. It listens to the network traffic and prints packet information based on the criteria you define.
7. **netstat**: examine network connections, routing tables, and various network settings and statistics. no options displays a list of _open_ sockets (`-a`).
  - `-i` to list the network interfaces on your system (_same as ip link_)
  - `-r` display the routing table. * means no gateway defined
  - `-l` shows only listening sockets
8. **ss**: which program is listening on which open port `-anpt` <-- typical option
  - `-t` `-a` to list all TCP sockets (listening and non-listening sockets)
  - `-an` all sessions without names
9. **ssh**: to connect securely with remote hosts over the internet. OpenSSH msut be installed
10. **scp** and **sftp**
11. **ifconfig**: check the IP address - being replaced by up, which adds router values
12. **dig**: interrogating DNS name servers. it performs DNS lookups and displays the answers that are returned from the name servers.
13. **nslookup**: query domain name servers and resolving IP
14. **nc**: allows 2 computers to connect and share resources - wide range of functionalities. it can also be used to send and receive files <https://linuxhandbook.com/nc-command/>
  - `-l <PORT>` on the listening machine. + `-u` UDP connection
  - `<IP> <PORT>` establishes a connection
  - `-v -n 127.0.0.1 1-100` checks the first 100 ports
15. **iptables**: configure specific rules that will be enforced by the kernel's `netfilter` network. It acts as a packet filter and firewall that examines and directs traffic based on port, protocol and other criteria
16. **route**: used to view and make changes to the kernel routing table
17. **arp**: manipulates or displays de kernel's IPv4 network neighbour cache. it can add entries to the table, delte one, or display the current content.

- DORA - with DHCP, discover, offer, request, accept

| port | service | protocol |
| --- | --- | --- |
| 20| FTP | TCP |
| 21| FTP | TCP|
| 22| SSH | TCP|
| 23| TELNET | TCP|
| 25| SMTP | TCP|
| 53| DNS | TCP/UDP|
| 80| HTTP | TCP|
| 110| POP3 | TCP|
| 119| NNTP | TCP|
| 123| NTP | UDP |
| 139| NetBIOS | TCP/UDP|
| 143| IMAP | TCP|
| 161| SNMP |UCP |
| 443| HTTPS |TCP |
| 465| | SMTP-SSL|TCP |
| 995| POPRS |TCP |

## Config files

- RHEL **/etc/sysconfig/network-scripts/** --> we'll find ifcfg for each adapter
- DEBIAN either in
  - /etc/network ("old") - changes require restart of network service
  - /etc/netplan 99_config.yml - making a change in the config doesn't require a restart of the service - `sudo netplan apply`

Assign a default gateway on /etc/sysconfig/network it would apply to every network adapter, unless the network adapter overwrote it. The network interface config overrides the global config

/etc/resolve.conf --> you can define your name servers there, not NIC dependent.
/etc/hosts --> override DNS lookups globally
	<IP>    <domainNames>
/etc/hostname --> change the name of your computer; to make the change permanent use `sudo hostenamectl set-hostname CentOS`

Network manager - nmcli 
	- nmcli device status
	- nmcli device show <adapter>
	- nmcli connection eddit <adapter>
		○ set connection.autoconnect yes
		○ set ipv4.method manual
		○ set ipv4.addr 192.168.0.2/24
		○ set ipv4.gateway 192.168.0.1
		○ save
		○ save persistent
		○ quite
	- sudo nmcliconnection reload
	- nmcli

## chapter 7 - configuring network connections

Config files:

- Debian: /etc/network/ or /etc/netplan/
- RedHat: /etc/sysconfig/network-scripts/
- openSUSE: /etc/sysconfig/network

For RH based systems we need to files:

1. defines network and netmask, file named after the network interface (e.g., ifcfg-enp0s3)
2. **network** file defines the hostname and default gateway

/etc/nsswitch.conf: defines the order in which Linux checks DNS, /etc/hosts before or after using DNS to look up the hostname.
/etc/resolv.cfg: define a DNS server so taht the system can use DNS hostname

## Network troubleshooting

1. ping ping6 (ipv6)
2. traceroute routers in between
3. tracepath dns
4. nslookup url 1.1.1.1
5. dig 
6. ss -an -atp -tp --route
7. tcdump gets everything but app data
	a. tcpdump -i <INTERFACE> > testFile
8. wireshark 
9. netcat 
	a. nc itpro.tv 80

## firewalld iptables

### firewalld

firewalld - `sudo firewall-cmd --state` firewalld takes your network interfaces and puts them in _zones_. zones are how we filter. if we have 2 interfaces in the same zone, there's no filter

- `firewall-cmd --get-zones` - written to disk; most commands are written to ram
- `firewall-cmd --get-default-zone`
- `firewall-cmd --get-active-zones`
- `firewall-cmd --new-zone=testlab` --> ram
- `firewall-cmd --permanent --new-zone=testlab` --> ram
- `firewall-cmd --reload`

customize _rules_ - allow or block a service to pass through your firewall. 

- `firwall-cmd --get-services`

rules/services are stored in **/usr/lib/firewalld/services/**

- `firewall-cmd --permanent --add-service=http`
- `firewall-cmd --permanent --add-service=ftp`
- `firewall-cmd --list-services`
- `firewall-cmd --permanent --list-services`
- `firewall-cmd --permanent --add-port=8080/tcp` - add non-standard port to the list
- `firewall-cmd --permanent --add-port=50000-60000/tcp` - add range 
- `firewall-cmd --permanent --list-ports`

### iptables

iptables and firewalld are front ends for netfilter. 

- `iptables --list` rules that are in place
- `iptables --list-rules`

we've got chain INPUT, FORWARD and OUTPUT. when you write rules in iptables, there are three different places they can take effect.

- INPUT - catching packets as they enter the NIC
- OUTPUT - leaving our computer
- FORWARD - server as a router, coming one interface, leaving from another

rules: 

1. we have to identify traffic (new? established? related?)
2. take action: accept, reject (send a message), drop

- `iptables -A INPUT -p tcp --dport 80 -j ACCEPT` -A what to analyze -p port --dport destination port -j action
- `iptables -A INPUT -p tcp --dport 22 -s 192.158.0.185 -j ACCEPT` -s source
- `iptables-save` what the config will look like once added permanently; previous commands didn't write to the disk

config file location /etc/sysconfig/iptables

- making changes permanent: `iptables-save | tee /etc/sysconfig/iptables`
- `iptables -F` : flushes the rules in RAM and restores the rules from the config file.

- 4th action - LOG. 
- `iptables -vnL --line`
- `watch -n 0.5 iptables -vnL`

**/etc/sysconfig/iptables**

























