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

## 4. Set up a new IPVS service

Bây giờ ta thiết lập một IPVS service mới được liên kết với public IP server (ví dụ: 192.168.1.100). Ta sẽ biến nó thành một tcp load balancer sử dụng thuật toán round robin (`-t` và `-s rr`):
```sh
[root@server03 ~]# ipvsadm -l -n
IP Virtual Server version 1.2.1 (size=4096)
Prot LocalAddress:Port Scheduler Flags
  -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
TCP  192.168.1.100:80 rr
[root@server03 ~]#
```
## 5. Add the Docker container IPs as the “real” hosts
```sh
[root@server03 ~]# ipvsadm -a -t 192.168.1.100:80 -r 172.17.0.2 -m
[root@server03 ~]# ipvsadm -a -t 192.168.1.100:80 -r 172.17.0.3 -m
[root@server03 ~]#
```
## 6. Issue some requests!
Bạn có thể làm điều này từ chính VM hoặc cho một ví dụ hữu ích hơn, thực hiện nó từ một máy khác có thể kết nối với VM.
```sh
[root@server03 ~]# curl 192.168.1.100
This is B
[root@server03 ~]# curl 192.168.1.100
This is A
```
Theo mặc định, điều này sẽ sử dụng round robin load balancing, nó sẽ chỉ lặp qua danh sách các điểm đến:
```sh
[root@server03 ~]# for i in {1..10}; do curl 192.168.1.100; done
This is A
This is B
This is A
This is B
This is A
This is B
This is A
This is B
This is A
This is B
```
Chúng ta có thể thay đổi trọng số của một server

Đầu tiên thay đổi chế độ scheduling thành Weighted Round Robin (wrr)
```sh
[root@server03 ~]# ipvsadm -E -t 192.168.1.100:80 -s wrr
```
Và sau đó thay đổi trọng số 1 Node: 
```sh
[root@server03 ~]# ipvsadm -e -t 192.168.1.100:80 -r 172.17.0.3 -m -w 3
```
Bây giờ khi chúng ta thực hiện các requests, hãy xem sự thay đổi
```sh
[root@server03 ~]# for i in {1..10}; do curl 192.168.1.100; done
This is B
This is A
This is B
This is B
This is B
This is A
This is B
This is B
This is B
This is A
```
## 7. Check out the stats and rates!
Số liệu thống kê cho tổng số gói và byte trong lifetime của servers.
```sh
[root@server03 ~]# sudo ipvsadm -L -n --stats --rate
IP Virtual Server version 1.2.1 (size=4096)
Prot LocalAddress:Port               Conns   InPkts  OutPkts  InBytes OutBytes
  -> RemoteAddress:Port
TCP  192.168.1.100:80                   29      203      145    13021    14877
  -> 172.17.0.2:80                      12       84       60     5388     6156
  -> 172.17.0.3:80                      17      119       85     7633     8721
[root@server03 ~]#
```
Rate information cho thấy một cái nhìn trực tiếp hơn về các giá trị mỗi giây.
```sh
[root@server03 ~]# ipvsadm -L -n --rate
IP Virtual Server version 1.2.1 (size=4096)
Prot LocalAddress:Port                 CPS    InPPS   OutPPS    InBPS   OutBPS
  -> RemoteAddress:Port
TCP  192.168.1.100:80                    0        1        0       33       38
  -> 172.17.0.2:80                       0        0        0        6        7
  -> 172.17.0.3:80                       0        0        0       27       30
[root@server03 ~]#
```
Bạn có thể thấy đây là một cách khá đơn giản để kiểm soát TCP load balancer!

Điều này rất phù hợp để thực hiện L4 load balancing trước Kubernetes cluster’s ingress controllers. Điều này cho phép các ingress controllers tập trung vào per-service routing logic (L7).

## Additional Thoughts
### Controlling an IPVS host from Kubernetes

K8s sẽ điều khiển và tương tác với IPVS host thông qua cloud controller manager của nó (hoặc tài nguyên tùy chỉnh riêng biệt, nhưng bộ cân bằng tải bên ngoài đã là một khái niệm trong CCM). CCM sẽ đảm bảo rằng bộ cân bằng tải có các K8s node IPs và ports được cấu hình chính xác cho ingress resources/controllers, specific Node ports, hoặc Service IPs (nếu chúng có thể định tuyến được).

### Connection draining between servers

Bạn có thể sử dụng Weighted Round Robin scheduler để đạt được hiệu ứng thoát kết nối giữa hai servers O(old) và N(new) theo cách sau:
- Set O.weight to 100
- Add server N with weight 0(0% of requests)
- Over an period T at interval I, reduce O.weight and increase N.weight

### Using healthchecks to remove dead hosts

Bạn có thể setup IPVS host của mình để kiểm tra sức khỏe đối với các hosts  trong một service cụ thể và nếu phát hiện thấy bất kỳ thiết bị nào bad hoặc not responding như mong đợi, có thể đặt giá trị hosts weight thành 0. Ngăn chặn hiệu quả lưu lượng truy cập được gửi đến host đó. Khi kiểm tra sức khỏe bắt đầu trở lại chính xác, yêu cầu có thể được gửi một lần nữa đến host.

Thiết lập CI/CD của bạn có thể ưu tiên điều này bằng cách thông báo cho IPVS host rằng một host cụ thể sẽ không khả dụng trong khi ứng dụng được triển khai lại.

### Healthchecks for IPVS

It would be a good idea to have a health check or metrics coming out of the IPVS hosts themselves. Since `ipvsadm` can expose `--stats` and `--rates` these could naturally be included as well as the normal Linux indicators for dropped packets, dropped connections, and inflight connections. This is the place we’d want to be aware of DoS patterns, so you’d want to keep an eye on memory usage and that sort of thing.
Perhaps a little prometheus endpoint could be written help extract these things from `ipvsadm`. Although it looks like the same information is available in raw form from `/proc/net/ip_vs_stats`.

## Tài liệu tham khảo
- https://medium.com/@benmeier_/a-quick-minimal-ipvs-load-balancer-demo-d5cc42d0deb4
- https://success.docker.com/article/ucp-service-discovery-swarm
