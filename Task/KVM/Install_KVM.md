
## 1. Install
```sh
yum -y install qemu-kvm libvirt virt-install bridge-utils
# make sure modules are loaded
[root@server1 ~]# lsmod | grep kvm 
kvm_intel       138567  0
kvm             441119  1 kvm_intel

[root@server1 ~]# systemctl start libvirtd 
[root@server1 ~]# systemctl enable libvirtd 
```
## 2. Configure Bridge networking for KVM virtual machine.Replace the interface name "eth0" for your own environment's one.
```sh
# add bridge "br0"
[root@dlp ~]# nmcli connection add type bridge autoconnect yes con-name br0 ifname br0 
Connection 'br0' (0f4b7bc8-8c7a-461a-bff1-d516b941a6ec) successfully added.
# set IP for br0
[root@dlp ~]# nmcli connection modify br0 ipv4.addresses 10.0.0.30/24 ipv4.method manual 
# set Gateway for br0
[root@dlp ~]# nmcli connection modify br0 ipv4.gateway 10.0.0.1 
# set DNS for "br0"
[root@dlp ~]# nmcli connection modify br0 ipv4.dns 10.0.0.1 
# remove the current setting
[root@dlp ~]# nmcli connection delete eth0 
# add an interface again as a member of br0
[root@dlp ~]# nmcli connection add type bridge-slave autoconnect yes con-name eth0 ifname eth0 master br0 
# restart
[root@dlp ~]# reboot
[root@dlp ~]# ip addr 
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> 
    mtu 1500 qdisc pfifo_fast master br0 state UP group default qlen 1000
    link/ether 00:0c:29:9f:9b:d3 brd ff:ff:ff:ff:ff:ff
3: virbr0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
    link/ether 22:f8:64:25:97:44 brd ff:ff:ff:ff:ff:ff
    inet 192.168.122.1/24 brd 192.168.122.255 scope global virbr0
       valid_lft forever preferred_lft forever
4: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 00:0c:29:9f:9b:d3 brd ff:ff:ff:ff:ff:ff
    inet 10.0.0.30/24 brd 10.0.0.255 scope global br0
       valid_lft forever preferred_lft forever
    inet6 fe80::20c:29ff:fe9f:9bd3/64 scope link
       valid_lft forever preferred_lft forever
```
