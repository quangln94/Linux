# Install k8s trên CentOS 7
## 1. Mô hình Lab
|Server|Vai trò|IP|
|------|-------|--|
|Server01|Master|10.10.10.221|
|Server02|Worker|10.10.10.222|
|Server03|Worker|10.10.10.223|

## 2. Cài đặt
**Thay đổi trên tất cả các Node**

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
**Tắt firewalld và SElinux**
```
systemctl stop firewalld
systemctl disable firewalld
```
**Cài đặt Kubeadm**
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
$ systemctl enable kubelet
```
**Cài đặt Docker**
```sh
yum -y install docker
systemctl start docker
systemctl enable docker
```
### 2.1 Master Node
```sh
kubeadm init --apiserver-advertise-address=10.10.10.221 --pod-network-cidr=10.244.0.0/16
------------------------------------------
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

# the command below is necessary to run on Worker Node when he joins to the cluster, so remember it
kubeadm join 10.10.10.221:6443 --token ya28xk.8uc7mxgxh4xvkqu6 \
    --discovery-token-ca-cert-hash sha256:f06bff4248081281c22fed88452edb2a4dedd16b1155f297fb0d8639d8bab85a
```
Trong đó: 
- `--apiserver-advertise-address:` Chỉ định IP Kubernetes API server.
- `--pod-network-cidr:` Chỉ định network để Pod giao tiếp với nhau.
There are some plugins for Pod Network. (refer to details below)
  ⇒ https://kubernetes.io/docs/concepts/cluster-administration/networking/

**Set cluster admin user**
```sh
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
**Configure Pod Network with Flannel**
```sh
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```
**Kiểm tra state**
```sh
[root@server01 ~]# kubectl get nodes
NAME       STATUS   ROLES    AGE   VERSION
server01   Ready    master   23m   v1.16.2
[root@server01 ~]# kubectl get pods --all-namespaces
NAMESPACE     NAME                               READY   STATUS    RESTARTS   AGE
kube-system   coredns-5644d7b6d9-grjwr           1/1     Running   0          23m
kube-system   coredns-5644d7b6d9-rbwq2           1/1     Running   0          23m
kube-system   etcd-server01                      1/1     Running   0          22m
kube-system   kube-apiserver-server01            1/1     Running   0          22m
kube-system   kube-controller-manager-server01   1/1     Running   0          22m
kube-system   kube-flannel-ds-amd64-87mwj        1/1     Running   0          58s
kube-system   kube-proxy-trc7x                   1/1     Running   0          23m
kube-system   kube-scheduler-server01            1/1     Running   0          22m
```

## Tài liệu tham khảo
- https://www.server-world.info/en/note?os=CentOS_7&p=kubernetes&f=3
- https://blogd.net/kubernetes/cai-dat-kubernetes-cluster/
