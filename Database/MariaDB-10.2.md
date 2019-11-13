# Cài đặt MariaDB 10.2

## 1. Add MariaDB Yum Repository
```
vi /etc/yum.repos.d/MariaDB.repo
```
## Thêm vào dòng sau:
```sh
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.2/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
```
## Chạy update
```sh
yum update -y
```
## Cài đặt MariaDB 10.2
```sh
yum install mariadb-server -y
```
