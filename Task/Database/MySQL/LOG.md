# Cấu hình Log cho MariaDB 10.2 trên CentOS 7

## 1. Tổng quan
**Có 3 loại log chính trong MariaDB:**

- **Error log:** Chứa thông tin về các thông báo, lỗi sinh ra trong quá trình vận hành mariadb. Sử dụng cho mục đích truy tìm lỗi trên dịch vụ mariadb.
- **General log:** Chứa thông tin về MySQL như query, người dùng kết nối hoặc mất kết nối. Mục đính giám sát các hoạt động trên MariaDB.
- **Slow Query Log:** Chứa thông tin về các câu truy vấn chậm hơn mong đợi. Các truy vấn này có thể là nguyên nhân dẫn tới vấn đề về hiệu năng trên ứng dụng.
## 2. Cài đặt MariaDB 10.2
- **Khai báo repo**
```sh
echo '[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.2/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1' >> /etc/yum.repos.d/MariaDB.repo
yum -y update
```
- **Cài đặt MariaDB**
```sh
yum install -y mariadb mariadb-server
```
- **Khởi động dịch vụ**
```sh
systemctl start mariadb
systemctl enable mariadb
```
- ## 3. Cấu hình Log
- **Backup cấu hình cơ bản**
```sh
cp /etc/my.cnf /etc/my.cnf.org
```
- **Bổ sung cấu hình**
```sh
echo '[mysqld]
slow_query_log                  = 1
slow_query_log_file             = /var/log/mariadb/slow.log
long_query_time                 = 5
log_error                       = /var/log/mariadb/error.log
general_log_file                = /var/log/mariadb/mysql.log
general_log                     = 1

[client-server]
!includedir /etc/my.cnf.d' > /etc/my.cnf
```
***Lưu ý:***
long_query_time = 5: Nếu cấu truy vấn vào database có phản hồi chậm hơn 5s thì coi là câu truy vấn chậm (slow query)

- **Tạo thư mục chứa log**
```sh
mkdir -p /var/log/mariadb/
chown -R mysql. /var/log/mariadb/
```
- **Khởi động lại dịch vụ**
```sh
systemctl restart mariadb
```
**Lưu ý:** Nếu slow query log không nhận, thực hiện các bước bên dưới
**Thực hiện:**
```sh
mysql -u root -p
SET GLOBAL slow_query_log = 'ON';
exit;
```
## 4. Kiểm tra
**Kiểm tra như sau:**
```sh
mysql -u root -p

show global variables like 'slow_query_log';
show global variables like 'slow_query_log_file';
show global variables like 'long_query_time';
show global variables like 'log_error';
show global variables like 'general_log_file';
show global variables like 'general_log';

exit;
```
**Kết quả**
```sh
[root@client01 ~]# mysql -u root -p
Enter password:
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 8
Server version: 10.2.26-MariaDB-log MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> show global variables like 'slow_query_log';
+----------------+-------+
| Variable_name  | Value |
+----------------+-------+
| slow_query_log | ON    |
+----------------+-------+
1 row in set (0.01 sec)

MariaDB [(none)]> show global variables like 'slow_query_log_file';
+---------------------+---------------------------+
| Variable_name       | Value                     |
+---------------------+---------------------------+
| slow_query_log_file | /var/log/mariadb/slow.log |
+---------------------+---------------------------+
1 row in set (0.00 sec)

MariaDB [(none)]> show global variables like 'long_query_time';
+-----------------+----------+
| Variable_name   | Value    |
+-----------------+----------+
| long_query_time | 5.000000 |
+-----------------+----------+
1 row in set (0.00 sec)

MariaDB [(none)]> show global variables like 'log_error';
+---------------+----------------------------+
| Variable_name | Value                      |
+---------------+----------------------------+
| log_error     | /var/log/mariadb/error.log |
+---------------+----------------------------+
1 row in set (0.00 sec)

MariaDB [(none)]> show global variables like 'general_log_file';
+------------------+----------------------------+
| Variable_name    | Value                      |
+------------------+----------------------------+
| general_log_file | /var/log/mariadb/mysql.log |
+------------------+----------------------------+
1 row in set (0.00 sec)

MariaDB [(none)]> show global variables like 'general_log';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| general_log   | ON    |
+---------------+-------+
1 row in set (0.00 sec)

MariaDB [(none)]> exit;
```
**Kiểm tra thư mục chứa log**
```sh
[root@client01 ~]# ll /var/log/mariadb
total 24
-rw-rw---- 1 mysql mysql 14910 Aug  6 23:22 error.log
-rw-rw---- 1 mysql mysql  3306 Aug  7 16:22 mysql.log
-rw-rw---- 1 mysql mysql  1502 Aug  6 23:22 slow.log
```
***Thử khởi động lại MariaDB***
```sh
systemctl restart mariadb
```
***Log ghi lại***
```sh
[root@client01 ~]# tailf /var/log/mariadb/error.log
2019-08-07 16:25:12 139996208822016 [Note] /usr/sbin/mysqld (initiated by: unknown): Normal shutdown
2019-08-07 16:25:12 139996208822016 [Note] Event Scheduler: Purging the queue. 0 events
2019-08-07 16:25:12 139995650184960 [Note] InnoDB: FTS optimize thread exiting.
2019-08-07 16:25:12 139996208822016 [Note] InnoDB: Starting shutdown...
2019-08-07 16:25:12 139995197208320 [Note] InnoDB: Dumping buffer pool(s) to /var/lib/mysql/ib_buffer_pool
2019-08-07 16:25:12 139995197208320 [Note] InnoDB: Buffer pool(s) dump completed at 190807 16:25:12
2019-08-07 16:25:14 139996208822016 [Note] InnoDB: Shutdown completed; log sequence number 1620183
2019-08-07 16:25:14 139996208822016 [Note] InnoDB: Removed temporary tablespace data file: "ibtmp1"
2019-08-07 16:25:14 139996208822016 [Note] /usr/sbin/mysqld: Shutdown complete

2019-08-07 16:25:14 139669141960896 [Note] InnoDB: Mutexes and rw_locks use GCC atomic builtins
2019-08-07 16:25:14 139669141960896 [Note] InnoDB: Uses event mutexes
2019-08-07 16:25:14 139669141960896 [Note] InnoDB: Compressed tables use zlib 1.2.7
2019-08-07 16:25:14 139669141960896 [Note] InnoDB: Using Linux native AIO
2019-08-07 16:25:14 139669141960896 [Note] InnoDB: Number of pools: 1
2019-08-07 16:25:14 139669141960896 [Note] InnoDB: Using SSE2 crc32 instructions
2019-08-07 16:25:14 139669141960896 [Note] InnoDB: Initializing buffer pool, total size = 128M, instances = 1, chunk size = 128M
2019-08-07 16:25:14 139669141960896 [Note] InnoDB: Completed initialization of buffer pool
2019-08-07 16:25:14 139668583855872 [Note] InnoDB: If the mysqld execution user is authorized, page cleaner thread priority can be changed. See the man page of setpriority().
2019-08-07 16:25:14 139669141960896 [Note] InnoDB: Highest supported file format is Barracuda.
2019-08-07 16:25:14 139669141960896 [Note] InnoDB: 128 out of 128 rollback segments are active.
2019-08-07 16:25:14 139669141960896 [Note] InnoDB: Creating shared tablespace for temporary tables
2019-08-07 16:25:14 139669141960896 [Note] InnoDB: Setting file './ibtmp1' size to 12 MB. Physically writing the file full; Please wait ...
2019-08-07 16:25:14 139669141960896 [Note] InnoDB: File './ibtmp1' size is now 12 MB.
2019-08-07 16:25:14 139669141960896 [Note] InnoDB: Waiting for purge to start
2019-08-07 16:25:14 139669141960896 [Note] InnoDB: 5.7.27 started; log sequence number 1620183
2019-08-07 16:25:14 139668284753664 [Note] InnoDB: Loading buffer pool(s) from /var/lib/mysql/ib_buffer_pool
2019-08-07 16:25:14 139668284753664 [Note] InnoDB: Buffer pool(s) load completed at 190807 16:25:14
2019-08-07 16:25:14 139669141960896 [Note] Plugin 'FEEDBACK' is disabled.
2019-08-07 16:25:14 139669141960896 [Note] Server socket created on IP: '::'.
2019-08-07 16:25:14 139669141960896 [Note] Reading of all Master_info entries succeeded
2019-08-07 16:25:14 139669141960896 [Note] Added new Master_info '' to hash table
2019-08-07 16:25:14 139669141960896 [Note] /usr/sbin/mysqld: ready for connections.
Version: '10.2.26-MariaDB-log'  socket: '/var/lib/mysql/mysql.sock'  port: 3306  MariaDB Server
```
***Thử tạo slow query***
```sh
mysql -u root -p

SELECT SLEEP(10);

exit;
```
***Log ghi nhận***
```sh
[root@client01 ~]# tailf /var/log/mariadb/slow.log 
# Time: 190807 16:27:27
# User@Host: root[root] @ localhost []
# Thread_id: 8  Schema:   QC_hit: No
# Query_time: 10.000389  Lock_time: 0.000000  Rows_sent: 1  Rows_examined: 0
# Rows_affected: 0
SET timestamp=1565170047;
SELECT SLEEP(10);
```
***Thử kết nối tới MariaDB thông qua CLI***
```sh
mysql -u root
exit;
```
***Log ghi nhận***
```sh
[root@client01 ~]# cat /var/log/mariadb/mysql.log 
190807 16:28:47     9 Connect   root@localhost as anonymous on
                    9 Query     select @@version_comment limit 1
190807 16:28:51     9 Quit
190807 16:28:55    10 Connect   root@localhost as anonymous on
                   10 Connect   Access denied for user 'root'@'localhost' (using password: YES)
190807 16:29:03    11 Connect   root@localhost as anonymous on
                   11 Query     select @@version_comment limit 1
```
***LOG Thao tác với MySQL***
Tất cả các thao tác đều được ghi vào `/var/log/mariadb/mysql.log`
```sh
[root@client01 ~]# tailf /var/log/mariadb/mysql.log
190807 16:26:22     8 Query     SELECT SLEEP(10)
190807 16:27:17     8 Query     SELECT SLEEP(10)
190807 16:28:37     8 Quit
190807 16:28:47     9 Connect   root@localhost as anonymous on
                    9 Query     select @@version_comment limit 1
190807 16:28:51     9 Quit
190807 16:28:55    10 Connect   root@localhost as anonymous on
                   10 Connect   Access denied for user 'root'@'localhost' (using password: YES)
190807 16:29:03    11 Connect   root@localhost as anonymous on
                   11 Query     select @@version_comment limit 1
190807 16:39:38    12 Connect   root@localhost as anonymous on
                   12 Query     select @@version_comment limit 1
190807 16:40:02    12 Query     show databases
190807 16:40:21    12 Query     create database test
190807 16:40:40    12 Query     drop test
190807 16:40:49    12 Query     drop databases test
190807 16:40:56    12 Query     dell databases test
190807 16:41:40    12 Query     create databases test1
190807 16:42:19    12 Query     create database test1
190807 16:42:34    12 Query     SELECT DATABASE()
                   12 Init DB   test1
                   12 Query     show databases
                   12 Query     show tables
190807 16:43:09    12 Query     create table table1
190807 16:43:37    12 Query     create table table1(ho, ten)
190807 16:44:32    12 Query     create table table1(ho NOT_NULL, ten NOT_NULL)
190807 16:44:52    12 Query     create table table1(ho NOT NULL, ten NOT NULL)
190807 16:46:19    12 Query     create table table1 (ho INT NOT NULL AUTO_INCREMENT, ten VARCHAR(50) NOT NULL)
190807 16:46:23    12 Query     create table table1 (ho INT NOT NULL AUTO_INCREMENT, ten VARCHAR(50) NOT NULL)
190807 16:46:55    12 Query     create table table1 (ho INT NOT NULL AUTO_INCREMENT, ten VARCHAR(50) NOT NULL, PRIMARY                  KEY (stt) )
190807 16:47:28    12 Query     create table table1 (ho INT NOT NULL AUTO_INCREMENT, ten VARCHAR(50) NOT NULL, PRIMARY                  KEY (ho) )
190807 16:48:15    12 Query     select * from table1
190807 16:48:20    12 Query     select * from table1
190807 16:48:29    12 Query     show tables
190807 16:48:48    12 Query     drop table tables1
190807 16:48:58    12 Query     drop table table1
190807 16:49:13    12 Query     drop database test1
                   12 Query     SELECT DATABASE()
190807 16:49:23    12 Query     show databases
190807 16:49:31    12 Quit
```



# Tài liệu tham khảo
- https://blogcloud365vn.github.io/linux/cau-hinh-log-mariadb-10.2/
