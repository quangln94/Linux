# How to Install MySQL on CentOS 7
MySQL is a popular database management system used for web and server applications. However, MySQL is no longer in CentOS’s repositories and MariaDB has become the default database system offered. MariaDB is considered a drop-in replacement for MySQL and would be sufficient if you just need a database system in general. See our MariaDB in CentOS 7 guide for installation instructions.

If you nonetheless prefer MySQL, this guide will introduce how to install, configure and manage it on a Linode running CentOS 7.

Large MySQL databases can require a considerable amount of memory. For this reason, we recommend using a high memory Linode for such setups.
## Before You BeginPermalink
Ensure that you have followed the Getting Started and Securing Your Server guides, and the Linode’s hostname is set.

To check your hostname run:
```sh
hostname
hostname -f
```
The first command should show your short hostname, and the second should show your fully qualified domain name (FQDN).

Update your system:
```sh
sudo yum update
```
You will need wget to complete this guide. It can be installed as follows:
```sh
yum install wget
```
