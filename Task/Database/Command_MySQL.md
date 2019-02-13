# Hướng dẫn quản ly MYSQL trên VPS-Server Linux bằng câu lệnh.
## Đăng nhập MySQL bạn dùng lệnh:
```sh
mysql -u root -p
```
## 1. Thư mục chứa database
Trên CentOS, toàn bộ file raw database được lưu trong thư mục `/var/lib/mysql`
## 2. Quản lý tài khoản và phân quyền
Hiển thị toàn bộ users:
```sh
mysql> SELECT * FROM mysql.user;
```
Xóa null user:
```sh
mysql> DELETE FROM mysql.user WHERE user = ' ';
```
Xóa tất cả user mà không phải root:
```sh
mysql> DELETE FROM mysql.user WHERE NOT (host="localhost" AND user="root");
```
Đổi tên tài khoản root (giúp bảo mật):
```sh
mysql> UPDATE mysql.user SET user="mydbadmin" WHERE user="root";
```
Gán full quyền cho một user mới:
```sh
mysql> GRANT ALL PRIVILEGES ON *.* TO 'username'@'localhost' IDENTIFIED BY 'mypass' WITH GRANT OPTION;
```
Phân quyền chi tiết cho một user mới:
```sh
mysql> GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, CREATE TEMPORARY TABLES, LOCK TABLES ON mydatabase.* TO 'username'@'localhost' IDENTIFIED BY 'mypass';
```
Gán full quyền cho một user mới trên một database nhất định:
```sh
mysql> GRANT ALL PRIVILEGES ON mydatabase.* TO 'username'@'localhost' IDENTIFIED BY 'mypass' WITH GRANT OPTION;
```
Thay đổi mật khẩu user:
```sh
mysql> UPDATE mysql.user SET password=PASSWORD("newpass") WHERE User='username';
```
Xóa user:
```sh
mysql> DELETE FROM mysql.user WHERE user="username";
```
## 3. Các thao tác database
Hiển thị toàn bộ databases:
```sh
mysql> SHOW DATABASES;
```
Tạo database:
```sh
mysql> CREATE DATABASE mydatabase;
```
Sử dụng một database:
```sh
mysql> USE mydatabase;
``` 
Xóa một database:
```sh
mysql> DROP DATABASE mydatabase;
```
Tối ưu database:
- All Databases:
```sh
$ sudo mysqlcheck -o --all-databases -u root -p
```
- Single Database:
```sh
$ sudo mysqlcheck -o db_schema_name -u root -p
```
## 4. Các thao tác table
Tất cả các thao tác bên dưới bạn phải lựa chọn trước database bằng cách dùng lệnh:
```sh
mysql> USE mydatabase;
```
Hiển thị toàn bộ table:
```sh
mysql> SHOW TABLES;
```

Hiển thị dữ liệu của table:

mysql> SELECT * FROM tablename;

 

Đổi tên table :

mysql> RENAME TABLE first TO second;

hoặc

mysql> ALTER TABLE mytable rename as mynewtable;

 

Xóa table:

mysql> DROP TABLE mytable;

5. Các thao tác cột và hàng

Tất cả các thao tác bên dưới bạn phải lựa chọn trước database bằng cách dùng lệnh: mysql> USE mydatabase;

Hiển thị các column trong table:

mysql> DESC mytable;

hoặc

mysql> SHOW COLUMNS FROM mytable;

 

Đổi tên column:

mysql> UPDATE mytable SET mycolumn="newinfo" WHERE mycolumn="oldinfo";

 

Select dữ liệu:

mysql> SELECT * FROM mytable WHERE mycolumn='mydata' ORDER BY mycolumn2;

 

Insert dữ liệu vào table:

mysql> INSERT INTO mytable VALUES('column1data','column2data','column3data','column4data','column5data','column6data','column7data','column8data','column9data');

 

Xóa dữ liệu trong table:

mysql> DELETE FROM mytable WHERE mycolumn="mydata";

 

Cập nhật dữ liệu trong table:

mysql> UPDATE mytable SET column1="mydata" WHERE column2="mydata";

6. Các thao tác sao lưu và phục hồi

Sao lưu toàn bộ database bằng lệnh (chú ý không có khoảng trắng giữa -p và mật khẩu):

mysqldump -u root -pmypass --all-databases > alldatabases.sql

 

Sao lưu một database bất kỳ:

mysqldump -u username -pmypass databasename > database.sql

 

Khôi phục toàn bộ database bằng lệnh:

mysql -u username -pmypass < alldatabases.sql (no space in between -p and mypass)

 

Khôi phục một database bất kỳ:

mysql -u username -pmypass databasename < database.sql

 

Chỉ sao lưu cấu trúc database:

mysqldump --no-data --databases databasename > structurebackup.sql

 

Chỉ sao lưu cấu trúc nhiều database:

mysqldump --no-data --databases databasename1 databasename2 databasename3 > structurebackup.sql

 

Sao lưu một số table nhất định:

mysqldump --add-drop-table -u username -pmypass databasename table_1 table_2 > databasebackup.sql
