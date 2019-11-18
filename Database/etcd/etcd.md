# Etcd
## 1. Giới thiệu
`etcd` là cơ sở sử liệu phân tán. Dùng để lưu trữ các giá trị key-value quan trọng trong hệ thống phân tán. Nó được viết bằng Go và sử dụng thuật toán [Raft](http://thesecretlivesofdata.com/raft/) để quản lý highly-available replicated log.

`etcd` được thiết kế để: 
- Simple: well-defined, user-facing API (gRPC)
- Secure: automatic TLS with optional client cert authentication
- Fast: benchmarked 10,000 writes/sec
- Reliable: properly distributed using Raft

## 2. Setup Etcd Cluster trên CentOS 7/8, Ubuntu 18.04/16.04, Debian 10/9

**Mô hình cluster:**

|Server|IP|
|------|--|
|server01|10.10.10.221|
|server02|10.10.10.222|
|server03|10.10.10.223|

**Cài đặt trên tất cả các Node**
```sh
$ mkdir /tmp/etcd && cd /tmp/etcd
$ curl -s https://api.github.com/repos/etcd-io/etcd/releases/latest \
  | grep browser_download_url \
  | grep linux-amd64 \
  | cut -d '"' -f 4 \
  | wget -qi -
```
**Giải nén và move sang thư mục `/usr/local/bin`**
```sh
tar xvf *.tar.gz
cd etcd-*/
sudo mv etcd* /usr/local/bin/
cd ~
rm -rf /tmp/etcd
```
**Tạo thư mục `etcd`**

File config etcd được lưu trong `/etc/etcd` và data lưu trong `/var/lib/etcd`. 

`user` và `group` được sử dụng để quản lý service được gọi là `etcd`.

Tạo user/group hệ thống `etcd`.
```sh
sudo groupadd --system etcd
sudo useradd -s /sbin/nologin --system -g etcd etcd
```

Tạo thư mục data và config cho `etcd`.
```sh
  sudo mkdir -p /var/lib/etcd/
  sudo mkdir /etc/etcd
  sudo chown -R etcd:etcd /var/lib/etcd/
```

**Configure `etcd`**

Tạo biến để cấu hình 
```sh
INT_NAME="eth0"
ETCD_HOST_IP=$(ip addr show $INT_NAME | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
ETCD_NAME=$(hostname -s)
```
Trong đó:
- `INT_NAME` tên network interface sử dụng cho cluster traffic. Ở đây là `eth0`
- `ETCD_HOST_IP` IP của network interface. Sử dụng để giao tiếp với `etcd` cluster.
- `ETCD_NAME` – hostname của máy.

Tạo file `etcd.service` 
```sh
cat <<EOF | sudo tee /etc/systemd/system/etcd.service
[Unit]
Description=etcd service
Documentation=https://github.com/etcd-io/etcd

[Service]
Type=notify
User=etcd
ExecStart=/usr/local/bin/etcd \\
  --name ${ETCD_NAME} \\
  --data-dir=/var/lib/etcd \\
  --initial-advertise-peer-urls http://${ETCD_HOST_IP}:2380 \\
  --listen-peer-urls http://${ETCD_HOST_IP}:2380 \\
  --listen-client-urls http://${ETCD_HOST_IP}:2379,http://127.0.0.1:2379 \\
  --advertise-client-urls http://${ETCD_HOST_IP}:2379 \\
  --initial-cluster-token etcd-cluster-0 \\
  --initial-cluster etcd1=http://etcd1:2380,etcd2=http://etcd2:2380,etcd3=http://etcd3:2380 \\
  --initial-cluster-state new \

[Install]
WantedBy=multi-user.target
EOF
```
Trong đó: 
- `--initial-advertise-peer-urls=http://localhost:2380`: Danh sách URLs ngang hàng của member để quảng bá cho phần còn lại của cluster
- `--initial-cluster="default=http://localhost:2380`: Cấu hình cluster
- `--initial-cluster-token=etcd-cluster-0`: Cluster token cho etcd cluster 
- `--name=default`: Tên member

Nếu không mappings name trong file `/etc/hosts` file thì thay `etcd1`, `etcd2`, `etcd3` bằng IP của Node.

Tắt `SELINUX` và disable `firewalld`
```sh
$ sudo setenforce 0
$ sudo sed -i 's/^SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config

# If you have active firewall service, allow ports 2379 and 2380.
# RHEL / CentOS / Fedora firewalld
$ sudo firewall-cmd --add-port={2379,2380}/tcp --permanent
$ sudo firewall-cmd --reload

# Ubuntu/Debian
sudo ufw allow proto tcp from any to any port 2379,2380
```
**Start `etcd` Server**
```sh
sudo systemctl daemon-reload
sudo systemctl enable etcd
sudo systemctl start etcd
```
**Kiểm tra servvice `etcd` đang chạy trên các Node.**
```sh
[root@etcd1 ~]# systemctl status etcd -l
● etcd.service - etcd service
   Loaded: loaded (/etc/systemd/system/etcd.service; disabled; vendor preset: disabled)
   Active: active (running) since Wed 2019-11-13 11:52:57 +07; 1h 55min ago
     Docs: https://github.com/etcd-io/etcd
 Main PID: 1993 (etcd)
   CGroup: /system.slice/etcd.service
           └─1993 /usr/local/bin/etcd --name etcd1 --data-dir=/var/lib/etcd --initial-advertise-peer-urls http://10.10.10.221:2380 --listen-peer-urls http://10.10.10.221:2380 --listen-client-urls http://10.10.10.221:2379,http://127.0.0.1:2379 --advertise-client-urls http://10.10.10.221:2379 --initial-cluster-token etcd-cluster-0 --initial-cluster etcd1=http://etcd1:2380,etcd2=http://etcd2:2380,etcd3=http://etcd3:2380 --initial-cluster-state new
....................................................................................
[root@etcd3 ~]# systemctl status etcd -l
● etcd.service - etcd service
   Loaded: loaded (/etc/systemd/system/etcd.service; enabled; vendor preset: disabled)
   Active: active (running) since Wed 2019-11-13 11:42:50 +07; 2h 5min ago
     Docs: https://github.com/etcd-io/etcd
 Main PID: 9384 (etcd)
   CGroup: /system.slice/etcd.service
           └─9384 /usr/local/bin/etcd --name etcd3 --data-dir=/var/lib/etcd --initial-advertise-peer-urls http://10.10.10.223:2380 --listen-peer-urls http://10.10.10.223:2380 --listen-client-urls http://10.10.10.223:2379,http://127.0.0.1:2379 --advertise-client-urls http://10.10.10.223:2379 --initial-cluster-token etcd-cluster-0 --initial-cluster etcd1=http://etcd1:2380,etcd2=http://etcd2:2380,etcd3=http://etcd3:2380 --initial-cluster-state new
....................................................................................
```
```sh
$ etcdctl member list
152d6f8123c6ac97: name=etcd3 peerURLs=http://etcd3:2380 clientURLs=http://10.10.10.223:2379 isLeader=false
332a8a315e569778: name=etcd2 peerURLs=http://etcd2:2380 clientURLs=http://10.10.10.222:2379 isLeader=true
aebb404b9385ccd4: name=etcd1 peerURLs=http://etcd1:2380 clientURLs=http://10.10.10.221:2379 isLeader=false
```
```sh
$ etcdctl cluster-health
member 152d6f8123c6ac97 is healthy: got healthy result from http://10.10.10.223:2379
member 332a8a315e569778 is healthy: got healthy result from http://10.10.10.222:2379
member aebb404b9385ccd4 is healthy: got healthy result from http://10.10.10.221:2379
cluster is healthy
```
## 2. Thực hiện test cluster 
**Ghi vào `etcd`**.
```sh
[root@etcd1 ~]# etcdctl set /message "Hello World"
Hello World
--------------------------------------------------
[root@etcd2 ~]# etcdctl get /message
Hello World
--------------------------------------------------
[root@etcd3 ~]# etcdctl get /message
Hello World
```
**Tạo thư mục**
```sh
[root@etcd1 ~]# etcdctl mkdir /myservice
[root@etcd1 ~]# etcdctl set /myservice/container1 localhost:8080
localhost:8080
----------------------------------------------------------------
[root@etcd2 ~]# etcdctl ls /myservice
/myservice/container1
[root@etcd3 ~]# etcdctl ls /myservice
/myservice/container1
```
**Test Leader failure**

Khi Leader fails, etcd cluster tự động bầu Leader mới. Cần 1 khoảng thời gian để bầu Leader mới. Trong quá trình bầu chọn không thể thực hiện bất kì process nào cho đến khi có Leader mới.
```sh
[root@etcd1 ~]# etcdctl member list
152d6f8123c6ac97: name=etcd3 peerURLs=http://etcd3:2380 clientURLs=http://10.10.10.223:2379 isLeader=false
332a8a315e569778: name=etcd2 peerURLs=http://etcd2:2380 clientURLs=http://10.10.10.222:2379 isLeader=true
aebb404b9385ccd4: name=etcd1 peerURLs=http://etcd1:2380 clientURLs=http://10.10.10.221:2379 isLeader=false
``` 
***Node 2 đang là Leader, Stop Service trên Node 2***
```sh
[root@etcd2 ~]# systemctl stop etcd
```
```sh
[root@etcd1 ~]# etcdctl member list
152d6f8123c6ac97: name=etcd3 peerURLs=http://etcd3:2380 clientURLs=http://10.10.10.223:2379 isLeader=true
332a8a315e569778: name=etcd2 peerURLs=http://etcd2:2380 clientURLs=http://10.10.10.222:2379 isLeader=false
aebb404b9385ccd4: name=etcd1 peerURLs=http://etcd1:2380 clientURLs=http://10.10.10.221:2379 isLeader=false
```
***Node 3 lên làm Leader***

**Hiện Node 3 đang là Leader, Stop network trên Node 3 và kiểm tra hoạt động**

Node 1 lên làm Leader và thực hiện ghi dữ liệu trên Node 1
```sh
[root@etcd1 ~]# etcdctl member list
152d6f8123c6ac97: name=etcd3 peerURLs=http://etcd3:2380 clientURLs=http://10.10.10.223:2379 isLeader=false
332a8a315e569778: name=etcd2 peerURLs=http://etcd2:2380 clientURLs=http://10.10.10.222:2379 isLeader=false
aebb404b9385ccd4: name=etcd1 peerURLs=http://etcd1:2380 clientURLs=http://10.10.10.221:2379 isLeader=true
[root@etcd1 ~]# etcdctl mkdir /test
[root@etcd1 ~]# etcdctl set /test/container2 localhost:8080
```
Node 2 có dữ liệu
```sh
[root@etcd2 ~]# etcdctl ls /test
/test/container2
```
***Node 3 không còn là Leader nến quá trình ghi dữ liệu không thực hiện được***

**Kết nối lại Internet trên Node 3**
***Dữ liệu được đồng bộ lại trên 3 Node***
```sh
[root@etcd3 ~]# etcdctl ls /test
/test/container2
```
## 3. Backup and Restore
Data được lưu trong thư mục `/var/lib/etcd/`. Backup thư mục này:
```sh
cp /var/lib/etcd/member backup
```

**Restore**

Copy thư mục `backup` vào `/var/lib/etcd/`
```sh
mv backup/member /var/lib/etcd/
chown -R etcd:etcd /var/lib/etcd/
systemctl daemon-reload
systemctl start etcd
```
-----------------------------------------------------------------------------------------------------------------

**Backup trên 1 Node**
```sh
ETCDCTL_API=3 etcdctl --endpoints=https://10.10.10.221:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/healthcheck-client.crt \
  --key=/etc/kubernetes/pki/etcd/healthcheck-client.key \
snapshot save /backup/etcd-snapshot-$(date +%Y-%m-%d_%H:%M:%S_%Z).db

ETCDCTL_API=3 etcdctl --endpoints 10.10.10.221:2379 snapshot save snapshot.db
```
---------------------------------------------------------------------------------------------------------------
```sh
ETCDCTL_API=3 etcdctl snapshot restore snapshot.db


ETCDCTL_API=3 etcdctl snapshot restore snapshot-188.db \
--name etcd1 \
--initial-cluster etcd1=http://10.10.10.221:2380,etcd2=http://10.10.10.222:2380,etcd3=http://10.10.10.223:2380 \
--initial-cluster-token my-etcd-token \
--initial-advertise-peer-urls http://10.10.10.221:2380

ETCDCTL_API=3 etcdctl snapshot restore snapshot-136.db \
--name etcd2 \
--initial-cluster etcd1=http://10.10.10.221:2380,etcd2=http://10.10.10.222:2380,etcd3=http://10.10.10.223:2380 \
--initial-cluster-token my-etcd-token \
--initial-advertise-peer-urls http://10.10.10.222:2380

ETCDCTL_API=3 etcdctl snapshot restore snapshot-155.db \
--name etcd3 \
--initial-cluster etcd1=http://10.10.10.221:2380,etcd2=http://10.10.10.222:2380,etcd3=http://10.10.10.223:2380 \
--initial-cluster-token my-etcd-token \
--initial-advertise-peer-urls http://10.10.10.223:2380
```

## 3. Một số command hay dùng
- etcdctl member remove xxx: Remove Node 
- etcdctl ls
- etcdctl member list
- etcdctl get
- etcdctl set
- etcdctl cluster-health
- systemctl status etcd
- ETCDCTL_API=3 etcdctl put
- ETCDCTL_API=3 etcdctl get
- ETCDCTL_API=3 etcdctl get --prefix name

## 4. Tham khảo thêm 

Mặc định, `etcdctl` sử dụng `etcd v2`. Nên cần sử dụng 1 biến rõ ràng `ETCDCTL_API=3` để truy cập chức năng `etcd v3`.

Có thể set như sau: 
```sh
ETCDCTL_API=3 etcdctl put name1 batman
ETCDCTL_API=3 etcdctl put name2 ironman
ETCDCTL_API=3 etcdctl put name3 superman
ETCDCTL_API=3 etcdctl put name4 spiderman
```
Now you can try getting the value of name3 using the following command.
```sh
ETCDCTL_API=3 etcdctl get name3
```
You can list all the keys using ranges and prefixes
```sh
ETCDCTL_API=3 etcdctl get name1 name4 # lists range name1 to name 4
ETCDCTL_API=3 etcdctl get --prefix name # lists all keys with name prefix
```
**Sử dụng API version 3**
```sh
[root@etcd1 ~]# export ETCDCTL_API=3
[root@etcd1 ~]# etcdctl --write-out=table --endpoints=localhost:2379 member list
+------------------+---------+-------+-------------------+--------------------------+
|        ID        | STATUS  | NAME  |    PEER ADDRS     |       CLIENT ADDRS       |
+------------------+---------+-------+-------------------+--------------------------+
| 152d6f8123c6ac97 | started | etcd3 | http://etcd3:2380 | http://10.10.10.223:2379 |
| 332a8a315e569778 | started | etcd2 | http://etcd2:2380 | http://10.10.10.222:2379 |
| aebb404b9385ccd4 | started | etcd1 | http://etcd1:2380 | http://10.10.10.221:2379 |
+------------------+---------+-------+-------------------+--------------------------+
```

## Tài liệu tham khảo
- https://computingforgeeks.com/setup-etcd-cluster-on-centos-debian-ubuntu/
- https://github.com/etcd-io/etcd/blob/master/Documentation/v2/admin_guide.md#disaster-recovery
- https://github.com/etcd-io/etcd/blob/master/Documentation/op-guide/recovery.md
