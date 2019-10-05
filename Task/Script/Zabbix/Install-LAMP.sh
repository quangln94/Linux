#!bin/bash
echo "Install LAMP"
echo "Step 1: Install MariaDB 10.2"
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

echo "Step 2: Install Apache"
yum install httpd -y
systemctl start httpd
systemctl enable httpd
echo "Step 3: Install PHP"
yum install php php-mysql php-gd php-pear –y
systemctl restart httpd
echo "Step 4: Install WordPress"
cd /var/www/html/
wget http://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
cp wordpress/* /var/www/html/
cp wp-config-sample.php wp-config.php
