# Topology
Server 1: MySQL
Server 2: Install Apache, PHP, WordPress</br>
# Installation
## Server 1
Step 1: Install MySQL
```sh
wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
rpm -ivh mysql-community-release-el7-5.noarch.rpm
yum install mysql-server
systemctl start mysqld
```
Config MySQL
```
mysql_secure_installation
```
## Server 2:
IP: 192.168.1.1
Step 1: Install Apache

```sh
yum install httpd -y
```
Config httpd
```sh
systemctl start httpd
systemctl enable httpd
```
Step 2: Install PHP
```sh
yum install php php-mysql php-gd php-pear –y
systemctl restart httpd
```
Step 3: Install WordPress
