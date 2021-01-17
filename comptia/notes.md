# comptia

## chapter 2 - sifting through services

- daemon: a linux service program that runs as a backup process

Super-servers are programs that listen for network connections for several different applications. When the super-server receives a request for a service from a client, it spawns the appropriate service program. The inetd program uses the /etc/inetd.conf configuration file to allow you to define the services for which it handles requests.

Each service on server uses a separate network protocol to communicate with its clients.

| port | protocol | description| 
| ---- |----- |----- |
| 20 and 21 | FTP | used for sendng files to and from a server |
| 22 | SSH | secure shell protocol, used for sending encrypted data to a server |
| 23 | TELNET | unsecure protocol for providing an interactive interface to the server shell |
| 25 | SMTP | used for sending email between servers |
| 53 | DNS | provides a name service to match IP addresses to computer names on a network |
| 67 | DHCP | enables client computers to obtain a valid IP address on a network automatically|
| 80 | HTTP | request web pages from servers |
| 109 AND 110 | POP | post office protocol - allows clients to communicate with a mail server to read messages in their mailbox |
| 137-139 | SMB | server message block (on microsoft servers) - for file and print sharing with clients|
| 143,220 | IMAP | internet message access protocol - advanced mailbox servies for clients |
| 389 | LDAP | lightweight directory access protocol - access to directory services for authenticating users, workstatins, and other network devices |
| 443 | HTTPS | encrypted HTTP communication with web servers|
| 2049 | NFS | file sharing between unix and linux systems |

The /etc/services file containts all of the ports contained on a linux server 

### serving the basics

Main uses of Linux servers: 

1. Web services
2. DB services
3. Email services

####Â web servers

1. Apache: modularity, plugins for each service, reduced memory usage
2. nginx: popularily used in conjununction with apache - nginx used as load balancing - smaller memory footprint, improved performance and additional features (web proxy, mail proxy, mail cache, web page cache, load balancing)
3. lighttpd package: The lighthttpd web server is known for low memory usage and low CPU usage, making it ideal for smaller server applications, such as in embedded systems.

#### DB servers

Relational database servers allowed multiple clients to access the same data from a centralized location. The Structured Query Language (SQL) provides a common method for clients to send requests to the database server and retrieve the data.

1. PostgreSQL: PostgreSQL is known for its advanced database features. It follows the standard atomi- city, consistency, isolation, and durability (ACID) guidelines used by commercial databases and supports many of the fancy features you'd expect to find in a commercial relational database server. complexity. In the past the PostgreSQL database had a reputation for being somewhat slow, but it has made vast improvements in performance.
2. MySQL: simple but fast database system. No attempt was made to implement fancy database features; it just offers basic features that performed quickly. The combination of a Linux server running the Apache web server and the MySQL database server and utilizing the PHP programming language became known as the LAMP platform and can be found in Linux servers all over the world.
3. MongoDB: A NoSQL database doesn't create tables but instead stores data as individual documents. Unlike relational tables, each NoSQL docu- ment can contain different data elements, with each data element being independent from the other data elements in the database. MongoDB It stores data records as individual JavaScript Object Notation (JSON) elements, making each data document independent of the others. It allows you to incorporate JavaScript in queries, making it a very versatile tool for querying data.  installs with a default of no securityÑanyone can connect to the server to add and retrieve data records. 

#### mail server

Instead of having one monolithic program that handles all of the pieces required for sending and receiving mail, Linux uses multiple small programs that work together in the processing of email messages.

![001](/assets/001.JPG) 

linux email server is normally divided into three separate functions:

- mail transfer agent (MTA)

responsible for handling both incoming and outgoing email messages on the server. for each outgoing message, the MTA determines the destination host of the recipient address. if the destination host is a remote mail server, the MTA must establish a communication link with another MTA program on the remote host to transfer the message.

  - sendmail: very versatile, virtual domains, message forwarding... very complex to configure but industry standard
  - postfix: modular application, simplicity, 2 config files with plaintext parameters
  - exim: sticks with the sendmail model of using one large program to handle all of the email functions. it attempts to avoid queuing messages as much as possible - relies on immediate delivery in most environments

- mail delivery agent (MDA): programs to deliver messages to local users. they can add bells and whistles that aren't available in MTA. the MDA program receives messages destined for local users from the MTA program and then determines how those messages are to be delivered. 2 common MDA programs:

  - binmail: most popular, simplicity, by default it can read email messages stored in the standard /var/spool/mail directory - regularly located on /bin/mail
  - procmail: versatility in creating user-configured recipes that allow a usr to direct how the server processes received mail. a user can create a personal **.procmailrc** file in their **$HOME** directory to direct messages based on regular expressions to separate mailbox files, foward messages to alternative email addresses...

- mail user agent (MUA): the program that interacts with end users (view and manipulate email messages) - therefore, it runs client side (not on the server). MTA and MDA are located on the servers.

### serving local networks 

#### file server

2 basic methods for sharing files in a LAN environment:

- peer-to-peer: one workstation enables another workstation to access files stored locally on its hard drive. this method allows collaboration between two employees on a small scale
- client/server: utilizes a centralized _file server_ for sharing files that multiple clients can access and modify as needed. an admin needs to control who has access to which file

2 common server softwares to share files: NFS and Samba

##### NFS

the _network file system_ (NFS) is a protocol used to share folders in a network environment. with NFS, a linux system can share a protion of its virtual directory on the network to allow access by clients as well as other servers. **nfs-utils**. using the nfs-utils, your linux system can mount remotely shared NFS folders almost as easily as if they were on a local hard drive partition.

##### samba

default sharing method used in _windows_ : system message block (SMB) - it allows to interact with windows servers and clients using smb. the samba software package was created to allow linux systems to interact with windows clients and servers.

#### print servers

the standard linux print sharing software package is called _common unix printing system_ (CUPS cups). the cups software allows a linux system to connect to any printer resource, either locally or via a network, by using a common application interface that aoperates over dedicated printer drives. the key to cups is the printer drivers. for connection to network printers, cups uses the _internetp printing protocol_ (IPP ipp).

#### network resource servers

- ip addesses: dynamic host configuration protocol - DHCP dhcp. clients can request a valid IP address for the network from a DHCP server. a centrap dhcp server keeps track of the ip addresses assigned, ensuring that no two clients receive the same ip address. once you have the DHCPd server running on your network, you'll need to tell your linux clients to use it to obtain their network addresses. this requires a dhcp client software package. for linux dhcp clients, there are three popular packages: 1) dhclient (mostused on debian and RH based systems) 2) dhcpd 3) pump
- logging: there are two main logging packages used in linux, and which one a system uses depends on the startup software it uses: 1) rsyslogd: the sysvinit and upstart systems utilize the rsyslogd service program to accept logging data from remote servers 2) journald: the systemd system utilizes the journald service for both local and remote logging of system information.
- name servers: domain name system (DNS dns) dns maps ip addresses to a host naming scheme on network. a dns server acts as a directory lookup to find the names of servers on the local network. the main program in BIND bind is _named_, the server daemon that runs on linux servers and resolves hostnames to ip addresses for clients on the local network.
- network management: the _simple network management protocol_ (SNMP snmp) provides a way for an administrator to query remote network devices and severs to obtain information about thier configuration, status, and even performance. the most popular snmp software package in linux is the open-source _net-snmp_ package.
- time: for many network applications to work correctly, both servers and clients need to have their internal clocks coordinated with the same time. the network time protocol (ntp) accomplishes this. it allows servers and clients to synchronize on the same time source across multiple networks, adding or subtracting fractions of a seecond as needed to stay in sync.

### implementing security

#### authentication server

the core security for linux servers is the standard userid and password assigned to each individual user on the system and stored in the _/etc/passwd_ and _/etc/shadow_ files. there are a few different methods for sharing user account dbs across multiple linux servers on a network.

#### nis NIS

the network information system is a directory service that allos both clients and servers to share a common naming directory - _nis-utils_. the nis snaming directory is often used as a common repository for user accounts, hostnames... the nis+ protocol expands on nis by adding security features.

#### kerberos

kerberos was devolped as a secure authentication protocol. it uses symmetric-key cryptography to securely authenticate users with a centralized server database. the entire authentication process is encrypted, making it a secure method of logging into a linux server. _kerberos database_. 

#### ldap LDAP

network authentication system. the _lightweight directory access protocol_ provides a simple network authentification service to multiple applications and devices on a local network. the most popular implementation of ldap in the linux world is the _openldap_ openLDAP package. openldap allows you to design a hierarchical db to store objects in your network.

The hirerachical dbs allow you to group objects by types, such as users and servers, or by location, or both. this provides a very flexible way of designing authentication for your local network.

The openldap package consists of both client and server programs. the client program allows systems to access an openldap server to authentication requests make by clients of other network objects.

#### certificate authority

method of authenticating users by _certificates_. a certificate is an encrypted key that implements a two-factor authentication method. to log into a server, a user must have a certificate file and know a pin. it's important that the server trusts the certificate. for that, you need a certificate authority. the openssl package provides standard certificate functions for both servers and clients. you can setup your linux server to create certificates for clients and then authenticate them for network applications.

#### access server (SSH)

the secure shell provides a layer of enryption around data sent across the network.

#### virtual private networks - vpn VPN

the solution to remotely connecting to resources on a local network is the vpn protocol. the vpn protocol creates a secure point-to-point tunnel between a remote client or server and a vpn server on your local network. this provides a secure method for remotely accessing any server on your local network. in linux, the most popular vpn solution is the openVPN openvpn package. the openvpn package runs as a server service on a linux server on your local network.

#### proxy server

a web proxy server allows you to intercept web requests from local network clients. by intercepting the web requests, you have control of how clients interact with remote web servers. the web proxy server can block websites you don't want your network clients to see, and the server can cache common websites so that future requests for the same pages load faster. the most popular web proxy server in linus is the _squid_ package.

#### monitoring

there are several monitoring tools available in the linux world. the nagios software package is quickly becoming a popular tool, especially in cloud linux systems. nagios uses snmp to monitor the performance and logs of linux servers and provide results in a simple graphical window environment.

### improving performance

#### clustering

a computer cluster improves application performance by dividing application functions among multiple servers. each server node in the cluster is configured the same and can perform the same functions, but the cluster management software determines how to split the application functions among the servers. since each server in the cluster is working on only part of the application, you can use less powerful servers within the cluster than if you had to run the entire application on a single server. some clustering technologies are apache hadoop and linux virtual server.

#### load balancing

load balancing is a special application of clustering. a load balancer redirects entire cient request to one of a cluster of servers. while a single server processes the entire request, the client load is distributed amond the multiple servers automatically. common linux load balancing include haproxy, linux virtual server and even nginx.

#### containers

linxu containers create a self-contained environment to encapsulate aplications. a container packages all of the necessary applicaiton files, library files, and OS libraries into a bundle that you can easily move between environments. currently, the two most popular ones are docker and kubernetes.


1. b
2. a
3. a < X c
4. b
5. a
6. c
7. b
8. c
9. d
10. b
11. a,b
12. c
13. d
14. b
15. c
16. a
17. c
18. c
19. a
20. c

## chapter 3 - managing files, directories, and text





