# comptia

## Chapter 2 - sifting through services

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

##### samba

#### print servers

#### network resource servers

#### name servers 

### implementing security




