# Cài đặt OpenVPN client sử dụng Docker container trên Ubuntu 14.04
## Mô hình hệ thống
|Server|IP|
|------|--|
|pfSense|192.168.1.1|
|Client|192.168.1.2|

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
