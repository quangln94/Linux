# ETCD Data Store Cluster with TLS Certificate


## Certificate Generation:
Sử dụng `openssl` để tạo certificate.
```sh
[root@etcd1]# mkdir /root/etcd-certificate
[root@etcd1]# cd /root/etcd-certificate
[root@etcd1 etcd-certificate]# openssl genrsa -out ca-key.pem 2048
[root@etcd1 etcd-certificate]# openssl req -x509 -new -nodes -key ca-key.pem -days 10000 -out ca.pem -subj "/CN=etcd-ca"
```
**Tạo certificate trên ETCD node-1:**
```sh
[root@etcd1 etcd-certificate]# vi openssl.conf

[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name

[req_distinguished_name]

[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[ ssl_client ]
extendedKeyUsage = clientAuth, serverAuth
basicConstraints = CA:FALSE
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer
subjectAltName = @alt_names

[ v3_ca ]
basicConstraints = CA:TRUE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
authorityKeyIdentifier=keyid:always,issuer

[alt_names]
DNS.1 = localhost
DNS.2 = etcd1
IP.1 = 10.10.10.221
IP.2 = 127.0.0.1
```
**Set openssl.conf location variable**
```sh
[root@etcd-01 etcd-certificate]# CONFIG=`echo $PWD/openssl.conf`
```
**Generate Certificates:**
```sh
[root@etcd1 etcd-certificate]# openssl genrsa -out member-etcd1-key.pem 2048
[root@etcd1 etcd-certificate]# openssl req -new -key member-etcd1-key.pem -out member-etcd1.csr -subj "/CN=etcd1" -config /root/etcd-certificate/openssl.conf
[root@etcd1 etcd-certificate]# openssl x509 -req -in member-etcd1.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out member-etcd1.pem -days 3650 -extensions ssl_client -extfile /root/etcd-certificate/openssl.conf
```
## Tạo certificate trên ETCD node-2:
```sh
[root@etcd2 etcd-certificate]# vi openssl.conf

[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name

[req_distinguished_name]

[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[ ssl_client ]
extendedKeyUsage = clientAuth, serverAuth
basicConstraints = CA:FALSE
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer
subjectAltName = @alt_names

[ v3_ca ]
basicConstraints = CA:TRUE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
authorityKeyIdentifier=keyid:always,issuer

[alt_names]
DNS.1 = localhost
DNS.2 = etcd2
IP.1 = 10.10.10.222
IP.2 = 127.0.0.1
```
**Generate Certificates**
```sh
[root@etcd2 etcd-certificate]# openssl genrsa -out member-etcd2-key.pem 2048
[root@etcd2 etcd-certificate]# openssl req -new -key member-etcd2-key.pem -out member-etcd2.csr -subj "/CN=etcd2" -config /root/etcd-certificate/openssl.conf
[root@etcd2 etcd-certificate]# openssl x509 -req -in member-etcd2.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out member-etcd2.pem -days 3650 -extensions ssl_client -extfile /root/etcd-certificate/openssl.conf
```
## Tạo certificate trên ETCD node-3:
```sh
[root@etcd3 etcd-certificate]# vi openssl.conf

[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name

[req_distinguished_name]

[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[ ssl_client ]
extendedKeyUsage = clientAuth, serverAuth
basicConstraints = CA:FALSE
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer
subjectAltName = @alt_names

[ v3_ca ]
basicConstraints = CA:TRUE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
authorityKeyIdentifier=keyid:always,issuer

[alt_names]
DNS.1 = localhost
DNS.2 = etcd3
IP.1 = 10.10.10.223
IP.2 = 127.0.0.1
```
**Generate Certificates:**
```sh
[root@etcd3 etcd-certificate]# openssl genrsa -out member-etcd3-key.pem 2048
[root@etcd3 etcd-certificate]# openssl req -new -key member-etcd3-key.pem -out member-etcd3.csr -subj "/CN=etcd3" -config /root/etcd-certificate/openssl.conf
[root@etcd3 etcd-certificate]# openssl x509 -req -in member-etcd3.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out member-etcd3.pem -days 3650 -extensions ssl_client -extfile /root/etcd-certificate/openssl.conf
```
**Copy tất cả certificates vừa tạo trên mỗi Node `etcd` từ `/etc/ssl/etcd-certificate` đến `/etc/ssl/etcd/ssl/`:**
```sh
$ cp -rvp /root/etcd-certificate/*.pem /etc/ssl/etcd/ssl/
```
**Install `etcd` trên 3 Node**

Copy `etcd` và `etcdctl` trên 3 Node có thể download từ [etcd github project page](https://github.com/coreos/etcd/releases/)
```sh
[root@etcd-* etcd]# cp -vp etcd etcdctl /usr/bin
```
Tạo `etcd` data directory trên cả 3 Node:
```sh
[root@etcd-* etcd]# mkdir /var/lib/etcd
```
Create etcd user trên 3 nodes:
```sh
[root@etcd-* etcd]# useradd etcd -s /sbin/nologin -r -d /var/lib/etcd
```
Fixing permissions trên tất cả các `etcd` node ở required directory và files:
```sh
chmod -Rv 550 /etc/ssl/etcd/
chmod 440 /etc/ssl/etcd/ssl/*.pem
chown -Rv etcd:etcd /etc/ssl/etcd/
chown -Rv etcd:etcd /etc/ssl/etcd/*
chown etcd:etcd /var/lib/etcd/
```
Setting Up etcd service daemon files on all etcd nodes:

It is required to create etcd service files on every etcd nodes so that we can start and enable etcd as service daemon.
```sh
[root@etcd-* etcd]# vi /usr/lib/systemd/system/docker.service

[Unit]
Description=etcd
After=network.target

[Service]
Type=notify
User=etcd
EnvironmentFile=/etc/etcd.env
ExecStart=/usr/bin/etcd
NotifyAccess=all
Restart=always
RestartSec=10s
LimitNOFILE=40000

[Install]
WantedBy=multi-user.target
```
File config `etcd` trên mỗi Node.

Tạo 1 file config `/etc/etcd.env` để gọi từ file etcd service.
File config `etcd` cho Node 1:
```sh
[root@etcd1 etcd]# vim /etc/etcd.env
ETCD_DATA_DIR=/var/lib/etcd
ETCD_ADVERTISE_CLIENT_URLS=https://10.10.10.221:2379
ETCD_INITIAL_ADVERTISE_PEER_URLS=https://10.10.10.221:2380
ETCD_INITIAL_CLUSTER_STATE=new
ETCD_LISTEN_CLIENT_URLS=https://10.10.10.221:2379
ETCD_ELECTION_TIMEOUT=5000
ETCD_HEARTBEAT_INTERVAL=250
ETCD_LISTEN_PEER_URLS=https://10.10.10.221:2380
ETCD_NAME=etcd1
ETCD_PROXY=off
ETCD_INITIAL_CLUSTER=etcd1=https://10.10.10.221:2380,etcd2=https://10.10.10.222:2380,etcd3=https://10.10.10.223:2380
#ETCD_INITIAL_CLUSTER=etcd1=https://10.10.10.221:2380
# TLS settings
ETCD_TRUSTED_CA_FILE=/etc/ssl/etcd/ssl/ca.pem
ETCD_CERT_FILE=/etc/ssl/etcd/ssl/member-etcd1.pem
ETCD_KEY_FILE=/etc/ssl/etcd/ssl/member-etcd1-key.pem
ETCD_PEER_TRUSTED_CA_FILE=/etc/ssl/etcd/ssl/ca.pem
ETCD_PEER_CERT_FILE=/etc/ssl/etcd/ssl/member-etcd1.pem
ETCD_PEER_KEY_FILE=/etc/ssl/etcd/ssl/member-etcd1-key.pem
ETCD_PEER_CLIENT_CERT_AUTH=true
```
File config `etcd` cho Node 2:
```sh
[root@etcd2 etcd]# vim /etc/etcd.env
ETCD_DATA_DIR=/var/lib/etcd
ETCD_ADVERTISE_CLIENT_URLS=https://10.10.10.222:2379
ETCD_INITIAL_ADVERTISE_PEER_URLS=https://10.10.10.222:2380
ETCD_INITIAL_CLUSTER_STATE=new
ETCD_LISTEN_CLIENT_URLS=https://10.10.10.222:2379
ETCD_ELECTION_TIMEOUT=5000
ETCD_HEARTBEAT_INTERVAL=250
ETCD_LISTEN_PEER_URLS=https://10.10.10.222:2380
ETCD_NAME=etcd2
ETCD_PROXY=off
ETCD_INITIAL_CLUSTER=etcd1=https://10.10.10.221:2380,etcd2=https://10.10.10.222:2380,etcd3=https://10.10.10.223:2380
#ETCD_INITIAL_CLUSTER=etcd2=https://10.10.10.222:2380
# TLS settings
ETCD_TRUSTED_CA_FILE=/etc/ssl/etcd/ssl/ca.pem
ETCD_CERT_FILE=/etc/ssl/etcd/ssl/member-etcd2.pem
ETCD_KEY_FILE=/etc/ssl/etcd/ssl/member-etcd2-key.pem
ETCD_PEER_TRUSTED_CA_FILE=/etc/ssl/etcd/ssl/ca.pem
ETCD_PEER_CERT_FILE=/etc/ssl/etcd/ssl/member-etcd2.pem
ETCD_PEER_KEY_FILE=/etc/ssl/etcd/ssl/member-etcd2-key.pem
ETCD_PEER_CLIENT_CERT_AUTH=true
```
File config `etcd` cho Node 3:
```sh
[root@etcd3 etcd]# vim /etc/etcd.env
ETCD_DATA_DIR=/var/lib/etcd
ETCD_ADVERTISE_CLIENT_URLS=https://10.10.10.223:2379
ETCD_INITIAL_ADVERTISE_PEER_URLS=https://10.10.10.223:2380
ETCD_INITIAL_CLUSTER_STATE=new
ETCD_LISTEN_CLIENT_URLS=https://10.10.10.223:2379
ETCD_ELECTION_TIMEOUT=5000
ETCD_HEARTBEAT_INTERVAL=250
ETCD_LISTEN_PEER_URLS=https://10.10.10.223:2380
ETCD_NAME=etcd3
ETCD_PROXY=off
ETCD_INITIAL_CLUSTER=etcd1=https://10.10.10.221:2380,etcd2=https://10.10.10.222:2380,etcd3=https://10.10.10.223:2380
#ETCD_INITIAL_CLUSTER=etcd3=https://10.10.10.223:2380
# TLS settings
ETCD_TRUSTED_CA_FILE=/etc/ssl/etcd/ssl/ca.pem
ETCD_CERT_FILE=/etc/ssl/etcd/ssl/member-etcd3.pem
ETCD_KEY_FILE=/etc/ssl/etcd/ssl/member-etcd3-key.pem
ETCD_PEER_TRUSTED_CA_FILE=/etc/ssl/etcd/ssl/ca.pem
ETCD_PEER_CERT_FILE=/etc/ssl/etcd/ssl/member-etcd3.pem
ETCD_PEER_KEY_FILE=/etc/ssl/etcd/ssl/member-etcd3-key.pem
ETCD_PEER_CLIENT_CERT_AUTH=true
```
Applying ETCD configuration on systemd cho mỗi Node:

In systemd based system it is required to reload daemon on every etcd nodes after service file change.
```sh
systemctl daemon-reload
systemctl start etcd
systemctl enable etcd
```
Xác thực trạng thấu cluster `etcd`:

Thực hiện trên mỗi Node:
```sh
$ etcdctl -C https://192.168.43.45:2379 --ca-file /etc/ssl/etcd/ssl/ca.pem cluster-health
member 649628565489a99c is healthy: got healthy result from https://192.168.43.45:2379
member caa56683e6af0137 is healthy: got healthy result from https://192.168.43.46:2379
member dc4795c6ff3e6627 is healthy: got healthy result from https://192.168.43.47:2379
cluster is healthy
```
## Tài liệu tham khảo
- https://medium.com/@pkp.plus/kubernetes-etcd-data-store-cluster-with-tls-certificate-93cc13d1401a
- https://syshunt.com/kubernetes-etcd-data-store-cluster-with-tls-certificate/




