#!bin/bash
echo "Install LAMP"
echo "Step 1: Install MariaDB 10.2"
sleep 5s
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
sleep 5s
yum install httpd -y
systemctl start httpd
systemctl enable httpd

echo "Step 3: Install PHP"
sleep 5s
yum install php php-mysql php-gd php-pear –y
sed -i 's/max_execution_time = 30/max_execution_time = 600/g' /etc/php.ini
sed -i 's/max_input_time = 60/max_input_time = 600/g' /etc/php.ini
sed -i 's/memory_limit = 128M/memory_limit = 256M/g' /etc/php.ini
sed -i 's/post_max_size = 8M/post_max_size = 32M/g' /etc/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 16M/g' /etc/php.ini
echo "date.timezone = Asia/Ho_Chi_Minh" >> /etc/php.ini
systemctl restart httpd

echo "Step 4: Install WordPress"
sleep 5s
cd /var/www/html/
wget http://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
cp -r wordpress/* /var/www/html/
cp -r wp-config-sample.php wp-config.php
