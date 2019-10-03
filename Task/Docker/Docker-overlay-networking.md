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











## Tài liệu tham khảo
- http://blog.nigelpoulton.com/demystifying-docker-overlay-networking/
