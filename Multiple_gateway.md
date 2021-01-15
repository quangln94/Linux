# Multiple Gateway
## 1. Tạo bảng Routing table cho NIC2
```sh
echo "1       myorg" >> /etc/iproute2/rt_tables
```
## 2. Tạo iproute2 default gateway cho NIC2
```sh
$ vim /etc/sysconfig/network-scripts/route-enp0s8

default via 192.168.20.1 dev ens4 table myorg
```
## 3. Tạo iproute2 rules cho NIC2
```sh
$ vim  /etc/sysconfig/network-scripts/rule-enp0s8

from 192.168.20.0/24 table myorg
```

## Tài liệu tham khảo
- http://www.allgoodbits.org/articles/view/24
- https://aikzs.wordpress.com/2019/09/16/centos-7-multiple-gateway-multiple-routing-table/
- https://coderazzi.net/linux/dual_nic_linux.htm
