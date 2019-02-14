# Quản lý MYSQL trên VPS-Server Linux bằng câu lệnh.
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
Hiển thị toàn bộ databases: `mysql> SHOW DATABASES;`</br>
Tạo database: `mysql> CREATE DATABASE mydatabase;`</br>
Sử dụng một database: `mysql> USE mydatabase;` </br>
Xóa một database: `mysql> DROP DATABASE mydatabase;`</br>
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
**Tạo bảng:** `CREATE TABLE table-name(các trường trong bảng);`</br>
VD:
```sh
create table bang1( mssv INT NOT NULL AUTO_INCREMENT, ho VARCHAR(50) NOT NULL, ten VARCHAR(30) NOT NULL, diemthi FLOAT(2,2), PRIMARY KEY (mssv) );
```
Trong đó:</br>
- `NOT NULL` không được để trông giá trị
- `AUTO_INCREMENT` tự động tăng (giống STT)
- `PRIMARY KEY` khai báo khóa chính. Nếu khai báo nhiều khóa chính cùng lúc thì thay lại bằng câu `CONSTRAINT ma PRIMARY KEY (các trường)`
- Thiết lập khóa ngoại `FOREIGN KEY (Masv) REFERENCES HSSV(Masv)`

**Ghi dữ liệu:**
```sh
insert into tên-bảng ( truong1, truong2, ...)
Values (giá trị lần lượt theo các trường đã khai báo ở trên)
```
Chúng ta có một số kiểu dữ liệu sau:</br>
Kiểu số:
- INT
- FLOAT(n,m)- số thực dấu chấm động
- DOUBLE(n,m)

Kiểu date time:
- DATE YYYY-MM-DD. Ví dụ 2019-01-28.
- DATETIME YYYY-MM-DD HH:MM:SS. Ví dụ 23h00 ngày 28-01-2019 được biểu diễn 2019-01-28 23:00:00
- TIME HH:MM:SS
- YEAR(m) m có thể là 2 hoặc 4. Mặc định là 4

Kiểu chuỗi:
- CHAR(m) độ dài cố định từ 1 đến 255 ký tự. Nếu 1 trường kiểu char có độ dài không bằng độ dài khai báo thì phần còn thiếu được thêm bằng ký tự trắng.
- VARCHAR(m) độ dài có thể thay đổi.
- BLOB hoặc TEXT độ dài tối đa 65535 ký tự. BLOB sử dụng lưu trữ dữ liệu nhị phân như các bức ảnh hoặc tập nhị phân khác. BLOB phân biệt chữ hoa chữ thường còn TEXT thì không.

SELECT:</br>
- Kết hợp với các mệnh đề khác để truy xuất dữ liệu `SELECT các trường FROM tên-bảng`

Các trường có thể để là * nếu muốn truy xuất tất cả các trường trong bảng.

WHERE: `SELECT * FROM tên-bảng WHERE điều kiện`

VD: SELECT * FROM bang1 WHERE ten="niem";


UPDATE

Dùng để cập nhật dữ liệu của một hoặc nhiều trường

UPDATE tên-bảng SET truong1=gia-tri-moi, truong2=gia-tri-moi
WHERE
DELETE

DELETE FROM tên-bảng WHERE

Chú ý đến mệnh đề WHERE nếu ko có sẽ dẫn đến xóa cả bảng.

ORDER BY

Được sử dụng để sắp xếp kết quả hiển thị trả về

SELECT * FROM tên-bảng
ORDER BY truongn [ASC][DESC]
Có thể chọn kết quả trả về của bất kỳ trường nào Sử dụng một trong hai khóa ASC để hiển thị kết quả theo thứ tự tăng dần hoặc DESC để hiển thị theo giá trị giảm dần.

JOIN

Được dùng để lấy dữ liệu cùng lúc từ nhiều bảng và ghép chúng lại với nhau.

VD

SELECT a.mssv, a.ten, b.hocphi
FROM bang1 a, bang2 b
WHERE a.ten=b.ten;
Kết quả sẽ trả về mã số sv và tên trong bảng 1 và học phí trong bảng 2 nếu tên trong bảng 1 và bảng 2 là trùng nhau.

NULL

Để so sánh một trường nào đó với giá trị NULL ta dùng lệnh

truong1 IS NULL hoặc truong1 IS NOT NULL

ALTER

Lệnh này được dùng để thay đổi tên cho bảng hay bất kỳ trường nào cho bảng như thêm bớt sửa xóa.

VD: Xóa một trường ALTER TABLE tên-bảng DROP tên-trường

ADD thêm một trường sau trường nào đó ALTER TABLE tên-bảng ADD ten CHAR(40) AFTER hocphi; Thêm cột tên sau cột học phí.

Định nghĩa một trường theo tên mới

ALTER TABLE tên-bảng CHANGE ten hoten CHAR(40); Thay trường tên bằng họ tên.

**Một số lệnh để show thông tin trên Mysql server**
- select version() phiên bản server
- select database() tên database hiện tại
- select user() username hiện tại
- show status trạng thái server
- show variables các biến cấu hình server

BETWEEN

Thay vì dùng mệnh đề where như sau

select * from tên-bang
where diemthi >= 8 and diemthi <= 10;
Ta có thể sử dụng

select * from tên-bảng
where diemthi BETWEEN 8 and 10;

Hiển thị toàn bộ table: `mysql> SHOW TABLES;`</br>
Hiển thị dữ liệu của table: `mysql> SELECT * FROM tablename;`</br>
Đổi tên table : `mysql> RENAME TABLE first TO second;` hoặc `mysql> ALTER TABLE mytable rename as mynewtable;`</br>
Xóa table: `mysql> DROP TABLE mytable;`</br>
## 5. Các thao tác cột và hàng
Tất cả các thao tác bên dưới bạn phải lựa chọn trước database bằng cách dùng lệnh:
```sh
mysql> USE mydatabase;
```
- Hiển thị các column trong table: `mysql> DESC mytable;` hoặc `mysql> SHOW COLUMNS FROM mytable;`
- Đổi tên column: `mysql> UPDATE mytable SET mycolumn="newinfo" WHERE mycolumn="oldinfo"; `
- Select dữ liệu: `mysql> SELECT * FROM mytable WHERE mycolumn='mydata' ORDER BY mycolumn2;`
- Insert dữ liệu vào table: 
```sh
mysql> INSERT INTO mytable VALUES('column1data','column2data','column3data','column4data','column5data','column6data','column7data','column8data','column9data');
```
- Xóa dữ liệu trong table: `mysql> DELETE FROM mytable WHERE mycolumn="mydata";`
- Cập nhật dữ liệu trong table: `mysql> UPDATE mytable SET column1="mydata" WHERE column2="mydata";`

## 6. Các thao tác sao lưu và phục hồi
Sao lưu toàn bộ database bằng lệnh (chú ý không có khoảng trắng giữa -p và mật khẩu):
```sh
mysqldump -u root -pmypass --all-databases > alldatabases.sql
```
Sao lưu một database bất kỳ:
```sh
mysqldump -u username -pmypass databasename > database.sql
```
Khôi phục toàn bộ database bằng lệnh:
```sh
mysql -u username -pmypass < alldatabases.sql (no space in between -p and mypass)
```
Khôi phục một database bất kỳ:
```sh
mysql -u username -pmypass databasename < database.sql
```
Chỉ sao lưu cấu trúc database:
```sh
mysqldump --no-data --databases databasename > structurebackup.sql
```
Chỉ sao lưu cấu trúc nhiều database:
```sh
mysqldump --no-data --databases databasename1 databasename2 databasename3 > structurebackup.sql
```
Sao lưu một số table nhất định:
```sh
mysqldump --add-drop-table -u username -pmypass databasename table_1 table_2 > databasebackup.sql
```
