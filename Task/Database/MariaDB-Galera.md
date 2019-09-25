# Giới thiệu về MariaDB Galery Cluster
MariaDB Galera Cluster hỗ trợ đồng bộ dữ liệu MariaDB trên nhiều máy chủ trong cùng một cụm. Giữ cho các máy chủ lưu trữ dữ liệu MariaDB trên tất cả các máy chủ đồng bộ với nhau, trong đó tất cả các máy chủ đều là master, nên có thể đọc ghi như nhau trên tất cả các máy chủ trong mạng lưới. Và quan trọng hơn nó là một phần mềm miễn phí.

Hạn chế của MariaDB Galera Cluster là chỉ có thể sử dụng với kiểu lưu trữ InnoDB.
## 1. Cấu hình MariaDB Galery Cluster
MariaDB Galery Cluster đã được tích hợp sẵn trong các phiên bản của MariaDB Server

Hệ thống sử dụng trong bài viết: 2 server cấu hình

CentOS 7.

MariaDB 10.2.

IP: 10.10.10.221, 10.10.10.222

***Lưu ý: Không khởi động dịch vụ mariadb sau khi cài (Liên quan tới cấu hình Galera Mariadb)***

Vào file cấu hình của 2 máy và sửa như sau:
```sh
vim /etc/my.cnf.d/server.cnf
```
Máy 10.10.10.221:
```sh
[galera]
wsrep_on=ON
wsrep_provider=/usr/lib64/galera/libgalera_smm.so
wsrep_cluster_address=gcomm://10.10.10.221,10.10.10.222
binlog_format=row
default_storage_engine=InnoDB
innodb_autoinc_lock_mode=2
wsrep_node_name=Node1
wsrep_node_address=10.10.10.221
```
Trong đó:
- **wsrep_on=ON**: bắt buộc phải là ON
- **wsrep_provider=/usr/lib64/galera/libgalera_smm.so** : đường dẫn đến thư viện của MariaDB Galery Cluster
- **wsrep_cluster_address=gcomm://192.168.10.11,192.168.10.12** : danh sách các máy trong cụm
- **wsrep_node_name=Node1**: đặt tên node trong trong cụm
- **wsrep_node_address=10.10.10.221**: ip của máy hiện tại đang cấu hình

Máy 10.10.10.222:
```sh
[galera]
wsrep_on=ON
wsrep_provider=/usr/lib64/galera/libgalera_smm.so
wsrep_cluster_address=gcomm://10.10.10.221,10.10.10.222
binlog_format=row
default_storage_engine=InnoDB
innodb_autoinc_lock_mode=2
wsrep_node_name=Node1
wsrep_node_address=10.10.10.222
```
Mặc định phương thức đồng bộ của MariaDB Galery Cluster là rsyns.

Sau khi cài đặt xong chúng ta cần mở thêm các port tpc: 4444, 4567,4568 trong firewall
```sh
firewall-cmd --permanent --add-port={4567,4568,4444}/tcp
```

## Khởi động dịch vụ

Tại node1, khởi tạo cluster
```sh
galera_new_cluster
systemctl start mariadb
systemctl enable mariadb
```
Tại node2, node3, chạy dịch vụ mariadb
```sh
systemctl start mariadb
systemctl enable mariadb
```
Kiểm tra tại node1
```sh
mysql -u root -e "SHOW STATUS LIKE 'wsrep_cluster_size'"
```
<img src=https://i.imgur.com/VYsahhH.png>

## 2. Kiểm tra kết quả
- Show database trên 2 host
<img src=https://i.imgur.com/eY5LbML.png>

- Tạo thêm 1 bảng `test_2` sau đó kiểm tra database trên 2 host
<img src=https://i.imgur.com/yiWglyc.png>

**2.1 Tắt 1 trong số các host trong cụm cluster**
- `galera_new_cluster` trên host `10.10.10.222`
- host `10.10.10.221` bị restart
- Tạo thêm 1 database trên host `10.10.10.222`
- Cụm Cluster vẫn chạy bình thường

**2.2 Restart cả cụm Cluster**
- Cụm cluster bị lỗi
- `galera_new_cluster` trên host `10.10.10.222`
- stop dịch vụ `systemctl stop mariadb`
- `galera_new_cluster` trên host `10.10.10.222`
- Restart lại dịch vụ trên các host còn lại
- Cụm trờ lại hoạt động bình thường
