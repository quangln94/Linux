# Install k8s trên CentOS 7
## 1. Mô hình Lab
|Server|Vai trò|IP|
|------|-------|--|
|Server01|Master|10.10.10.221|
|Server02|Worker|10.10.10.222|
|Server03|Worker|10.10.10.223|

## 2. Cài đặt
**Thay đổi trên tất cả các Node.**

***Nếu không disabled swap, kubelet service sẽ không thể start trên masters và nodes. Nếu chạy nodes với (traditional to-disk) swap, sẽ mất đi nhiều thuộc tính isolation, có thể sharing và không có các dự đoán xung quanh việc performance hoặc latency hoặc IO.***
```sh
$ swapoff -a
```
Update `fstab` để `swap` vẫn bị `disabled` sau khi reboot.
```
$ vim /etc/fstab
#/dev/mapper/cl-swap swap swap defaults 0 0
```
```sh
$ cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
$ sysctl --system
```
**Cài đặt Kubeadm.**
```sh
$ cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
$ yum -y install kubeadm kubelet kubectl
systemctl enable kubelet
```
### 2.1 Master Node

## Tài liệu tham khảo
- https://www.server-world.info/en/note?os=CentOS_7&p=kubernetes&f=3
- https://blogd.net/kubernetes/cai-dat-kubernetes-cluster/
