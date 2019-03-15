# Install WordPress
```sh
#!/bin/bash/
yum install wget -y
yum install vim -y
cd /var/www/html/
wget
```
# Install WordPress
```sh
!#/bin/bash/
echo "Scrip nay chi chay duoc tren CentOS"
echo "Ban co muon tiep tuc khong"
echo "Nhập 1 neu muon tiep tuc, 0 neu muon thoat"
read i
if [ $i -eq 1 ] # nếu i = 1
then
cd /var/www/html/
wget http://wordpress.org/latest.tar.gz
tar zxf latest.tar.gz
cp wordpress/* /var/www/html/
cp wp-config-sample.php wp-config.php
fi
```
# Check OS
```sh
#1/bin/bash
echo "Scrip nay chi chay duoc tren CentOS"
echo "Nhap 1 de check OS"
echo "Nhap 2 để check Kernel"
read i
if [ $i -eq 1 ]; # nếu i = 1
then
cat /etc/os-release
else
if [ $i -eq 2 ]; # nếu i = 2
then
uname -r
fi
fi

```
