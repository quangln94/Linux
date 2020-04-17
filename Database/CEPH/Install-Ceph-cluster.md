# Cài đặt Ceph Nautilus trên CentOS 7 sử dụng ceph-deploy.
## Mô hình Lab

|Server|ceph01|ceph02|
|------|------|------|
|IP|192.168.20.51|192.168.20.52|

## 1. Cấu hình trên tất cả các Node
- Tạo user `cephuser` trên tất cả các Node.
```sh
useradd -d /home/cephuser -m cephuser
passwd cephuser
```
- Cấu hình sudo cho `cephuser` như user root.
```sh
echo "cephuser ALL = (root) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/cephuser
chmod 440 /etc/sudoers.d/cephuser
sed -i s'/Defaults requiretty/#Defaults requiretty'/g /etc/sudoers
```
- Cầu hình firewall
```sh
firewall-cmd --add-service=ssh --permanent
firewall-cmd --reload
```
- Install and Configure NTP
```sh
yum install chrony -y
timedatectl set-timezone Asia/Ho_Chi_Minh

sed -i 's/server 0.centos.pool.ntp.org iburst/ \
server 0.asia.pool.ntp.org iburst \
server 1.asia.pool.ntp.org iburst/g' /etc/chrony.conf

sed -i 's/server 1.centos.pool.ntp.org iburst/#server 1.centos.pool.ntp.org iburst/g' /etc/chrony.conf
sed -i 's/server 2.centos.pool.ntp.org iburst/#server 2.centos.pool.ntp.org iburst/g' /etc/chrony.conf
sed -i 's/server 3.centos.pool.ntp.org iburst/#server 3.centos.pool.ntp.org iburst/g' /etc/chrony.conf
```
systemctl enable chronyd.service
systemctl start chronyd.service
- Disable SELinux
```sh
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
```
- Cấu hình file `/etc/hosts`
```sh
192.168.20.51     ceph01
192.168.20.52     ceph02
```
- Khai báo repo cho ceph nautilus
```sh
cat << EOF >> /etc/yum.repos.d/ceph.repo
[ceph]
name=Ceph packages for $basearch
baseurl=https://download.ceph.com/rpm-nautilus/el7/x86_64/
enabled=1
priority=2
gpgcheck=1
gpgkey=https://download.ceph.com/keys/release.asc

[ceph-noarch]
name=Ceph noarch packages
baseurl=https://download.ceph.com/rpm-nautilus/el7/noarch
enabled=1
priority=2
gpgcheck=1
gpgkey=https://download.ceph.com/keys/release.asc

[ceph-source]
name=Ceph source packages
baseurl=https://download.ceph.com/rpm-nautilus/el7/SRPMS
enabled=0
priority=2
gpgcheck=1
gpgkey=https://download.ceph.com/keys/release.asc
EOF
```
- Thực hiện update sau khi khai bao repo
```sh
yum update -y
```
## 2. Cài đặt ceph-deploy và cấu hình
Theo docs của CEPH thì ta có thể cài đặt CEPH theo 03 cách, bao gồm: CEPH manual, ceph-deploy và ceph-ansible. Trong hướng dẫn này sẽ sử dụng ceph-deploy, một công cụ để triển khai CEPH.

Trong một số mô hình, Node cài đặt `ceph-deploy` được gọi là Node admin. Trong hướng dẫn này chỉ cần đứng trên `ceph01` thực hiện, một số thao tác trên node `ceph02` sẽ thực hiện từ xa ngay trên `ceph01`.

## Thực hiện trên Node 1:
```sh
yum install -y epel-release
yum install -y ceph-deploy
```
Tạo `ssh-key`, sau đó copy sang các Node còn lại. Lưu ý không dùng sudo với lệnh `ssh-keygen` với user khác `root`.

```sh
su cephuser
cd
ssh-keygen
```
Copy public key sang các Node còn lại.
```sh
ssh-copy-id root@ceph02
```
Tạo thư mục chứa các file cấu hình khi cài đặt CEPH
```sh
cd ~
mkdir my-cluster
cd my-cluster
```
- Khai báo các Node ceph trong cluser.
```sh
ceph-deploy new ceph01 ceph02
```
Lệnh trên sẽ sinh ra các file cấu hình trong thư mục hiện tại, kiểm tra bằng lệnh
```sh
[root@ceph01 my-cluster]# ls -alh
-rw-r--r--  1 root root  219 Mar  3 14:25 ceph.conf
-rw-r--r--  1 root root 183K Mar  3 14:48 ceph-deploy-ceph.log
-rw-------  1 root root   73 Mar  3 14:25 ceph.mon.keyring
```
Khai báo thêm các tùy chọn cho việc triển khai, vận hành CEPH vào file `ceph.conf` này trước khi cài đặt các gói cần thiết cho ceph trên các Node. Lưu ý các tham số về network.

Ta sẽ dụng `vlan: 192.168.62.0/24` cho đường truy cập của các client(ceph public). `Vlan: 192.168.63.0/24` cho đường replicate dữ liệu, các dữ liệu sẽ được sao chép & nhân bản qua vlan này.
```sh
echo "public network = 192.168.62.0/24" >> ceph.conf
echo "cluster network = 192.168.63.0/24" >> ceph.conf
echo "osd objectstore = bluestore"  >> ceph.conf
echo "mon_allow_pool_delete = true"  >> ceph.conf
echo "osd pool default size = 3"  >> ceph.conf
echo "osd pool default min size = 1"  >> ceph.conf
```
Bắt đầu cài đặt phiên bản CEPH Nautilus lên các node ceph01, ceph02. Lệnh dưới sẽ cài đặt lần lượt lên các Node.
```sh
ceph-deploy install --release nautilus ceph01 ceph02
```
Thiết lập thành phần MON cho CEPH. Trong hướng dẫn này khai báo 02 Node đều có thành phần MON của CEPH.
```sh
ceph-deploy mon create-initial
```
Kết quả sinh ra các file trong thư mục hiện tại
```sh
[root@ceph01 my-cluster]# ls -alh
total 212K
drwxr-xr-x  2 root root  244 Mar  3 14:34 .
dr-xr-x---. 5 root root  217 Mar  3 16:49 ..
-rw-------  1 root root  113 Mar  3 14:34 ceph.bootstrap-mds.keyring
-rw-------  1 root root  113 Mar  3 14:34 ceph.bootstrap-mgr.keyring
-rw-------  1 root root  113 Mar  3 14:34 ceph.bootstrap-osd.keyring
-rw-------  1 root root  113 Mar  3 14:34 ceph.bootstrap-rgw.keyring
-rw-------  1 root root  151 Mar  3 14:34 ceph.client.admin.keyring
-rw-r--r--  1 root root  219 Mar  3 14:25 ceph.conf
-rw-r--r--  1 root root 183K Mar  3 14:48 ceph-deploy-ceph.log
-rw-------  1 root root   73 Mar  3 14:25 ceph.mon.keyring
```
Thực hiện copy file `ceph.client.admin.keyring` sang các Node trong cụm Ceph-cluster. File này sẽ được copy vào thư mục `/etc/ceph/` trên các Node.
```sh
ceph-deploy admin ceph01 ceph02
```
Đứng trên Node `ceph01` phân quyền cho file `/etc/ceph/ceph.client.admin.keyring` cho cả 2 Node.
```sh
ssh root@ceph01 'sudo chmod +r /etc/ceph/ceph.client.admin.keyring'
ssh root@ceph02 'sudo chmod +r /etc/ceph/ceph.client.admin.keyring'
ssh root@ceph03 'sudo chmod +r /etc/ceph/ceph.client.admin.keyring'
```
Đứng trên Node `ceph01` và thực hiện khai báo các OSD disk. Bước này sẽ thực hiện format các disk trên cả 2 Node và join chúng vào làm các OSD (Thành phần chứa dữ liệu của CEPH).
```sh
ceph-deploy osd create --data /dev/vdb ceph01
ceph-deploy osd create --data /dev/vdc ceph01

ceph-deploy osd create --data /dev/vdb ceph02
ceph-deploy osd create --data /dev/vdc ceph02
```
Tới đây các bước cơ bản cấu hình ceph cluser đã hoàn tất. Kiểm tra trạng thái của cụm `Ceph-cluster` bằng lệnh 
```sh
$ ceph -s
[root@ceph01 my-cluster]# ceph -s
  cluster:
    id:     9691b2b5-a858-45b7-a239-4de3e1ff69c6
    health: HEALTH_WARN
            no active mgr

  services:
    mon: 2 daemons, quorum ceph01,ceph02 (age 4m)
    mgr: no daemons active
    osd: 4 osds: 4 up (since 6s), 4 in (since 6s)

  data:
    pools:   0 pools, 0 pgs
    objects: 0 objects, 0 B
    usage:   0 B used, 0 B / 0 B avail
    pgs:
```
Ta thấy trạng thái sẽ là `HEALTH_WARN`, lý do là vì `ceph-mgr` chưa được enable. Tiếp theo ta sẽ xử lý để kích hoạt `ceph-mgr`

## Cấu hình manager và dashboad cho ceph cluster
Ceph-dashboard là một thành phần thuộc `ceph-mgr`. Trong bản Nautilus thì thành phần dashboard được cả tiến khá lớn. Cung cấp nhiều quyền hạn thao tác với CEPH hơn các bản trước đó (thành phần này được đóng góp chính bởi team SUSE).

Thực hiện trên Node `ceph01` việc cài đặt này.

Trong bản ceph nautilus 14.2.3 (tính đến ngày 06.09.2019), khi cài ceph dashboard theo các cách cũ gặp một vài vấn đề, cách xử lý như sau.

Cài thêm các gói bổ trợ trước khi cài
```sh
sudo yum install -y python-jwt python-routes
```
Tải `ceph-mgr-dashboard` và `ceph-grafana-dashboards`. Lưu ý nên đúng phiên bản `ceph-14.2.8` ở trên [tại đây](http://download.ceph.com/rpm-nautilus/el7/noarch/).
```sh
sudo rpm -Uvh http://download.ceph.com/rpm-nautilus/el7/noarch/ceph-grafana-dashboards-14.2.8-0.el7.noarch.rpm
sudo rpm -Uvh http://download.ceph.com/rpm-nautilus/el7/noarch/ceph-mgr-dashboard-14.2.8-0.el7.noarch.rpm
```
Thực hiện kích hoạt ceph-mgr và ceph-dashboard
```sh
ceph-deploy mgr create ceph01 ceph02
ceph mgr module enable dashboard --force
ceph mgr module ls 
```
Kết quả
```sh
{
    "enabled_modules": [
        "dashboard",
        "iostat",
        "restful"
    ],
    "disabled_modules": []
}
```
Tạo cert cho ceph-dashboad
```sh
sudo ceph dashboard create-self-signed-cert 
Self-signed certificate created
```
Tạo tài khoản cho `ceph-dashboard`, trong hướng dẫn này tạo tài khoản tên là `cephadmin` và mật khẩu là `123456`
```sh
$ ceph dashboard ac-user-create cephadmin 123456 administrator 

{"username": "cephadmin", "lastUpdate": 1567415960, "name": null, "roles": ["administrator"], "password": "$2b$12$QhFs2Yo9KTICIqT8v5xLC.kRCjzuLyXqyzBQVQ4MwQhDbSLKni6pC", "email": null}
```
Kiểm tra xem `ceph-dashboard` đã được cài đặt thành công hay chưa
```sh
ceph mgr services 

{
    "dashboard": "https://0.0.0.0:8443/"
}
```
Trước khi tiến hành đăng nhập vào web, có thể kiểm tra trạng thái cluser bằng lệnh `ceph -s` . Ta sẽ có kết quả trạng thái là OK.

Kết quả sẽ là địa chỉ truy cập `ceph-dashboad`, ta có thể vào bằng địa chỉ IP thay vì hostname: https://192.168.20.51:8443

## Tài liệu tham khảo
- https://news.cloud365.vn/ceph-lab-phan1-huong-dan-cai-dat-ceph-nautilus-tren-centos7/
- https://www.server-world.info/en/note?os=CentOS_7&p=ceph14&f=1
- https://www.linuxtechi.com/install-configure-ceph-cluster-centos-7/
