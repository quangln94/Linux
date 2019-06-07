# Cài đặt zabbix server trên centOS 7
## Mô hình 
Một mô hình giám sát zabbix sẽ bao gồm đầy đủ các thành phần như sau:

<img src=https://i.imgur.com/4FTd21l.jpg>

Bài Lab giám sát với hệ thống nhỏ nên không cài đặt zabbix proxy.</br>
Cài đặt Web Server, Zabbix Server và Database Server trên cùng một máy.
## Chuẩn bị

Một máy làm Zabbix Agent. Nhưng trong bài lab này tôi cài agent trên máy có HĐH centOS7.

Mô hình đơn giản của tôi như sau

|Hostname|Server|Agent|
|--------|------|-----|
|IP|||

## Setup

Cài đặt LAMP tham khảo [tại đây](https://github.com/niemdinhtrong/NIEMDT/blob/master/wordpress/docs/LAMP.md)

**Cài đặt zabbix server**

- Cài đặt bằng package. Cài đặt gói cấu hình

```sh
rpm -ivh https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
```
- Cài đặt Zabbix Server
```sh
yum install zabbix-server-mysql
```
- Cài đặt Zabbix Frontend
```sh
yum install zabbix-web-mysql
```
Nếu mô hình có Zabbix Proxy thì dùng lênh sau để cài đặt trên máy Zabbix Proxy
```sh
yum install zabbix-proxy-mysql
```
**Tạo database cho zabbix**
```sh
mysql -u root -p

create database zabbix;

grant all privileges on zabbix.* to 'zabbix'@'localhost' identified by 'zabbix';

exit
```
**Import database**
```
zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -p zabbix
```
Sửa file `zabbix_server.conf` để có thể sử dụng database (nếu cài Zabbix Proxy thì cẩn sửa file `zabbix_proxy.conf`)
```sh
# vim /etc/zabbix/zabbix_server.conf
DBHost=localhost
DBName=zabbix
DBUser=zabbix
DBPassword=zabbix
```
Đây là các thông số mà tôi vừa tạo trong database ở câu lệnh bên trên
**Start zabbix server**
```sh
service zabbix-server start
systemctl enable zabbix-server
```
**Cấu hình zabbix frontend**

Truy cập file `/etc/httpd/conf.d/zabbix.conf` và uncomment ở dòng timezone và chỉnh sửa lại timezone
```sh
vim /etc/httpd/conf.d/zabbix.conf
php_value max_execution_time 300
php_value memory_limit 128M
php_value post_max_size 16M
php_value upload_max_filesize 2M
php_value max_input_time 300
php_value max_input_vars 10000
php_value always_populate_raw_post_data -1
php_value date.timezone Asia/Ho_Chi_Minh
```
**Cầu hình selinux**
Bạn có thể disable SElinux hoặc cho phép kết nối bằng câu lệnh sau
```sh
setsebool -P httpd_can_connect_zabbix on
setsebool -P httpd_can_network_connect_db on
```
**Restart lại Apache**
```sh
service httpd restart
```
Mở trình duyệt web và truy cập `http://IP-server/zabbix` bạn sẽ thấy như sau

<img src=https://i.imgur.com/TBwPP1E.png>

## Cài đặt zabbix agent
Cài đặt zabbix agent trên các host muốn monitor
- Cài đặt gói cấu hình
```sh
rpm -ivh https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
```
- Cài đặt agent
```sh
yum install zabbix-agent
```
- Bật agent
```sh
service zabbix-agent start
systemctl enable zabbix-agent
```
Sau đó và file `/etc/zabbix/zabbix_agentd.conf` và chỉnh sửa một số thông tin
```
vim /etc/zabbix/zabbix_agentd.conf
SourceIP=IP-agent
ListenIP=IP-agent
ListenPort=10050
Server=IP-server
ServerActive=IP-server
```
`SourceIP`: IP của zabbix agent. Khai báo này được sử dụng khi máy có nhiều IP ta cần chỉ ra IP giao tiếp với zabbix server</br>
`ListenIP`: IP của zabbix agent. IP được dùng để lắng nghe các gói tin mà zabbix server gửi đến.</br>
`ListenPost`: Port lắng nghe giao tiếp với server. Port mặc định ở đây là 10050</br>
`Server`: Bật chế độ Zabbix Monitor Passive ở agent</br>
`ServerActive`: Bật chế độ Zabbix Monitor Active ở agent</br>
**Khởi động lại agent**
```sh
systemctl restart zabbix-agent
systemctl enable zabbix-agent
```
**Mở port**
Tắt SElinux
```sh
setenforce 0
```
Câu lệnh trên dùng để tắt tạm thời cho đến khi bạn reboot. Muốn tắt vĩnh viễn bạn vào file `/etc/selinux/config` và sửa như sau:
```sh
SELINUX=disabled
```
Mở port
```sh
iptables -I INPUT -p tcp --dport 10050 -j ACCEPT
iptables -I OUTPUT -p tcp --sport 10050 -j ACCEPT
```

chown -R apache:apache /usr/share/zabbix/assets/
