# ETCD Data Store Cluster with TLS Certificate


## Certificate Generation:
Sử dụng `openssl` để tạo certificate.
```sh
[root@etcd-01]# mkdir /root/etcd-certificate
[root@etcd-01]# cd /root/etcd-certificate
[root@etcd-01 etcd-certificate]# openssl genrsa -out ca-key.pem 2048
[root@etcd-01 etcd-certificate]# openssl req -x509 -new -nodes -key ca-key.pem -days 10000 -out ca.pem -subj "/CN=etcd-ca"
```

Tạo certificate trên ETCD node-1:
```sh
[root@etcd-01 etcd-certificate]# vi openssl.conf

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
DNS.2 = etcd-01
IP.1 = 192.168.43.45
IP.2 = 127.0.0.1
```
Set openssl.conf location variable
```sh
[root@etcd-01 etcd-certificate]# CONFIG=`echo $PWD/openssl.conf`
```
Generate Certificates:
```sh
[root@etcd-01 etcd-certificate]# openssl genrsa -out member-etcd-01-key.pem 2048
[root@etcd-01 etcd-certificate]# openssl req -new -key member-etcd-01-key.pem -out member-etcd-01.csr -subj "/CN=etcd-01" -config ${CONFIG}
[root@etcd-01 etcd-certificate]# openssl x509 -req -in member-etcd-01.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out member-etcd-01.pem -days 3650 -extensions ssl_client -extfile ${CONFIG}
```

