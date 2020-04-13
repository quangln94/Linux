# Cài đặt Proxy cho Docker sử dụng OpenVPN client container trên Ubuntu 14.04
## Mô hình hệ thống

|Server|IP Public|IP VPN|
|------|---------|------|
|pfSense|123.4.5.6|192.168.1.1|
|Proxy|||
|Client|192.168.1.3||

## 1. Thực hiện trên pfSense
- Cài đặt, start và enable docker
```
apt-get install docker
/etc/init.d/docker start
update-rc.d docker defaults
```
- Export file cấu hình của 1 user sử dụng để kết nối VPN

Thực hiện như sau:

VPN -> OpenVPN -> Client Export -> Chọn User -> Most Clients

<img src=https://i.imgur.com/SGRvPtG.png>

<img src=https://i.imgur.com/iZxGQYA.png>

<img src=https://i.imgur.com/RCjRi35.png>

## 2. Thực hiện trên Proxy
- Tạo thư mục `vpn` và Copy File config vừa Export vào thư mục `vpn`
```sh
mkdir /vpn
cp pfSense-TCP4-1194-user-config.ovpn /vpn/vpn.conf
```
- Tạo file lưu account và password của User VPN
```sh
cat << EOF >> /vpn/vpn.auth
user
password
EOF
```
- Chỉnh sửa file cấu hình như sau:
```sh
dev tap
persist-tun
persist-key
cipher AES-128-CBC
#ncp-ciphers AES-256-GCM:AES-128-GCM    #Comment dòng ncp-ciphers lại nếu không sẽ báo lỗi
auth SHA256
tls-client
client
resolv-retry infinite
remote 123.4.5.6 1194 tcp-client
verify-x509-name "server-cert" name
auth-user-pass /vpn/vpn.auth            #File chứa account và password
remote-cert-tls server
reneg-sec 0
...
```
- Chạy OpenVPN client container
```sh
docker run -d --name vpn-client \
  --cap-add=NET_ADMIN \
  --device /dev/net/tun \
  -v /vpn:/vpn \
  ekristen/openvpn-client --config /vpn/vpn.conf --askpass 	/vpn/vpn.auth --auth-nocache
```
- Vào container `vpn-client` kiểm tra IP VPN
```
$ docker exec -it vpn-client sh
$ ip a
tap0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UNKNOWN group default qlen 100
    link/ether b2:75:0c:3e:d7:81 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.2/24 brd 192.168.1.255 scope global tap0
       valid_lft forever preferred_lft forever
    inet6 fe80::b075:cff:fe3e:d781/64 scope link
       valid_lft forever preferred_lft forever
```
- Chạy squid container làm proxy
```sh
docker run --name squid -d --restart=always \
  --publish 3128:3128 \
  --volume /srv/docker/squid/cache:/var/spool/squid \
  --net=container:vpn-client \
  sameersbn/squid:3.3.8-23
```
## 3. Kiểm tra kết nối Proxy
- Tạo file với nội dung sau
```sh
mkdir /etc/systemd/system/docker.service.d
cat << EOF >> /etc/systemd/system/docker.service.d/http-proxy.conf
[Service]
Environment="HTTP_PROXY=http://192.168.1.2:3128"
Environment="HTTPS_PROXY=http://192.168.1.2:3128"
EOF
```
- Restart lại Docker
```sh
systemctl daemon-reload
systemctl restart docker
```
- Pull images bất kỳ để kiểm tra
```sh
docker pull nginx
```
## Tài liệu tham khảo
- https://hub.docker.com/r/ekristen/openvpn-client/
