# Install useful tools for virt management.
## 1. Connect VM
```sh
[root@server ~]# virsh console Server1
```
- Note: Nếu không connect được, sử dụng `command` sau tại máy VM
```sh
# systemctl start serial-getty@ttyS0
# systemctl enable serial-getty@ttyS0
```
## 1.	Install virt tools.
```
[root@server ~]# yum -y install libguestfs-tools libguestfs-xfs virt-top
```
## 2.	Get official OS image and Create a Virtual Machine.
- **display available OS template**
```
[root@server ~]# virt-builder -l 
opensuse-13.1            x86_64     openSUSE 13.1
opensuse-13.2            x86_64     openSUSE 13.2
opensuse-42.1            x86_64     openSUSE Leap 42.1
opensuse-tumbleweed      x86_64     openSUSE Tumbleweed
centos-6                 x86_64     CentOS 6.6
centos-7.0               x86_64     CentOS 7.0
centos-7.1               x86_64     CentOS 7.1
centos-7.2               aarch64    CentOS 7.2 (aarch64)
centos-7.2               x86_64     CentOS 7.2
centos-7.3               x86_64     CentOS 7.3
centos-7.4               x86_64     CentOS 7.4
centos-7.5               x86_64     CentOS 7.5
.....
.....
```
- **Create an image of CentOS 7.5**
```
[root@server ~]# export LIBGUESTFS_BACKEND=direct 
[root@server ~]# virt-builder centos-7.5 --format qcow2 --size 20G -o centos75.qcow2 --root-password password 
[   3.8] Downloading: http://libguestfs.org/download/builder/centos-7.5.xz
[  74.0] Planning how to build this image
[  74.0] Uncompressing
.....
.....
                   Output file: centos75.qcow2
                   Output size: 20.0G
                 Output format: qcow2
            Total usable space: 19.4G
                    Free space: 18.3G (94%)
```
- **To configure VM with the image above, run virt-install**
```sh
[root@server ~]# virt-install \
--name centos-75 \
--ram 2048 \
--disk path=/var/kvm/images/centos75.qcow2 \
--vcpus 2 \
--os-type linux \
--os-variant rhel7.5 \
--network bridge=br0 \
--graphics none \
--serial pty \
--console pty \
--boot hd \
--import
```
## 3.	"ls" a directory in a virtual machine.
```sh
[root@server ~]# virt-ls -l -d centos7 /root 
total 36
dr-xr-x---.  2 root root 4096 Jan  8 22:38 .
drwxr-xr-x. 17 root root 4096 Jan  8 22:36 ..
-rw-------.  1 root root   61 Jan  8 22:38 .bash_history
-rw-r--r--.  1 root root   18 Dec 29  2013 .bash_logout
-rw-r--r--.  1 root root  176 Dec 29  2013 .bash_profile
-rw-r--r--.  1 root root  176 Dec 29  2013 .bashrc
...
```
## 4.	"cat" a file in a virtual machine.
```sh
[root@server ~]# virt-cat -d centos7 /etc/passwd 
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync
...
```
## 5.	Edit a file in a virtual machine.
```sh
[root@server ~]# virt-edit -d centos7 /etc/fstab 
#
# /etc/fstab
# Created by anaconda on Thu Jan  8 13:20:43 2015
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
/dev/mapper/centos-root /                       xfs     defaults        1 1
UUID=537b215f-30a1-4e82-b05d-f480aa8e1034 /boot xfs     defaults        1 2
/dev/mapper/centos-swap swap                    swap    defaults        0 0
```
## 6.	Display disk usage in a virtual machine.
```sh
[root@server ~]# virt-df -d centos7 
Filesystem                     1K-blocks       Used  Available  Use%
centos7:/dev/sda1                 508588      72348     436240   15%
centos7:/dev/centos/root         8910848     779252    8131596    9%
```
## 7.	Mount a disk for a virtual machine. (NOT COMPLETE)
```sh
[root@server ~]# guestmount -d centos7 -i /media 
[root@server ~]# ll /media 
total 32
lrwxrwxrwx.  1 root root    7 Jan  8 22:22 bin -> usr/bin
dr-xr-xr-x.  4 root root 4096 Jan  8 22:37 boot
drwxr-xr-x.  2 root root    6 Jan  8 22:20 dev
drwxr-xr-x. 74 root root 8192 Jan  8 22:36 etc
...
```
## 8.	Display the status of virtual machines. (NOT COMPLETE)
```sh
[root@server ~]# virt-top 
virt-top 22:32:14 - x86_64 4/4CPU 2801MHz 11968MB
2 domains, 1 active, 1 running, 0 sleeping, 0 paused, 1 inactive D:0 O:0 X:0
CPU: 0.2%  Mem: 500 MB (500 MB by guests)

   ID S RDRQ WRRQ RXBY TXBY %CPU %MEM    TIME   NAME
    6 R    0    0            0.2  4.0   0:09.14 guestfs-o7nss1p3kxvyl1r5
    -                                           (centos7)
```
