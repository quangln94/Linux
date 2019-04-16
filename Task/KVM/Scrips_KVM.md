# 1. Create VM using `command`
```sh
virt-install \
--name centos7 \
--ram 4096 \
--disk path=/var/kvm/images/centos7.img,size=30 \
--vcpus 2 \
--os-type linux \
--os-variant rhel7 \
--network bridge=br0 \
--graphics none \
--console pty,target_type=serial \
--location 'http://ftp.iij.ad.jp/pub/linux/centos/7/os/x86_64/' \
--extra-args 'console=ttyS0,115200n8 serial'
```
```sh
virt-install \
--name centos7 --ram 4096 --disk path=/var/kvm/images/centos7.img,size=30 --vcpus 2 --os-type linux --os-variant rhel7 --network bridge=br0 --graphics none --console pty,target_type=serial --location 'http://ftp.iij.ad.jp/pub/linux/centos/7/os/x86_64/' --extra-args 'console=ttyS0,115200n8 serial'
```
Trong đó:
--name: specify the name of Virtual Machine
--ram: specify the amount of memories of Virtual Machine
--disk path=xxx ,size=xxx
'path=' ⇒ specify the location of disks of Virtual Machine
'size=' ⇒ specify the amount of disks of Virtual Machine
--vcpus: specify the virtual CPUs
--os-type: specify the type of GuestOS
--os-variant: specify the kind of GuestOS - possible to confirm the list with the command below
# osinfo-query os
--network: specify network types of Virtual Machine
--graphics: specify the kind of graphics. if set 'none', it means nographics.
--console: specify the console type
--location: specify the location of installation where from
--extra-args: specify parameters that is set in kernel
