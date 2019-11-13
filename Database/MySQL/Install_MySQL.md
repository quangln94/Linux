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
rpm -ivh mysql-community-release-el7-5.noarch.rpm
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

## Harden MySQL Server
Run the `mysql_secure_installation` script to address several security concerns in a default MySQL installation.
```sh
sudo mysql_secure_installation
```
You will be given the choice to change the MySQL root password, remove anonymous user accounts, disable root logins outside of localhost, and remove test databases. It is recommended that you answer `yes` to these options. You can read more about the script in the MySQL Reference Manual.

*Note: If MySQL 5.7 was installed, you will need the temporary password that was created during installation. This password is notated in the /var/log/mysql.log file, and can be quickly found using the following command.`sudo grep 'temporary password' /var/log/mysqld.log`*

Allow access to MySQL from remotely
```sh
iptables -I INPUT -p tcp -m tcp --dport 3306 -j ACCEPT
```

## Using MySQLPermalink
The standard tool for interacting with MySQL is the mysql client which installs with the mysql-server package. The MySQL client is used through a terminal.

### Root LoginPermalink
To log in to MySQL as the root user:
```sh
mysql -u root -p
```
When prompted, enter the root password you assigned when the `mysql_secure_installation` script was run.</br>
You’ll then be presented with a welcome header and the MySQL prompt as shown below:
```sh
mysql>
```
To generate a list of commands for the MySQL prompt, enter `\h`. You’ll then see:
```sh
List of all MySQL commands:
Note that all text commands must be first on line and end with ';'
?         (\?) Synonym for `help'.
clear     (\c) Clear command.
connect   (\r) Reconnect to the server. Optional arguments are db and host.
delimiter (\d) Set statement delimiter. NOTE: Takes the rest of the line as new delimiter.
edit      (\e) Edit command with $EDITOR.
ego       (\G) Send command to mysql server, display result vertically.
exit      (\q) Exit mysql. Same as quit.
go        (\g) Send command to mysql server.
help      (\h) Display this help.
nopager   (\n) Disable pager, print to stdout.
notee     (\t) Don't write into outfile.
pager     (\P) Set PAGER [to_pager]. Print the query results via PAGER.
print     (\p) Print current command.
prompt    (\R) Change your mysql prompt.
quit      (\q) Quit mysql.
rehash    (\#) Rebuild completion hash.
source    (\.) Execute an SQL script file. Takes a file name as an argument.
status    (\s) Get status information from the server.
system    (\!) Execute a system shell command.
tee       (\T) Set outfile [to_outfile]. Append everything into given outfile.
use       (\u) Use another database. Takes database name as argument.
charset   (\C) Switch to another charset. Might be needed for processing binlog with multi-byte charsets.
warnings  (\W) Show warnings after every statement.
nowarning (\w) Don't show warnings after every statement.

For server side help, type 'help contents'

mysql>
```
### Create a New MySQL User and DatabasePermalink
To create a New MySQL User
```sh
create user 'user-name'@'IP' identified by 'password';
```
- `IP` can be a IP address from remotely allow access to login or localhost if only login local. `%` if allow all client login .
In the example below, `testdb` is the name of the database, `testuser` is the user, and `password` is the user’s password.
```sh
create database testdb;
create user 'testuser'@'192.168.1.2' identified by 'password';
```
Grant user permission `grant permissions on data-name.table-name to 'user-name'@'IP';`
- `ALL PRIVILEGE`S all permissions
- `CREATE` allow create new table or hoặc databases
- `DROP` delete table or databases
- `DELETE` delete data in table
- `INSERT` add data in table
- `SELECT` user select to reade data
- `UPDATE` update data in table
- `GRANT OPTION` add/remove user, permission of user

`grant all on testdb.* to 'testuser' identified by 'password';`
You can shorten this process by creating the user while assigning database permissions:
```
create database testdb;
grant all on testdb.* to 'testuser' identified by 'password';
Then exit MySQL.

exit
```
## References
https://www.linode.com/docs/databases/mysql/how-to-install-mysql-on-centos-7/
