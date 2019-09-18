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
## Cách gói tin đi từ `Internet` vào `container`
<img src=https://i.imgur.com/aeolbEb.png>
## Cách gói tin đi trong `iptables`
<img src=https://i.imgur.com/kN0VEAv.png>
