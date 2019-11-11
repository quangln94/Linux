#
## Cài đặt 
**Installing Packages trên tất cả các Node etcd**
```sh
$ cat << EOF >/etc/yum.repos.d/virt7-docker-common-release.repo
[virt7-docker-common-release]
name = virt7-docker-common-release
baseurl=http://cbs.centos.org/repos/virt7-docker-common-release/x86_64/os/
gpgcheck=0
EOF
$ yum install -y — enablerepo=virt7-docker-common-release etcd
$ yum install -y *rhsm*
```
**Thực hiện trên Node 1**

```sh
$ vim /etc/etcd/etcd.conf
# [member]
ETCD_NAME=etcd1
ETCD_DATA_DIR=”/var/lib/etcd/default.etcd”
ETCD_LISTEN_PEER_URLS=”http://10.10.0.10:2380"
ETCD_LISTEN_CLIENT_URLS=”http://10.10.0.10:2379,http://127.0.0.1:2379"
#[cluster]
ETCD_INITIAL_ADVERTISE_PEER_URLS=”http://10.10.0.10:2380"
ETCD_INITIAL_CLUSTER=”etcd1=http://10.10.0.10:2380,etcd2=http://10.10.0.11:2380,etcd3=http://10.10.0.12:2380"
ETCD_INITIAL_CLUSTER_STATE=”new”
ETCD_INITIAL_CLUSTER_TOKEN=”etcd-cluster-1"
ETCD_ADVERTISE_CLIENT_URLS=”http://10.10.0.10:2379"
```
**Thực hiện trên Node 2**

```sh
$ vim /etc/etcd/etcd.conf
# [member]
ETCD_NAME=etcd2
ETCD_DATA_DIR=”/var/lib/etcd/default.etcd”
ETCD_LISTEN_PEER_URLS=”http://10.10.0.11:2380"
ETCD_LISTEN_CLIENT_URLS=”http://10.10.0.11:2379,http://127.0.0.1:2379"
#[cluster]
ETCD_INITIAL_ADVERTISE_PEER_URLS=”http://10.10.0.11:2380"
ETCD_INITIAL_CLUSTER=”etcd1=http://10.10.0.10:2380,etcd2=http://10.10.0.11:2380,etcd3=http://10.10.0.12:2380"
ETCD_INITIAL_CLUSTER_STATE=”new”
ETCD_INITIAL_CLUSTER_TOKEN=”etcd-cluster-1"
ETCD_ADVERTISE_CLIENT_URLS=”http://10.10.0.11:2379"
```
**Thực hiện trên Node 3**
```sh
$ vim /etc/etcd/etcd.conf
# [member]
ETCD_NAME=etcd3
ETCD_DATA_DIR=”/var/lib/etcd/default.etcd”
ETCD_LISTEN_PEER_URLS=”http://10.10.0.12:2380"
ETCD_LISTEN_CLIENT_URLS=”http://10.10.0.12:2379,http://127.0.0.1:2379"
#[cluster]
ETCD_INITIAL_ADVERTISE_PEER_URLS=”http://10.10.0.12:2380"
ETCD_INITIAL_CLUSTER=”etcd1=http://10.10.0.10:2380,etcd2=http://10.10.0.11:2380,etcd3=http://10.10.0.12:2380"
ETCD_INITIAL_CLUSTER_STATE=”new”
ETCD_INITIAL_CLUSTER_TOKEN=”etcd-cluster-1"
ETCD_ADVERTISE_CLIENT_URLS=”http://10.10.0.11:2379"
```
**Tạo ETCD Network**
```sh
$ etcdctl mkdir /kube-centos/network
$ etcdctl mk /kube-centos/network/config “{ \”Network\”:\”172.30.0.0/16\”,\”SubnetLen\”:24,\”Backend\”: {\”Type\”:\”vxlan\”}}”
```

**Start ETCD SERVICE**
```sh
for SERVICES in etcd; do
systemctl restart $SERVICES
systemctl enable $SERVICES
systemctl status -l $SERVICES
done
```
**After first start change Cluster State từ new sang existing. Để làm điều này thực hiện command sau:
```sh
sed -i s’/ETCD_INITIAL_CLUSTER_STATE=”new”/ETCD_INITIAL_CLUSTER_STATE=”existing”/’g /etc/etcd/etcd.conf
```
**Cấu hình `Kubernetes API Server`**

Start Kubernetes API server với 1 etcd cluster trong deployment. Start Kubernetes API servers với flag
```sh
$ vi /etc/kubernetes/apiserver
KUBE_ETCD_SERVERS=” — etcd_servers=http://etcd1:2379,http://etcd2:2379, http://etcd3:2379"
```







## Tài liệu tham khảo 
- https://medium.com/@uzzal2k5/etcd-etcd-cluster-configuration-for-kubernetes-779455337db6
