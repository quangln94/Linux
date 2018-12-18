# Network interfaces
Network interfaces là kênh kết nối giữa decive và network. Về mặt vật lý, Network interfaces có thể tiến hành thông qua thẻ giao diện mạng **NIC** hoặc có thể được triển khai trừu tượng hơn dưới dạng phần mềm. Bạn có thể có nhiều Network interfaces hoạt động cùng một lúc. Các interfaces cụ thể có thể được up (activated) hoặc down (de-activated) bất cứ lúc nào. Một danh sách các giao diện mạng đang hoạt động được báo cáo bởi tiện ích `` ifconfig``. Các file cấu hình network là rất cần thiết để đảm bảo các interfaces hoạt động chính xác.</br>
Đối với cấu hình họ **Debian**, tệp cấu hình network cơ bản là `/etc/network/interface`. Đối với cấu hình hệ thống họ **RedHat**, thông tin định tuyến và máy chủ được chứa trong `/etc/sysconfig/network`. Kịch bản cấu hình network interface cho interface `eth0` được đặt tại `/etc/sysconfig/network-scripts/ifcfg-eth0`. Đối với  cấu hình hệ thống họ **SUSE**, các tập lệnh định tuyến và thông tin máy chủ và cấu hình giao diện mạng được chứa trong thư mục `/etc/sysconfig/network`.

## Config network</br>
### Đặt ip tĩnh trong Ubuntu: sửa file /etc/network/interfaces như sau:
```sh
auto eth0
iface eth0 inet static

address 10.0.0.41
netmask 255.255.255.0
network 10.0.0.0
broadcast 10.0.0.255
gateway 10.0.0.1
dns-nameservers 10.0.0.1 8.8.8.8
dns-domain acme.com
dns-search acme.com
```
- Muốn để nhận ip từ dhcp server thì cấu hình như sau:
```sh
auto eth0
iface eth0 inet dhcp
```
### Đặt ip trong CentOS
```sh
$ vi /etc/sysconfig/network-scripts/ifcfg-enp33
TYPE=Ethernet
BOOTPROTO=none
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=no
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
NAME=enp0s25
UUID=d9315bd4-159b-4871-95f5-98f2fbcc5a06
ONBOOT=yes
HWADDR=00:24:81:0F:EC:DE
IPADDR=10.10.10.97
PREFIX=24
GATEWAY=10.10.10.1
DNS=8.8.8.8
```
`ip` là một chương trình rất mạnh mẽ có thể làm nhiều việc.
```sh
# ip addr show
# ip route show
```
## Routing table CentOS
### CentOS
Lệnh `route` được sử dụng để xem hoặc thay đổi bảng định tuyến IP. Bạn có thể muốn thay đổi bảng định tuyến IP để thêm, xóa hoặc sửa đổi các tuyến tĩnh thành các máy chủ hoặc mạng cụ thể.
```sh
# route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         10.10.10.1      0.0.0.0         UG    0      0        0 enp0s25
10.10.10.0      0.0.0.0         255.255.255.0   U     0      0        0 enp0s25
169.254.0.0     0.0.0.0         255.255.0.0     U     1002   0        0 enp48s0
169.254.0.0     0.0.0.0         255.255.0.0     U     1003   0        0 enp0s25
172.25.101.0    0.0.0.0         255.255.255.0   U     0      0        0 enp48s0
# 
# route add 10.58.47.235 gw 172.25.101.1
route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         10.10.10.1      0.0.0.0         UG    0      0        0 enp0s25
10.10.10.0      0.0.0.0         255.255.255.0   U     0      0        0 enp0s25
10.58.47.235    172.25.101.1    255.255.255.255 UGH   0      0        0 enp48s0
169.254.0.0     0.0.0.0         255.255.0.0     U     1002   0        0 enp48s0
169.254.0.0     0.0.0.0         255.255.0.0     U     1003   0        0 enp0s25
172.25.101.0    0.0.0.0         255.255.255.0   U     0      0        0 enp48s0
# 
# route delete 10.58.47.235 gw 172.25.101.1
# route add -net 10.0.0.0 netmask 255.0.0.0 gw 10.10.10.1 enp0s25
# route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         10.10.10.1      0.0.0.0         UG    0      0        0 enp0s25
10.0.0.0        10.10.10.1      255.0.0.0       UG    0      0        0 enp0s25
10.10.10.0      0.0.0.0         255.255.255.0   U     0      0        0 enp0s25
169.254.0.0     0.0.0.0         255.255.0.0     U     1002   0        0 enp48s0
169.254.0.0     0.0.0.0         255.255.0.0     U     1003   0        0 enp0s25
```
### Routing table Ubuntu

Lệnh `route` được sử dụng để xem hoặc chỉnh sửa bằng định tuyến IP, thêm, xóa hoặc thay đổi IP.
```sh
root@ubuntu:~# route
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         192.168.60.2    0.0.0.0         UG    0      0        0 ens33
192.168.0.0     *               255.255.255.0   U     0      0        0 ens32
192.168.60.0    *               255.255.255.0   U     0      0        0 ens33
```
Một số câu lệnh để thêm hoặc xóa các route trong bảng định tuyến
```sh
route add 192.168.0.110  gw 192.168.0.1
route delete 192.168.0.110  gw 192.168.0.1
route add -net 192.168.0.0 netmask 255.255.255.0 gw 192.168.60.0 ens33
route delete -net 192.168.0.0 netmask 255.255.255.0 gw 192.168.60.0 ens33
```
