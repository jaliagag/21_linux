# comptia

## Chapter 2 - sifting through services

- daemon: a linux service program that runs as a backup process

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

### Mail server

![001](/assets/001.JPG) 

linux email server is normally divided into three separate functions:

- mail transfer agent (MTA)

responsible for handling both incoming and outgoing email messages on the serer. for each outgoing message, the MTA determines the destination host of the recipient address. if the destination host is a remote mail server, the MTA must establish a communication link with another MTA program on the remote host to transfer the message.

  - sendmail: very versatile, virtual domains, message forwarding... very complex to configure but industry standard
  - postfix: modular application, simplicity, 2 config files with plaintext parameters
  - exim: sticks with the sendmail model of using one large program to handle all of the email functions. it attempts to avoid queuing messages as much as possible - relies on immediate delivery in most environments

- mail delivery agent (MDA): programs to deliver messages to local users. they can add bells and whistles that aren't available in MTA. the MDA program receives messages destined for local users from the MTA program and then determines how those messages are to be delivered. 2 common MDA programs:

  - binmail: most popular, simplicity, by default it can read email messages stored in the standard /var/spool/mail directory - regularly located on /bin/mail
  - procmail: versatility in creating user-configured recipes that allow a usr to direct how the server processes received mail. a user can create a personal **.procmailrc** file in their **$HOME** directory to direct messages based on regular expressions to separate mailbox files, foward messages to alternative email addresses...

- mail user agent (MUA): the program that interacts with end users (view and manipulate email messages) - therefore, it runs client side (not on the server). MTA and MDA are located on the servers.

### File server

2 basic methods for sharing files in a LAN environment:

- peer-to-peer: one workstation enables another workstation to access files stored locally on its hard drive. this method allows collaboration between two employees on a small scale
- client/server: utilizes a centralized _file server_ for sharing files that multiple clients can access and modify as needed. an admin needs to control who has access to which file

2 common server softwares to share files: NFS and Samba

#### NFS




