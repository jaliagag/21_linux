# Puppet 5 Beginner’s Guide Go from newbie to pro with Puppet 5

Puppet is two things: a language for expressing the desired state (how your nodes should be configured), and an engine that interprets code written in the Puppet language and applies it to the nodes to bring about the desired state.

```puppet
package { 'curl':
    ensure => instaled,
}
```

1. check the list of installed software on the node to see if curl is installed
2. if it is, do nothing
3. if not, install it

puppet programs are called manifests: a set of declarations about what things should exist and how should be configured.

- resources: types of things that can exist, such as users, files or packages
- attributes: appropriate properties for the type fo resource (home dir for a user, owner and permissions for a file)

puppet architectures:

- agent/master: a special node dedicated to running puppet, which all other nodes contact to get their configuration
- stand-alone puppet or masterless: no need for a special master node. puppet runs on each individual node and odes not need to contract a central location to get its configuration. use git, sftp or rsync

## chapter 2

```pp
file { '/tmp/hello.txt':
    ensure => file,
    content => "hello, world\n",
}
```

resource declartion pattern

```txt
RESOURCE_TYPE { TITLE:
    ATTRIBUTE => VALUE,
    ...
}
```

- TITLE: the name that Puppet uses to identify the resource internally. with file resources, it's usual for this to be the full path of the file

the ATTRIBUTES available depend on the type of the resource. for file:

- content: sets the _entire_ content of a file to a string value you provide
- owner
- group
- mode

all resources support the **ensure** attribute. the _values_ for `ensure` vary depending on the resource type. we use _file_ to indicate a regular file, as opposed to a directory or symlink

if you make a chanage to a file without also changeing the puppet manifest to match, puppet will overwrite the file the next ime it runs, and your changes will be lost

dry-run: `--noop` flag to `puppet apply` will show you what puppet would have done, without actually changing anything. `--show_diff` to view the changes to be done.

puppet decides whether or not a file resource needs updating, based on its MD5 hash sum.

how are manifests applied?

1. puppet reads the manifest and the list of resources it contains and compiles these into a **catalog** (an internal representation of the desired state of the node)
2. puppet then works through the catalog, applying each resource in turn
   1. first, if the resource on the server? if not, create it
   2. then, for each resource, it checks the value of each attribute in the catalog agains what actually exists on the server

### packages

if you specify that a given package should be installed, puppet will use the apprpriate package manager commands to install it on whatever platform it's running on.

- RESOURCE_TYPE: package
- ATTRIBUTE: usually only _ensure_ and it's value _installed

```pp
package { 'ntp':
    ensure => installed,
}
```

```pp
exec { "apt-update":
    command => "/usr/bin/apt-get update"
}

package { "vim":
	ensure => installed,
}
```

see what version of a package thinks you have installed, we can use the **puppet resource** tool: `puppet resource RESOURCE_TYPE`

- puppet resource package
- puppet resource file /tmp

puppet resource has an interactive config feature. `puppet resource -e package openssl` - puppet generates a manifest for the current state of the resource and open it in an editor. if you make changes and save it, puppet will automatically apply that manifest to make changes to the system

### services

service: a long running process that either does some continuous kind of work, or waits for requests and then acts on them

```pp
service { "sshd":
    ensure => running,
    enable => true,
}
```

in services

- ensure: running or stopped
- enable: start on system boots

`puppet describe service`; see a list of all the available resource types `puppet describe --list`

### package-file-service pattern

the **package** resource installs the software, the **file** resource deploys one or more configuration files required for the software, and the **service** resource runs the software itself

```pp
package { 'mysql-server':
    ensure => installed,
    notify => Service['mysql'],
}

file { '/etc/mysql/mysql.cnf':
    source => '/examples/files/mysql.cnf',
    notify => Service['mysql'],
}

service { 'mysql':
    ensure => running,
    enable => true,
}
```

notify: what this does depends on the resource; when it's a service, the default action is to restart the service to _notify_ that there has been a change. the name of the resource to notify is specified as the resource type, capitalized, followed by the resource title, quoted and between square brackets: `Service['mysql']`

puppet applies resources in the same order in which they are declared in the manifest, _unless you explicitly specify a different order using the **require** attribute_.

all resources support the `require` attribute - its value is the name of another resource declared somewhere in the manifest, specified in the same way as when using _notify_.

```pp
package { 'mysql-server':
    ensure => installed,
}

file { '/etc/mysql/mysql.cnf':
    source => '/examples/files/mysql.cnf',
    notify => Service['mysql'],
    require => Package['mysql-server'],
}
service { 'mysql':
    ensure => running,
    enable => true,
    require => [Package['mysql-server'], File['/etc/mysql/mysql.cnf']],
}
```

## chapter 3

`puppet agent -t` apply changes on the volume

in the masterless puppet architecture, we can use Git to distribute manifests to client nodes, which then runs (`puppet apply *.pp`//`puppet agent -t`) to update their configuration. no master server, no SPOF.

we need a Git server which each node can connect to and clone the repo.

in a stand-alone/masterless arch, each node needs to automatically fetch any changes from the Git repo at regular intervals, and apply then with Puppet. we can do that with a shell scrip and include it on the cron job

```sh
#!/bin/bash
cd /etc/puppetlabs/code/environments/production && git pull
/opt/puppetlabs/bin/puppet apply manifests/
```

for this to work we need to have a repository initialized on `/etc/puppetlabs/code/environments/production`

## chapter 4
