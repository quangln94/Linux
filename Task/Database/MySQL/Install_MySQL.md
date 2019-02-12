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
## Install MySQLPermalink
MySQL must be installed from the community repository.

Download and add the repository, then update.
```sh
wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
sudo rpm -ivh mysql-community-release-el7-5.noarch.rpm
yum update
```
Install MySQL as usual and start the service. During installation, you will be asked if you want to accept the results from the .rpm file’s GPG verification. If no error or mismatch occurs, enter y.
```sh
yum install mysql-server
systemctl start mysqld
```
MySQL will bind to localhost (127.0.0.1) by default. Please reference our MySQL remote access guide for information on connecting to your databases using SSH.

Note
Allowing unrestricted access to MySQL on a public IP not advised but you may change the address it listens on by modifying the bind-address parameter in /etc/my.cnf. If you decide to bind MySQL to your public IP, you should implement firewall rules that only allow connections from specific IP addresses.
