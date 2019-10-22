**Stop MariaDB sau đó khời động với tùy chọn không cần pass**
```
systemctl stop mariadb
mysqld_safe --skip-grant-tables &
```
** Đăng nhập MariaDB server với account `root`:
```sh
mysql -u root
```
Sử dụng command sau để rết password cho user root. Thay thế `your_password` bằng password của bạn.
```sh
use mysql;
update user SET PASSWORD=PASSWORD("your_password") WHERE USER='root';
flush privileges;
exit:
```
Sau đó restart MariaDB:
```sh
systemctl start mariadb
```
