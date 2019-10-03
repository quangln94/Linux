# Docker overlay networking
## 1. Build và test 1 Docker overlay network trong swarm mode
Ví dụ sau sử dụng 2 máy chủ Docker-host trên hai mạng Lớp 2 riêng biệt được kết nối bằng Router như hình dưới đây

<img src=https://i.imgur.com/p32PJvA.png>

Mỗi host chạy Docker 1.12 hoặc cao hơn và Linux kernel 4.4 (newer is always better).

### 1.1 Build a swarm
Đầu tiên chúng tôi sẽ làm là cấu hình 2 host thành một Swarm 2 node. Chạy lệnh `docker swarm init` trên node 1 để biến nó thành manager, sau đó chạy lệnh `docker swarm join` trên node 2 để biến nó thành một worker.

Chạy lệnh sau trên Node 1:
```sh
$ docker swarm init
Swarm initialized: current node (1ex3...o3px) is now a manager.

To add a worker to this swarm, run the following command:

docker swarm join \
 --token SWMTKN-1-0hz2ec...2vye \
 172.31.1.5:2377
 ```
 Chạy lệnh sau trên Node 2
 ```sh
 $ docker swarm join \
> --token SWMTKN-1-0hz2ec...2vye \
> 172.31.1.5:2377
This node joined a swarm as a worker.
```
=> Bây giờ ta có 1 Swarm 2 Node trong đó Node1 là một manager và Node2 là một worker.

### 1.2 Create a new overlay network
Bây giờ tạo ra 1  overlay network mới gọi là `uber-net`.

Chạy lệnh sau trên Node 1:

```sh
$ docker network create -d overlay uber-net
c740ydi1lm89khn5kd52skrd9
```

Ta vừa tạo 1 overlay network nó available cho tất cả các host trong swarm và có control plane được mã hóa bằng TLS!

Bạn có thể liệt kê tất cả các mạng trên mỗi Node bằng lệnh `docker netowwrk ls`.
```sh
$ docker network ls
NETWORK ID    NAME              DRIVER   SCOPE
ddac4ff813b7  bridge            bridge   local
389a7e7e8607  docker_gwbridge   bridge   local
a09f7e6b2ac6  host              host     local
ehw16ycy980s  ingress           overlay  swarm
2b26c11d3469  none              null     local
c740ydi1lm89  uber-net          overlay  swarm
```
Mạng vừa tạo ra nằm ở cuối danh sách được gọi là `uber-net`.

Các mạng khác được tạo tự động khi Docker được cài đặt và khi tạo swarm. Ta chỉ quan tâm đến overlay network `uber-net`.

Chạy lệnh `docker mạng ls` trên Node2, bạn sẽ không thể thấy nhìn thấy mạng `uber-net`. Điều này là do overlay networks chỉ được cung cấp cho các Node worker có các container sử dụng overlay networks. Điều này làm giảm phạm vi của giao thức network gossip và giúp khả năng mở rộng.

### 1.3. Attach a service to the overlay network

Tạo ra một Docker-service mới và gắn nó vào `uber-net`. Tạo ra dịch vụ với 2 bản sao (container) để một bản chạy trên Node1 và bản còn lại chạy trên Node2. Điều này sẽ tự động mở rộng uber-net overlay đến Node2.

Chạy lệnh sau trên Node1:
```sh
$ docker service create --name test \
--network uber-net \
--replicas 2 \
ubuntu sleep infinity
```
Lệnh tạo một service mới gọi là `test`, gắn nó vào `uber-net` và tạo 2 container (bản sao) chạy lệnh `sleep infinity`. Lệnh này đảm bảo các container không thoát ngay lập tức.

Bởi vì ta đang chạy 2 container (bản sao) và Swarm có 2 Node, nên 1 container sẽ chạy trên mỗi Node.

Verify the operation with a `docker service ps` command.
```sh
$ docker service ps
ID          NAME    IMAGE   NODE   DESIRED STATE   CURRENT STATE
77q...rkx   test.1  ubuntu  node1  Running         Running
97v...pa5   test.2  ubuntu  node2  Running         Running
```
Khi Swarm start 1 container trên overlaynetwork, nó sẽ tự động mở rộng mạng đó đến Node mà container chạy. Điều này có nghĩa là mạng `uber-net` hiện hiển thị trên Node2.

Bạn đã tạo một overlaynetwork mới kéo dài trên 2 Node riêng biệt dựa trên mạng vậy lý và bạn đã lên lịch cho 2 container để sử dụng mạng.

<img src=https://i.imgur.com/OYSu9bW.png>

### 1.4 Test the overlay network

Kiểm tra overlay network bằng lệnh ping.

Để thực hiện điều này, chúng ta cần phải đào sâu một chút để có được từng địa chỉ IP của container.
```sh
 $ docker network inspect uber-net
 [
   {
     "Name": "uber-net",
     "Id": "c740ydi1lm89khn5kd52skrd9",
     "Scope": "swarm",
     "Driver": "overlay",
     "EnableIPv6": false,
     "IPAM": {
       "Driver": "default",
       "Options": null,
       "Config": [
         {
           "Subnet": "10.0.0.0/24",
           "Gateway": "10.0.0.1"
         }
 <Snip>
```
Output ở trên cho thấy subnet của `uber-net` là `10.0.0.0/24`. Điều này không khớp với một trong hai mạng vật lý (`172.31.1.0/24` và `192.168.1.0/24`).

Chạy hai lệnh sau trên Node1 và Node2 để lấy ID container và địa chỉ IP của chúng.
```
$ docker ps
 CONTAINER ID  IMAGE           COMMAND            CREATED       STATUS
 396c8b142a85  ubuntu:latest   "sleep infinity"   2 hours ago   Up 2 hrs
 $
 $ docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' 396c8b142a85
 10.0.0.3
```
Hãy chắc chắn rằng bạn chạy các lệnh này trên cả hai Node để lấy địa chỉ IP của cả hai container.

Biểu đồ dưới đây cho thấy cấu hình cho đến bây giờ.

<img src=https://i.imgur.com/nab7ER8.png>

Có thể thấy, có 1 Layer 2 overlay network nối 2 host và mỗi container có 1 địa chỉ IP trên overlay network này. Điều này có nghĩa là container trên Node1 sẽ có thể ping container trên Node2 bằng cách sử dụng địa chỉ IP `10.0.0.4` từ overlay network. Điều này hoạt động mặc dù thực tế là cả hai Node nằm trên các mạng lớp 2 riêng biệt. Hãy để chứng minh điều đó.

Đăng nhập vào container trên Node1 và cài đặt tiện ích `ping` và sau đó ping container trên Node2 bằng địa chỉ IP` 10.0.0.4` của nó.

ID container được sử dụng bên dưới sẽ khác trong môi trường của bạn.

```sh
$ docker exec -it 396c8b142a85 bash
 root@396c8b142a85:/#
 root@396c8b142a85:/#
 root@396c8b142a85:/# apt-get update
 <Snip>
 root@396c8b142a85:/#
 root@396c8b142a85:/#
 root@396c8b142a85:/# apt-get install iputils-ping
 Reading package lists... Done
 Building dependency tree
 Reading state information... Done
 <Snip>
 Setting up iputils-ping (3:20121221-5ubuntu2) ...
 Processing triggers for libc-bin (2.23-0ubuntu3) ...
 root@396c8b142a85:/#
 root@396c8b142a85:/#
 root@396c8b142a85:/# ping 10.0.0.4
 PING 10.0.0.4 (10.0.0.4) 56(84) bytes of data.
 64 bytes from 10.0.0.4: icmp_seq=1 ttl=64 time=1.06 ms
 64 bytes from 10.0.0.4: icmp_seq=2 ttl=64 time=1.07 ms
 64 bytes from 10.0.0.4: icmp_seq=3 ttl=64 time=1.03 ms
 64 bytes from 10.0.0.4: icmp_seq=4 ttl=64 time=1.26 ms
 ^C
 root@396c8b142a85:/#
```
Như ở trên, container trên Node1 có thể ping container trên Node2 bằng cách sử dụng overlay network.

Nếu bạn cài đặt `traceroute` trên container và theo dõi tuyến đường đến container từ xa, bạn sẽ chỉ thấy một hop duy nhất (xem bên dưới). Điều này chứng tỏ rằng các container đang nói chuyện trực tiếp qua overlay network và hoàn toàn không biết nó đi qua lớp nào.

```sh
$ root@396c8b142a85:/# traceroute 10.0.0.4
 traceroute to 10.0.0.4 (10.0.0.4), 30 hops max, 60 byte packets
 1 test-svc.2.97v...a5.uber-net (10.0.0.4) 1.110ms 1.034ms 1.073ms
 ```
 
Cho đến nay, ta đã tạo ra một overlay network với một lệnh duy nhất. Sau đó, chúng tôi đã thêm các container vào mạng lớp phủ trên hai máy chủ trên hai mạng Lớp 2 khác nhau. Khi chúng tôi tìm ra các địa chỉ IP Container container, chúng tôi đã chứng minh rằng họ có thể nói chuyện trực tiếp qua mạng lớp phủ.

## Tài liệu tham khảo
- http://blog.nigelpoulton.com/demystifying-docker-overlay-networking/
