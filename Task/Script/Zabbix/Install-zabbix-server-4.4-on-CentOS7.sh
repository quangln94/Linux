cat << EOF > install-zabbix-server.sh
echo "Install Zabbix-server"
echo "Step 1: Cai dat cac goi can thiet"
rpm -Uvh https://repo.zabbix.com/zabbix/4.4/rhel/7/x86_64/zabbix-release-4.4-1.el7.noarch.rpm
yum clean all
yum -y install zabbix-server-mysql zabbix-web-mysql zabbix-agent
systemctl restart zabbix-server zabbix-agent httpd
systemctl enable zabbix-server zabbix-agent httpd

echo "Step 2: Install LAMP"
echo "Step 2.1: Install MariaDB 10.2"
echo "[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.2/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1" >> /etc/yum.repos.d/MariaDB.repo
yum -y update
yum install -y mariadb mariadb-server
systemctl start mariadb
systemctl enable mariadb
mysql_secure_installation
mysql -u root -p
create database zabbix;
grant all privileges on zabbix.* to 'zabbix'@'localhost' identified by 'zabbix';
exit;
zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -pzabbix

echo "Step 2.2: Install Apache"
yum install httpd -y
systemctl start httpd
systemctl enable httpd

echo "Step 2.3: Install PHP"
yum install php php-mysql php-gd php-pear –y
sed -i 's/max_execution_time = 30/max_execution_time = 600/g' /etc/php.ini
sed -i 's/max_input_time = 60/max_input_time = 600/g' /etc/php.ini
sed -i 's/memory_limit = 128M/memory_limit = 256M/g' /etc/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 32M/g' /etc/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 16M/g' /etc/php.ini
echo "date.timezone = Asia/Ho_Chi_Minh" >> /etc/php.ini
systemctl restart httpd
echo "Step 2.4: Install WordPress"
cd /var/www/html/
wget http://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
cp -r wordpress/* /var/www/html/
cp -r wp-config-sample.php wp-config.php

echo "Step 3: Chi dinh database cho zabbix-server"
read -p "Ten database: " namedatabase
sed -i "s/database_name_here/$namedatabase/" /var/www/html/wp-config.php
read -p "User database: " userdatabase
sed -i "s/username_here/$userdatabase/" /var/www/html/wp-config.php
read -p "Password cua User: " passworduser
sed -i "s/password_here/$passworduser/" /var/www/html/wp-config.php
read -p "IP cua database: " ipdatabase
sed -i "s/localhost/$ipdatabase/" /var/www/html/wp-config.php

chown apache:apache /var/www/html/wp-config.php
EOF
-------------------------------------------------------------------------------------

-------------------------------------------------------------------------------

cat << EOF > install-zabbix-agent.sh
#!bin/bash
echo "Install Zabbix-agent"
rpm -Uvh https://repo.zabbix.com/zabbix/4.4/rhel/7/x86_64/zabbix-release-4.4-1.el7.noarch.rpm
yum -y install zabbix-agent
service zabbix-agent start
systemctl enable zabbix-agent

read -p "SourceIP=IP-agent: " IPagent
sed -i "s/# SourceIP=/SourceIP=$IPagent/" /etc/zabbix/zabbix_agentd.conf
sed -i "s/# ListenIP=0.0.0.0/ListenIP=$IPagent/" /etc/zabbix/zabbix_agentd.conf

read -p "Server=IP-server: " IPserver
sed -i "s/Server=127.0.0.1/Server=$IPserver/" /etc/zabbix/zabbix_agentd.conf
sed -i "s/ServerActive=127.0.0.1/ServerActive=$IPserver/"  /etc/zabbix/zabbix_agentd.conf

systemctl restart zabbix-agent
EOF
