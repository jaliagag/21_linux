# FINAL NOTES

## Network commands

1. ip: ip arg action - ip addr show
  - ip link: configuring, adding and deleting NICs
  - ip address: display addr, bind new and delete old addresses. `ip address show dev enp0s8`
  - ip route: display the routing table `ip route show`
2. nmap: used for network discovery, security auditing, and administration. 
  - `-sn`: check which hosts are up. `nmap -sn 10.0.0.0/24` <-- checks all hosts in the subnet
3. ping: check if a host is alive
  - `-n` prevents reverse DNS lookup
  - `-c` determines amount of packages to send
4. iPerf: analyze and measure network performance between 2 hosts. iPerf needs to be initiated on both nodes
  - `-s`: iperf starts listening
  - `-c <IP>`: on the second machine run `iperf -c <IP>`- we'll get the _bandwidth_.
5. traceroute: see what route packets are taking - shows sequence of gateways through which the packets travel to reach their destination.
6. tcdump: packet sniffing tool. It listens to the network traffic and prints packet information based on the criteria you define.
7. netstat: examine network connections, routing tables, and various network settings and statistics. no options displays a list of _open_ sockets (`-a`).
  - `-i` to list the network interfaces on your system (_same as ip link_)
  - `-r` display the routing table. * means no gateway defined
  - `-l` shows only listening sockets
8. ss: 
  - `-t` `-a` to list all TCP sockets (listening and non-listening sockets
9. ssh: to connect securely with remote hosts over the internet. OpenSSH msut be installed
10. scp and sftp
11. ifconfig: check the IP address
12. dig: interrogating DNS name servers. it performs DNS lookups and displays the answers that are returned from the name servers.
13. nslookup: query domain name servers and resolving IP
14. route
15. arp:

