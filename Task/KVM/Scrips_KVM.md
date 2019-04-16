# 1. Create VM using `command`
```sh
virt-install \
--name centos7 --ram 4096 --disk path=/var/kvm/images/centos7.img,size=30 --vcpus 2 --os-type linux --os-variant rhel7 --network bridge=br0 --graphics none --console pty,target_type=serial --location 'http://ftp.iij.ad.jp/pub/linux/centos/7/os/x86_64/' --extra-args 'console=ttyS0,115200n8 serial'
```
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
