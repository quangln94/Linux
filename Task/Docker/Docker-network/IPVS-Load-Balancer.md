# A minimal IPVS Load Balancer demo
Trong cụm cluster, bạn có thể sử dụng K8s ingress controller để định tuyến lưu lượng truy cập đến apps và services cụ thể bằng các quy tắc định tuyến L7 phức tạp (như Host headers, cookies-stickiness, etc..). Tuy nhiên, điều này vẫn có nghĩa là các kết nối TCP có thể bị ngắt tại 1 node trong cụm cluster nếu bạn có DNS được setup theo cách đó. Sau đó, việc thêm L4 IP load balancer bên ngoài cụm K8s để cân bằng lưu lượng giữa tất cả các node chạy ingress controller là cần thiết.

<img src=https://i.imgur.com/vNMa3lq.png>

Có 1 vài service có thể thực hiện Layer 4 load balancing: Nginx/Nginx Plus, HAProxy, và bài này sẽ xem về IPVS. 

IPVS (IP Virtual Service) là 1 Linux kernel load balancer nó là 1 phần của Linux dựa trên hệ OS sử dụng kernel 2.4.x trở lên. Nó dựa trên thành phần Linux netfilter.

Phần còn lại của bài này sẽ là bản demo nhanh về việc sử dụng IPVS để balance giữa 2 docker containers 1 node.

## 1. Cài đặt

```sh
yum install ipvsadm -y
```
***Chú ý: `ipvsadm` chỉ là cli tools để tương tác với IP Virtual server table trong kernel. `ip_vs` là kernel module thực hiện thao tác kết nối thực tế***

## 2. Kiểm tra command có thể sử dụng
```sh
[root@server01 ~]# ipvsadm -l
IP Virtual Server version 1.2.1 (size=4096)
Prot LocalAddress:Port Scheduler Flags
  -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
[root@server01 ~]#
```

## 3. Launch 2 nginx Docker containers 
```sh
[root@server03 ~]# mkdir /srv/A /srv/B
[root@server03 ~]# echo "This is A" > /srv/A/index.html
[root@server03 ~]# echo "This is B" > /srv/B/index.html
[root@server03 ~]# docker run --rm -d -v "/srv/A:/usr/share/nginx/html" --name nginx-A nginx
Unable to find image 'nginx:latest' locally
latest: Pulling from library/nginx
8d691f585fa8: Pull complete
047cb16c0ff6: Pull complete
b0bbed1a78ca: Pull complete
Digest: sha256:77ebc94e0cec30b20f9056bac1066b09fbdc049401b71850922c63fc0cc1762e
Status: Downloaded newer image for nginx:latest
7ccc57653aba028734a0cd8cade0827fcee6053ee9d8b3a7946e9ba60f6033a0
[root@server03 ~]# docker run --rm -d -v "/srv/B:/usr/share/nginx/html" --name nginx-B nginx
94c31bfa3c53b9a8e79836d668024da56f16a82673b7b5d9e8e2f984563d0b14
[root@server03 ~]# docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' nginx-A
172.17.0.2
[root@server03 ~]# docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' nginx-B
172.17.0.3
[root@server03 ~]#
```
Kiểm tra curl hoạt động trên cả 2 servers:
```sh
[root@server03 ~]# curl 172.17.0.2
This is A
[root@server03 ~]# curl 172.17.0.3
This is B
[root@server03 ~]#
```

## Tài liệu tham khảo
- https://medium.com/@benmeier_/a-quick-minimal-ipvs-load-balancer-demo-d5cc42d0deb4
