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
$ mysql -u root -p
Enter password:
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 12
Server version: 10.2.22-MariaDB-log MariaDB Server

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

MariaDB [(none)]> exit
```
**Kiểm tra thư mục chứa log**
```sh
$ ll /var/log/mariadb/
total 28
-rw-rw---- 1 mysql mysql 20060 Mar  1 16:08 error.log
-rw-rw---- 1 mysql mysql  1474 Mar  1 16:29 mysql.log
-rw-r--r-- 1 mysql mysql  1328 Mar  1 16:07 slow.log
```
***Thử khởi động lại MariaDB***
```sh
systemctl restart mariadb
```
***Log ghi lại***
```sh
[root@thanhnb ~]# tailf /var/log/mariadb/error.log
2019-03-13 16:03:06 140448053733120 [Note] /usr/sbin/mysqld (initiated by: unknown): Normal shutdown
2019-03-13 16:03:06 140448053733120 [Note] Event Scheduler: Purging the queue. 0 events
2019-03-13 16:03:06 140447619991296 [Note] InnoDB: FTS optimize thread exiting.
2019-03-13 16:03:06 140448053733120 [Note] InnoDB: Starting shutdown...
2019-03-13 16:03:06 140447435450112 [Note] InnoDB: Dumping buffer pool(s) to /var/lib/mysql/ib_buffer_pool
2019-03-13 16:03:06 140447435450112 [Note] InnoDB: Buffer pool(s) dump completed at 190313 16:03:06
2019-03-13 16:03:07 140448053733120 [Note] InnoDB: Shutdown completed; log sequence number 1620097
2019-03-13 16:03:07 140448053733120 [Note] InnoDB: Removed temporary tablespace data file: "ibtmp1"
2019-03-13 16:03:07 140448053733120 [Note] /usr/sbin/mysqld: Shutdown complete

2019-03-13 16:03:07 139773417674944 [Note] InnoDB: Mutexes and rw_locks use GCC atomic builtins
2019-03-13 16:03:07 139773417674944 [Note] InnoDB: Uses event mutexes
2019-03-13 16:03:07 139773417674944 [Note] InnoDB: Compressed tables use zlib 1.2.7
2019-03-13 16:03:07 139773417674944 [Note] InnoDB: Using Linux native AIO
2019-03-13 16:03:07 139773417674944 [Note] InnoDB: Number of pools: 1
2019-03-13 16:03:07 139773417674944 [Note] InnoDB: Using SSE2 crc32 instructions
2019-03-13 16:03:07 139773417674944 [Note] InnoDB: Initializing buffer pool, total size = 128M, instances = 1, chunk size = 128M
2019-03-13 16:03:07 139773417674944 [Note] InnoDB: Completed initialization of buffer pool
2019-03-13 16:03:07 139772644132608 [Note] InnoDB: If the mysqld execution user is authorized, page cleaner thread priority can be changed. See the man page of setpriority().
2019-03-13 16:03:07 139773417674944 [Note] InnoDB: Highest supported file format is Barracuda.
2019-03-13 16:03:07 139773417674944 [Note] InnoDB: 128 out of 128 rollback segments are active.
2019-03-13 16:03:07 139773417674944 [Note] InnoDB: Creating shared tablespace for temporary tables
2019-03-13 16:03:07 139773417674944 [Note] InnoDB: Setting file './ibtmp1' size to 12 MB. Physically writing the file full; Please wait ...
2019-03-13 16:03:07 139773417674944 [Note] InnoDB: File './ibtmp1' size is now 12 MB.
2019-03-13 16:03:07 139773417674944 [Note] InnoDB: 5.7.25 started; log sequence number 1620097
2019-03-13 16:03:07 139772479641344 [Note] InnoDB: Loading buffer pool(s) from /var/lib/mysql/ib_buffer_pool
2019-03-13 16:03:07 139773417674944 [Note] Plugin 'FEEDBACK' is disabled.
2019-03-13 16:03:07 139772479641344 [Note] InnoDB: Buffer pool(s) load completed at 190313 16:03:07
2019-03-13 16:03:07 139773417674944 [Note] Server socket created on IP: '::'.
2019-03-13 16:03:07 139773417674944 [Note] Reading of all Master_info entries succeded
2019-03-13 16:03:07 139773417674944 [Note] Added new Master_info '' to hash table
2019-03-13 16:03:07 139773417674944 [Note] /usr/sbin/mysqld: ready for connections.
Version: '10.2.22-MariaDB-log'  socket: '/var/lib/mysql/mysql.sock'  port: 3306  MariaDB Server
```
***Thử tạo slow query***
```sh
mysql -u root

SELECT SLEEP(10);

exit;
```
***Log ghi nhận***
```sh
[root@thanhnb ~]# tailf /var/log/mariadb/slow.log 
/usr/sbin/mysqld, Version: 10.2.22-MariaDB-log (MariaDB Server). started with:
Tcp port: 0  Unix socket: (null)
Time                 Id Command    Argument
# Time: 190313 16:02:27
# User@Host: root[root] @ localhost []
# Thread_id: 9  Schema:   QC_hit: No
# Query_time: 10.000706  Lock_time: 0.000000  Rows_sent: 1  Rows_examined: 0
# Rows_affected: 0
SET timestamp=1552467747;
SELECT SLEEP(10);
```
***Thử kết nối tới MariaDB thông qua CLI***
```sh
mysql -u root
exit;
```
***Log ghi nhận***
```sh
[root@thanhnb ~]# cat /var/log/mariadb/mysql.log 
/usr/sbin/mysqld, Version: 10.2.22-MariaDB-log (MariaDB Server). started with:
Tcp port: 0  Unix socket: (null)
Time                 Id Command    Argument
190313 16:05:05	    8 Connect	root@localhost as anonymous on 
		    8 Query	select @@version_comment limit 1
190313 16:05:06	    8 Quit	
```
# Tài liệu tham khảo
- https://blogcloud365vn.github.io/linux/cau-hinh-log-mariadb-10.2/
