# I. Topology
||Server1|Server2|
|---|---|--------|
|Service|MySQL Server|Apache, PHP, WordPress|
|IP|192.168.1.1|192.168.1.2|
# II. Installation
## Server 1 (MySQL Server)
**192.168.1.1**
### Step 1: Install MySQL
```sh
wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
rpm -ivh mysql-community-release-el7-5.noarch.rpm
yum install mysql-server
systemctl start mysqld
```
**Config MySQL**
```
mysql_secure_installation
```
### Step2: Create Databases 
```
create database name-database;
create user 'user'@'IP' identified by 'password';
grant all privileges on name-database to 'user'@'IP';
flush privileges;
exit
```
**Example:**
```
create database wordpress;      # "wordpress" Name of database
create user 'user1'@'192.16.1.2' identified by 'password';    # "user1'@'192.16.1.2'" and "'password'" User, Password can access from  IP's Client (IP Client Or IP Server 2: 192.168.1.2)
grant all privileges on wordpress.* to 'user1'@'192.168.1.2';   # Grand all Permission on wordpress for user1'@'192.168.1.2
flush privileges;
exit
```
## Server 2 (Install: Apache, PHP, WordPress)
**IP: 192.168.1.2**
### Step 1: Install Apache
```sh
yum install httpd -y
```
**Config httpd**
```sh
systemctl start httpd
systemctl enable httpd
```
### Step 2: Install PHP
```sh
yum install php php-mysql php-gd php-pear –y
systemctl restart httpd
```
### Step 3: Install WordPress
```sh
cd /var/www/html/
cd wordpress/* /var/www/html/
cp wp-config-sample.php wp-config.php
```
**Config file **wp-config.php**
```sh
vim wp-config.php

define('DB_NAME', 'database_name_here');    
define('DB_USER', 'username_here');    
define('DB_PASSWORD', 'password_here');      
define('DB_HOST', 'localhost'); 
```

**Example**
```sh
vim wp-config.php

define('DB_NAME', 'wordpress');    # "wordpress" is name of database on MySQL Server
define('DB_USER', 'user1');        # #user1# is user can access to MySQL Server 
define('DB_PASSWORD', 'password');     # "password# Password of user1
define('DB_HOST', '192.168.1.1');     # "192.168.1.1" IP Address of MySQL Server
```
