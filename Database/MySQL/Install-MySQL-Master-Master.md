# Install MySQL Master-Master 
**Thêm MySQL Yum repository vào hệ thống để cài đặt MySQL**
```sh
wget http://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm
```
**Sau khi tải xong, tiếp theo sẽ dùng lệnh yum để cài đặt.**
```sh
yum localinstall mysql57-community-release-el7-7.noarch.rpm
```
**Kiểm tra MySQL Yum repository đã được thêm vào hệ thống hay chưa bằng lệnh sau.**
```sh
yum repolist enabled | grep "mysql.*-community.*"
```
**Cài đặt MySQL**
```sh
yum install mysql-community-server
```
**Khởi động MySQL Server**
```sh
service mysqld start
```
***Lưu ý: Sau khi cài đặt, MySQL 5.7 trở lên tự động tạo một mật khẩu ngẫu nhiên tại `/var/log/mysqld.log`***

**Sử dụng câu lệnh sau để xem mật khẩu ngẫu nhiên:**
```sh
grep 'temporary password' /var/log/mysqld.log
```
**Sau khi biết mật khẩu ngẫu nhiên thì sử dụng lệnh sau để cài đặt bảo mật cho MySQL:**
```sh
mysql_secure_installation
```
## 2. Cấu hình MySQL Master-Master

### 2.1 Cài đặt và cấu hình MySQL Master Master Replication trên Node 1 - 172.16.68.101
Thêm vào file `/etc/my.cnf` nội dung sau: 
```sh
$ vim /etc/my.cnf
server-id=1
log-bin="mysql-bin"
binlog-do-db=itlabvn
replicate-do-db=itlabvn
relay-log="mysql-relay-log"
auto-increment-offset = 1
```
Restart lại mysql
```sh
systemctl restart mysqld
```
**Tạo user replicator trên mỗi server**
```sh
$ mysql -u root -p
GRANT REPLICATION SLAVE ON *.* TO 'replicas'@'%' IDENTIFIED BY '12345aA@';
FLUSH PRIVILEGES;
```
**Lấy thông tin file log để sử dụng trên mỗi server**
```sh
mysql> SHOW MASTER STATUS;
+------------------+----------+--------------+------------------+-------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+------------------+----------+--------------+------------------+-------------------+
| mysql-bin.000002 |      443 | itlabvn      |                  |                   |
+------------------+----------+--------------+------------------+-------------------+
1 row in set (0.00 sec)
```
***Note lại `File` và `Position` để dùng cho Node 2***

**Thực hiện tiếp lệnh sau:
```sh
mysql> STOP SLAVE;
mysql> CHANGE MASTER TO MASTER_HOST = '172.16.68.102', MASTER_USER = 'replicas', MASTER_PASSWORD = '12345aA@', MASTER_LOG_FILE = 'mysql-bin.000002', MASTER_LOG_POS = 449;
mysql> START SLAVE;
```
Trong đó:
- `MASTER_LOG_FILE = 'mysql-bin.000002'`: Lấy ở Node 2
- `MASTER_LOG_POS = 449`: lấy ở Node 2

Sau khi thực hiện xong, reboot lại Node 1
```sh
systemctl reboot
```

### 2.2 Cài đặt và cấu hình MySQL Master Master Replication trên Node 2 - 172.16.68.102
Thêm vào file `/etc/my.cnf` nội dung sau: 
```sh
$ vim /etc/my.cnf
server-id=2
log-bin="mysql-bin"
binlog-do-db=itlabvn
replicate-do-db=itlabvn
relay-log="mysql-relay-log"
auto-increment-offset = 2
```
Restart lại mysql
```sh
systemctl restart mysqld
```
**Tạo user replicator trên mỗi server**
```sh
$ mysql -u root -p
GRANT REPLICATION SLAVE ON *.* TO 'replicas'@'%' IDENTIFIED BY '12345aA@';
FLUSH PRIVILEGES;
```
**Lấy thông tin file log để sử dụng trên mỗi server**
```sh
mysql> SHOW MASTER STATUS;
+------------------+----------+--------------+------------------+-------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
+------------------+----------+--------------+------------------+-------------------+
| mysql-bin.000002 |      449 | itlabvn      |                  |                   |
+------------------+----------+--------------+------------------+-------------------+
1 row in set (0.00 sec)
```
***Note lại `File` và `Position` để dùng cho Node 1***

**Thực hiện tiếp lệnh sau:
```sh
mysql> STOP SLAVE;
mysql> CHANGE MASTER TO MASTER_HOST = '172.16.68.101', MASTER_USER = 'replicas', MASTER_PASSWORD = '12345aA@', MASTER_LOG_FILE = 'mysql-bin.000002', MASTER_LOG_POS = 443;
mysql> START SLAVE;
```
Trong đó:
- `MASTER_LOG_FILE = 'mysql-bin.000002'`: Lấy ở Node 1
- `MASTER_LOG_POS = 443`: lấy ở Node 1

Sau khi thực hiện xong, reboot lại Node 2
```sh
systemctl reboot
```









## Tài liệu tham khảo
- https://itfromzero.com/database/mysql/cai-dat-mysql-5-7-tren-rhelcentos-765-va-fedora-232221.html
- http://chichio.com/vi/thanks/c%E1%BA%A5u-h%C3%ACnh-mysql-master-master-replication
