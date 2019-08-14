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
```sh
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

- Xóa namespace
```sh
ip netns delete <namespace_name>
```
```sh
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
[root@client01 ~]# ip link add veth1 type veth peer name veth2
```
Đính kèm `veth2` vào `ns` namespace
```
[root@client01 ~]# ip link set veth2 netns ns2
[root@client01 ~]# ip netns exec ns2 ip link set dev veth2 up
```
Virtual network interface `veth1` vẫn gắn liền với `global namespace`
```
[root@client01 ~]# ip link set dev veth1 up
```
- Configure the virtual interface trong global network namespace
```
[root@client01 ~]# ip addr add 192.168.1.1/24 dev veth1
```
và trong `ns2` network namespace
```
[root@client01 ~]# ip netns exec ns2 ip addr add 192.168.1.2/24 dev veth2
```

## 3. Lab cơ bản
### 3.1
- Tạo `Network Namespace`
```sh
ip netns add ns2
```
- Tạo 1 cặp `veth` kể kết nối với `Namespace`
```sh
ip link add veth1 type veth peer name veth2
```
- Kết nối `veth2` với `ns2` 
```sh
ip link set veth2 netns ns2
```
- Enable interface
```sh
ip link set dev veth1 up
ip netns exec ns2 ip link set dev veth2 up
```
- Add IP 
```sh
ip addr add 192.168.1.1/24 dev veth1
ip netns exec ns2 ip addr add 192.168.1.2/24 dev veth2
```
- Kiểm tra

Đứng tại `ns2` ping đến `veth1` và Internet</br>
Đứng tại `veth1` ping đến `ns2` và Internet</br>

### 3.2
- Tạo 2 `Namespace`
```sh
ip netns add ns1
ip netns add ns2
```
- Tạo 2 cặp `veth`
```sh
ip link add veth1 type veth peer name br-veth1
ip link add veth2 type veth peer name br-veth2
```
- Link `veth` vào `namespace`
```sh
ip link set veth1 netns ns1
ip link set veth2 netns ns2
```
- Gán IP và enable Interface
```sh
ip netns exec ns1 ip add add 192.168.1.1/24 dev veth1
ip netns exec ns2 ip add add 192.168.1.2/24 dev veth2
ip netns exec ns1 ip link set dev veth1 up
ip netns exec ns2 ip link set dev veth2 up
ip link set br-veth1 up
ip link set br-veth2 up

```
- Tạo bridge devive
```sh
ip link add name br1 type bridge
ip link set br1 up
```
```sh
ip link set br-veth1 master br1
ip link set br-veth2 master br1
```
```sh
ip addr add 192.168.1.10/24 brd + dev br1
```


# Tài liệu tham khảo
- http://man7.org/linux/man-pages/man8/ip-netns.8.html
- https://ops.tips/blog/using-network-namespaces-and-bridge-to-isolate-servers/
- https://github.com/hocchudong/thuctap012017/blob/master/TamNT/Virtualization/docs/7.Linux_network_namespace.md
