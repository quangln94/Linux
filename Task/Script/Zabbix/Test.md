#!bin/bash
## Khai bao function
# Khai báo mật khẩu SQL và database tạo rao dùng để lưu trữ cho Zabbix 
function khaibao {
	echo "Tao user mysql va phan quyen"
	echo "Nhap MYSQL_PASS cho tai khoan root"
	read p
	echo "Nhap ten CSDL muon tao. Mac dinh la zabbix"
	read u
	u=${u:-zabbix}
	echo "Nhap password cho CSDL muon tao. Mac dinh la zabbix" 
	read m 
	m=${m:-zabbix}
}

# Dùng các lệnh SQL để tạo một cơ sở dữ liệu 
function sql {
cat << EOF | mysql -uroot -p$p
create database $u character set utf8 collate utf8_bin;
grant all privileges on $u.* to zabbix@localhost identified by '$m';
flush privileges;
EOF
}

echo "Install Zabbix-server"
echo "Step 1: Cai dat cac goi can thiet"
echo "Check distro"
if [ -f /etc/redhat-release ]; then
        rpm -Uvh https://repo.zabbix.com/zabbix/4.4/rhel/8/x86_64/zabbix-release-4.4-1.el8.noarch.rpm
        dnf clean all
        dnf -y install zabbix-server-mysql zabbix-web-mysql zabbix-apache-conf zabbix-agent
        khaibao
else
        wget https://repo.zabbix.com/zabbix/4.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.4-1+bionic_all.deb
        dpkg -i zabbix-release_4.4-1+bionic_all.deb
        apt update
        apt -y install zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-agent
fi

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

# Các chèn password Mysql khi tải mới lần đầu mà không cần nhập trên màn hình 
echo mysql-server mysql-server/root_password password $p | debconf-set-selections
echo mysql-server mysql-server/root_password_again password $p | debconf-set-selections
sql

zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -u$u -p$m

echo "Step 2.2: Install Apache"
yum install httpd -y
systemctl start httpd
systemctl enable httpd

echo "Step 2.3: Install PHP"
yum install php php-mysql php-gd php-pear –y
systemctl restart httpd
echo "Step 2.4: Install WordPress"
cd /var/www/html/
wget http://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
cp wordpress/* /var/www/html/
cp wp-config-sample.php wp-config.php

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
