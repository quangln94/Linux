#
## Run 2 `container`
```sh
docker run -it centos /bin/bash
docker run -it ubuntu /bin/bash
```
Sau khi chạy `container` thì `docker host` sẽ sinh ra 1 card mang có tên là `docker0`
<img src=https://i.imgur.com/tuS6Bc5.png>

## Kiểm tra bằng lệnh `brctl show`
<img src=https://i.imgur.com/xITlHyI.png>

## Kiểm tra `IP` của từng `container`
<img src=https://i.imgur.com/UdmUmCC.png>

## Kết nối từ network ở ngoài vào container
Để kết nối từ network ở ngoài vào container thì phải mapping port của máy host với port mà container expose thông qua docker0.

Ví dụ: map port 80 của máy host vào port 8080 của docker , sử dụng apache container:

## Cách gói tin đi từ `container` ra `Internet`
<img src=https://i.imgur.com/EUdWhF1.png>

`container` có IP: 172.17.0.2 đi qua port 80 đến bridge `docker0` -> qua `iptables` đi ra cổng `eth0` port 8080 có IP: 192.168.1.2 qua Gateway và ra `Internet`

## Cách gói tin đi từ `Internet` vào `container`
<img src=https://i.imgur.com/aeolbEb.png>

Host từ `Internet` đi vào cổng `eth0` qua port 8080 -> qua `iptables` -> đến bridge `docker0` -> qua port 80 của `container` có IP: 172.17.0.2

## Cách gói tin đi trong `iptables`
<img src=https://i.imgur.com/kN0VEAv.png>
