# Linux Network Namespaces

## 1. Khái niệm

Network namspace là khái niệm cho phép bạn cô lập môi trường mạng network trong một host. Namespace phân chia việc sử dụng các khác niệm liên quan tới network như devices, địa chỉ addresses, ports, định tuyến và các quy tắc tường lửa vào trong một hộp (box) riêng biệt, chủ yếu là ảo hóa mạng trong một máy chạy một kernel duy nhất.

Trong Linux virtual networking space, các Network Namespace cho phép tạo ra network interface và có bảng định tuyến riêng, các thiết lập iptables riêng cung cấp cơ chế NAT và lọc đối với các máy ảo thuộc namespace đó. Linux network namespaces cũng cung cấp thêm khả năng để chạy các tiến trình riêng biệt trong nội bộ mỗi namespace.

Network namespace được sử dụng trong khá nhiều dự án như Openstack, Docker và Mininet.

Các thiết bị mạng chuyên dụng sử dụng Virtual Routing and Forwarding (VRF), có nghĩa là nhiều bộ định tuyến ảo (ví dụ chuyển tiếp lớp 3) có thể chạy trên cùng một thiết bị vật lý. 

## 2. Một số thao tác với Network Namespace
- Liệt kê `namespace`:
```sh
ip netns
 # hoặc
ip netns list
```
Nếu chưa thêm bất kì `network namespace` nào thì đầu ra màn hình sẽ để trống. `root namespace` sẽ không được liệt kê khi sử dụng câu lệnh `ip netns list`.

- Add `namespace`:

```sh
ip netns add ns1
ip netns add ns2
```
Mỗi khi thêm vào một `namespace`, một file mới được tạo trong thư mục `/var/run/netns` với tên giống như tên `namespace`. (không bao gồm file của root namespace).
```sh
[root@client01 ~]# ls -al /var/run/netns/
-r--r--r--  1 root root    0 Aug 13 19:10 ns1
-r--r--r--  1 root root    0 Aug 13 19:10 ns2
```
- Thực thi lệnh trong `namespace`
Để thực hiện các lệnh trong một `namespace` thì làm như sau: `ip netns exec <namespace> <command>`
Ví dụ:

Thay vì gõ :
```sh
ip a
```
thì ta làm như sau:
```
[root@client01 ~]# ip netns exec ns1 ip a
1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00

```
Để liệt kê tất các các địa chỉ interface của các namespace sử dụng tùy chọn `–a` hoặc `–all` như sau:
``sh
[root@client01 ~]# ip -a netns exec ip a

netns: ns2
1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
7: veth2@if8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 6e:5e:83:fe:72:00 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 192.168.1.2/24 scope global veth2
       valid_lft forever preferred_lft forever
    inet6 fe80::6c5e:83ff:fefe:7200/64 scope link
       valid_lft forever preferred_lft forever

netns: ns1
1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
```
Kết quả đầu ra sẽ khác so với khi chạy câu lệnh ip a ở chế độ mặc định (trong root namespace). Mỗi namespace sẽ có một môi trường mạng cô lập, có giao diện loopback riêng, có các interface và bảng định tuyến riêng và thiết lập iptables riêng cung cấp nat và filtering.
```
Thoát khỏi vùng làm việc của namespace gõ `exit`


- Xóa `namespace`
Xóa namespace sử dụng câu lệnh:
```sh
ip netns delete <namespace_name>
```
- `Network namespaces` còn có khả năng chạy các tiến trình trong `network namespace`. Ví dụ: chạy phiên bash trong một `namespace`
```sh
ip netns exec <namespacwe> bash
```
```sh

[root@client01 ~]# ip netns exec ns1 bash
[root@client01 ~]# ip a
1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
[root@client01 ~]# exit
exit
```
Lưu ý: gõ `exit` để thoát khỏi `bash` của name space hiện tại.
```
- Xóa namespace
```sh
ip netns delete <namespace_name>
``
[root@client01 ~]# ip netns add ns1
[root@client01 ~]# ip netns add ns2
[root@client01 ~]# ip netns list
ns2
ns1
[root@client01 ~]# ip netns delete ns1
[root@client01 ~]# ip netns list
ns2
```
- Add `interfaces` vào network `namespaces`:

```sh
ip link set <interface_name> netns <namespace_name>
```

Để kết nối một `network namespace` với bên ngoài, hãy đính kèm một `virtual interface` vào `default` hoặc `global` `namespace` nơi `physical interfaces` tồn tại. Để thực hiện điều này, hãy tạo một vài `interface` ảo, được gọi là `veth1` và `veth2`

```
[root@client01 ~]# ip link add veth` type veth peer name veth`
```
Đính kèm vethb vào Blue namespace
```
[root@centos-01 ~]# ip link set vethb netns Blue
[root@centos-01 ~]# ip netns exec Blue ip link set dev vethb up
[root@centos-01 ~]# ip netns exec Blue ifconfig
lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 0  (Local Loopback)
vethb: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        ether 7e:e4:29:bc:9c:67  txqueuelen 1000  (Ethernet)
```
Virtual network interface vetha vẫn gắn liền với global namespace
```
[root@centos-01 ~]# ip link set dev vetha up
[root@centos-01 ~]# ifconfig
ens32: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.10.10.21  netmask 255.255.255.0  broadcast 10.10.10.255
        inet6 fe80::20c:29ff:fe1e:6bf1  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:1e:6b:f1  txqueuelen 1000  (Ethernet)
lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 0  (Local Loopback)
vetha: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet6 fe80::e899:ceff:fef6:3010  prefixlen 64  scopeid 0x20<link>
        ether ea:99:ce:f6:30:10  txqueuelen 1000  (Ethernet)
```
Configure the virtual interface trong global network namespace
```
[root@centos-01 ~]# ip addr add 192.168.100.1/24 dev vetha
[root@centos-01 ~]# route
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         gateway         0.0.0.0         UG    100    0        0 ens32
10.10.10.0      0.0.0.0         255.255.255.0   U     100    0        0 ens32
192.168.100.0   0.0.0.0         255.255.255.0   U     0      0        0 vetha
[root@centos-01 ~]#
```
và trong Blue network namespace
```
[root@centos-01 ~]# ip netns exec Blue ip addr add 192.168.100.2/24 dev vethb
[root@centos-01 ~]# ip netns exec Blue route
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
192.168.100.0   0.0.0.0         255.255.255.0   U     0      0        0 vethb
[root@centos-01 ~]#
```
Both the namespaces, Blue and global bây giờ có thể truy cập lẫn nhau thông qua virtual network interfaces
```
[root@centos-01 ~]# ping 192.168.100.2
PING 192.168.100.2 (192.168.100.2) 56(84) bytes of data.
64 bytes from 192.168.100.2: icmp_seq=1 ttl=64 time=0.041 ms
64 bytes from 192.168.100.2: icmp_seq=2 ttl=64 time=0.029 ms
^C
[root@centos-01 ~]# ip netns exec Blue ping 192.168.100.1
PING 192.168.100.1 (192.168.100.1) 56(84) bytes of data.
64 bytes from 192.168.100.1: icmp_seq=1 ttl=64 time=0.034 ms
64 bytes from 192.168.100.1: icmp_seq=2 ttl=64 time=0.039 ms
^C
```
Nhưng chúng là các thực thể định tuyến hoàn toàn tách biệt
```
[root@centos-01 ~]# ip netns exec Blue ping 10.10.10.1
connect: Network is unreachable
[root@centos-01 ~]#
[root@centos-01 ~]# ping 10.10.10.1
PING 10.10.10.1 (10.10.10.1) 56(84) bytes of data.
64 bytes from 10.10.10.1: icmp_seq=1 ttl=64 time=0.545 ms
64 bytes from 10.10.10.1: icmp_seq=2 ttl=64 time=0.369 ms
```
