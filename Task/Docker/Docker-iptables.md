# Docker iptables
Container giao tiếp thông qua bridge mặc định được tạo ra khi cài đặt Docker.

## 1. Giao tiếp với bên ngoài
Container có thể giao tiếp với bên ngoài hay không phụ thuộc 2 yếu tố. Yếu tố đầu tiên là liệu host có forward các gói IP của nó hay không. Thứ hai là liệu iptables của host có cho phép kết nối cụ thể này hay không.

```sh
$ sysctl net.ipv4.conf.all.forwarding
net.ipv4.conf.all.forwarding = 0
$ sysctl net.ipv4.conf.all.forwarding=1
$ sysctl net.ipv4.conf.all.forwarding
net.ipv4.conf.all.forwarding = 1
```

Mặc định, các quy tắc chuyển tiếp Docker cho phép tất cả các IP nguồn bên ngoài. Để chỉ cho phép một IP hoặc mạng cụ thể truy cập vào các container. 
Ví dụ: để hạn chế quyền truy cập bên ngoài sao cho chỉ IP nguồn.8.8.8.8 có thể truy cập vào các container:
```sh
iptables -I DOCKER -i ext_if ! -s 8.8.8.8 -j DROP
```


- https://docs.docker.com/v17.09/engine/userguide/networking/default_network/container-communication/#communicating-to-the-outside-world
