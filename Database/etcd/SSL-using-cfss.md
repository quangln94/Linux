# ETCD using SSL
**Mô hình Lab**

|Server|IP|
|------|--|
|node1|10.10.10.101|
|node2|10.10.10.102|
|node3|10.10.10.103|

## 1. Install cfssl (Cloudflare ssl) trên Node 1:
```sh
wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64
wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
chmod +x cfssl*
mv cfssl_linux-amd64 /usr/local/bin/cfssl
mv cfssljson_linux-amd64 /usr/local/bin/cfssljson
```
Xác thực cài đặt
```sh
[root@node1 ~]# cfssl version
Version: 1.2.0
Revision: dev
Runtime: go1.6
```
## 2. Tạo TLS certificates:
**Tạo file cấu hình CA (certificate authority):**
```sh
vim ca-config.json
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "8760h"
      }
    }
  }
}
```
**Tạo certificate authority signing request configuration file.**
```sh
vim ca-csr.json
{
  "CN": "Kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
  {
    "C": "IE",
    "L": "VNPT",
    "O": "Kubernetes",
    "OU": "CA",
    "ST": "VNPT Co."
  }
 ]
}
```
**Tạo certificate authority certificate và private key**
```sh
cfssl gencert -initca ca-csr.json | cfssljson -bare ca
```
## Tạo certificate cho Etcd cluster
**Tạo certificate signing request configuration file**
```sh
vim kubernetes-csr.json
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
  {
    "C": "IE",
    "L": "VNPT",
    "O": "Kubernetes",
    "OU": "Kubernetes",
    "ST": "VNPT Co."
  }
 ]
}
```
**Generate the certificate and private key**
```sh
cfssl gencert \
-ca=ca.pem \
-ca-key=ca-key.pem \
-config=ca-config.json \
-hostname=10.10.10.101,10.10.10.102,10.10.10.103,10.10.10.110 \
-profile=kubernetes kubernetes-csr.json | \
cfssljson -bare kubernetes
```
**Copy certificate tới mỗi Node trong etcd cluster**
```sh
scp ca.pem kubernetes.pem kubernetes-key.pem root@10.10.10.102:~
scp ca.pem kubernetes.pem kubernetes-key.pem root@10.10.10.103:~
```
## 3. Install và config Etcd cluster
## 3.1 Thực hiện trên tất cả các Node
Tạo thư mục configuration cho `etcd`
```sh
mkdir /etc/etcd /var/lib/etcd
```
Move certificates tới thư mục configuration
```sh
mv ~/ca.pem ~/kubernetes.pem ~/kubernetes-key.pem /etc/etcd
```
Download etcd binaries và giải nén
```sh
wget https://github.com/coreos/etcd/releases/download/v3.3.9/etcd-v3.3.9-linux-amd64.tar.gz
tar xvzf etcd-v3.3.9-linux-amd64.tar.gz
```
Move etcd binaries tới `/usr/local/bin`
```sh
mv etcd-v3.3.9-linux-amd64/etcd* /usr/local/bin/
```
### 3.2 Thực hiện trên từng Node
**Thực hiện trên Node 1
```sh
[root@node1 ~]# vim /etc/systemd/system/etcd.service

[Unit]
Description=etcd
Documentation=https://github.com/coreos

[Service]
Type=notify
ExecStart=/usr/local/bin/etcd \
  --name etcd1 \
  --cert-file=/etc/etcd/kubernetes.pem \
  --key-file=/etc/etcd/kubernetes-key.pem \
  --peer-cert-file=/etc/etcd/kubernetes.pem \
  --peer-key-file=/etc/etcd/kubernetes-key.pem \
  --trusted-ca-file=/etc/etcd/ca.pem \
  --peer-trusted-ca-file=/etc/etcd/ca.pem \
  --peer-client-cert-auth \
  --client-cert-auth \
  --initial-advertise-peer-urls https://10.10.10.101:2380 \
  --listen-peer-urls https://10.10.10.101:2380 \
  --listen-client-urls https://10.10.10.101:2379 \
  --advertise-client-urls https://10.10.10.101:2379 \
  --initial-cluster-token etcd-cluster-0 \
  --initial-cluster etcd1=https://10.10.10.101:2380,etcd2=https://10.10.10.102:2380,etcd3=https://10.10.10.103:2380 \
  --initial-cluster-state new \
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```
**Thực hiện trên Node 2
```sh
[root@node2 ~]# vim /etc/systemd/system/etcd.service

[Unit]
Description=etcd
Documentation=https://github.com/coreos

[Service]
Type=notify
ExecStart=/usr/local/bin/etcd \
  --name etcd2 \
  --cert-file=/etc/etcd/kubernetes.pem \
  --key-file=/etc/etcd/kubernetes-key.pem \
  --peer-cert-file=/etc/etcd/kubernetes.pem \
  --peer-key-file=/etc/etcd/kubernetes-key.pem \
  --trusted-ca-file=/etc/etcd/ca.pem \
  --peer-trusted-ca-file=/etc/etcd/ca.pem \
  --peer-client-cert-auth \
  --client-cert-auth \
  --initial-advertise-peer-urls https://10.10.10.102:2380 \
  --listen-peer-urls https://10.10.10.102:2380 \
  --listen-client-urls https://10.10.10.102:2379 \
  --advertise-client-urls https://10.10.10.102:2379 \
  --initial-cluster-token etcd-cluster-0 \
  --initial-cluster etcd1=https://10.10.10.101:2380,etcd2=https://10.10.10.102:2380,etcd3=https://10.10.10.103:2380 \
  --initial-cluster-state new \
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```
**Thực hiện trên Node 3**
```sh
[root@node3 ~]# vim /etc/systemd/system/etcd.service

[Unit]
Description=etcd
Documentation=https://github.com/coreos

[Service]
Type=notify
ExecStart=/usr/local/bin/etcd \
  --name etcd3 \
  --cert-file=/etc/etcd/kubernetes.pem \
  --key-file=/etc/etcd/kubernetes-key.pem \
  --peer-cert-file=/etc/etcd/kubernetes.pem \
  --peer-key-file=/etc/etcd/kubernetes-key.pem \
  --trusted-ca-file=/etc/etcd/ca.pem \
  --peer-trusted-ca-file=/etc/etcd/ca.pem \
  --peer-client-cert-auth \
  --client-cert-auth \
  --initial-advertise-peer-urls https://10.10.10.103:2380 \
  --listen-peer-urls https://10.10.10.103:2380 \
  --listen-client-urls https://10.10.10.103:2379 \
  --advertise-client-urls https://10.10.10.103:2379 \
  --initial-cluster-token etcd-cluster-0 \
  --initial-cluster etcd1=https://10.10.10.101:2380,etcd2=https://10.10.10.102:2380,etcd3=https://10.10.10.103:2380 \
  --initial-cluster-state new \
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```
### 3.3 Thực hiện trên cả 3 Node
```sh
systemctl daemon-reload
systemctl enable etcd
systemctl start etcd
```
**Xác thực cluster**
```sh
$ ETCDCTL_API=3 etcdctl --endpoints=https://10.10.10.101:2379,https://10.10.10.102:2379,https://10.10.10.103:2379 --cacert=/etc/etcd/ca.pem --cert=/etc/etcd/kubernetes.pem --key=/etc/etcd/kubernetes-key.pem --write-out=table endpoint status
+---------------------------+------------------+---------+---------+-----------+-----------+------------+
|         ENDPOINT          |        ID        | VERSION | DB SIZE | IS LEADER | RAFT TERM | RAFT INDEX |
+---------------------------+------------------+---------+---------+-----------+-----------+------------+
| https://10.10.10.101:2379 | e62b7898822a43c8 |   3.3.9 |   20 kB |      true |         2 |          8 |
| https://10.10.10.102:2379 | 21dcbad7aeb6e920 |   3.3.9 |   20 kB |     false |         2 |          8 |
| https://10.10.10.103:2379 | 77ee7ec8ef5ea698 |   3.3.9 |   20 kB |     false |         2 |          8 |
+---------------------------+------------------+---------+---------+-----------+-----------+------------+
```

## Tài liệu tham khảo
- https://github.com/thangtq710/Kubernetes/blob/master/docs/2.Etcd.md
- https://blog.inkubate.io/install-and-configure-a-multi-master-kubernetes-cluster-with-kubeadm/
