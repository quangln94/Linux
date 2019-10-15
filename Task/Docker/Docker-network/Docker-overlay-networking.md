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

## 2. The theory of how it all works

Bây giờ, ta đã thấy cách build và sử dụng 1 container overlay network, hãy cùng tìm hiểu cách thức hoạt động.

### VXLAN primer
Trước hết, Docker overlay networking sử dụng VXLAN tunnels làm nền tảng để tạo virtual Layer 2 overlay networks. Vì vậy, trước khi đi xa hơn, hãy lướt nhanh qua công nghệ VXLAN.

Ở cấp độ cao nhất, VXLAN cho phép bạn tạo virtual Layer 2 network trên cơ sở hạ tầng Layer 3 hiện có. Ví dụ trước đã sử dụng để tạo ra một mạng 10.0.0.0/24 mới trên Layer 3 IP network bao gồm hai mạng Lớp 2: 172.31.1.0/24 và 192.168.1.0/24. Như dưới đây.

<img src=https://i.imgur.com/UdFGaLU.png>

Cái hay của VXLAN là các Router và cơ sở hạ tầng mạng hiện tại chỉ xem lưu lượng VXLAN là các gói IP/UDP thông thường và xử lý chúng mà không gặp sự cố.

Để tạo virtual Layer 2 overlay network, 1 VXLAN tunnel được tạo thông qua cơ sở hạ tầng IP lớp 3 bên dưới. Bạn có thể nghe thấy thuật ngữ underlay network được sử dụng để chỉ cơ sở hạ tầng Lớp 3 bên dưới.

Mỗi điểm cuối của VXLAN tunnel bị chấm dứt bởi VXLAN Tunnel Endpoint (VTEP). Nó có VTEP này thực hiện encapsulation/de-encapsulation và ma thuật khác cần thiết để thực hiện tất cả các công việc này. Xem bên dưới.

<img src=https://i.imgur.com/AyV0xvF.png> 

### Walk through our two-container example

Trong ví dụ trước đó, ta có 2 host được kết nối qua mạng IP. Mỗi host chạy 1 container duy nhất và ta đã tạo 1  VXLAN overlay network duy nhất cho các container để sử dụng.

Để thực hiện điều này, 1 network namespace mới đã được tạo trên mỗi host. 1 network namespace giống như 1 container, nhưng thay vì chạy một ứng dụng, nó chạy 1 isolated network stack - đó là 1 Sandboxed từ network stackđược trên chính host.

Một virtual switch (a.k.a virtual bridge) được gọi là `Br0` được tạo bên trong network namespace. Một VTEP cũng được tạo ra với một đầu được cắm vào virtual switch Br0 và đầu còn lại cắm vào  host network stack. Phần cuối trong host network stack nhận được một địa chỉ IP trên underlay network mà host được kết nối và được liên kết với UDP socket trên port 4789. Hai VTEP trên mỗi host tạo overlay qua VXLAN tunnel như bên dưới.

<img src=https://i.imgur.com/nAKuDuj.png>

Đây thực chất là VXLAN overlay network được tạo và sẵn sàng để sử dụng.

Mỗi container sau đó nhận virtual Ethernet (veth) adapter riêng cũng được cắm vào local virtual switch Br0. Topology bây giờ trông giống như hình ảnh bên dưới và sẽ dễ dàng hơn để xem cách 2 container có thể giao tiếp qua  VXLAN overlay network mặc dù các host của chúng nằm trên hai mạng riêng biệt.

<img src=https://i.imgur.com/AUm5A0r.png>

### Communication example

Bây giờ ta đã thấy các yếu tố chính để các container giao tiếp với nhau.

Với ví dụ này, ta sẽ gọi container trên Node1 là C1 và container trên Node2 là C2. Giả sử C1 muốn ping C2 như đã làm ở trên.

<img src=https://i.imgur.com/hpHbyB2.png>

C1 ping đến IP `10.0.0.4` của C2. Nó gửi lưu lượng qua interface `veth` được kết nối với virtual switch `Br0`. Virtual switch không biết nơi gửi gói tin vì nó không có bảng địa chỉ MAC (bảng ARP) tương ứng với địa chỉ IP đích. Kết quả là, nó đẩy ra tất cả các cổng. Interface VTEP được kết nối với Br0 biết cách chuyển tiếp khung và trả lời với địa chỉ MAC của chính nó. Đây là 1 proxy ARP và kết quả là switch Br0 học cách chuyển tiếp gói và nó cập nhật bảng ARP của nó mapping với địa chỉ `10.0.0.4` sang địa chỉ MAC của VTEP.

Bây giờ,  switch Br0 đã học cách chuyển tiếp lưu lượng đến C2, tất cả các gói sau này cho C2 sẽ được truyền trực tiếp đến interface VTEP. Interface `VTEP` biết về C2 vì tất cả các container mới khởi động đều có các chi tiết mạng được truyền đến các Node khác trong swarm bằng cách sử dụng giao thức network’s built-in gossip.

Sau đó, switch sẽ gửi gói đến interface VTEP, đóng gói các khung để chúng có thể được gửi qua cơ hạ tầng vận chuyển bên dưới. Ở mức khá cao, đóng gói này bao gồm thêm tiêu đề VXLAN vào khung Ethernet. Tiêu đề VXLAN chứa VXLAN network ID (VNID) được sử dụng để ánh xạ các khung từ VLAN sang VXLAN và ngược lại. Mỗi Vlan được ánh xạ tới VNID để ở đầu nhận, gói có thể được gói lại và chuyển tiếp đến Vlan chính xác. Điều này rõ ràng duy trì sự cô lập mạng. Việc đóng gói cũng bao bọc khung trong IP/UDP packet với địa chỉ IP của VTEP trên Node2 trong trường IP đích và thông tin UDP port 4789 socket. Việc đóng gói này cho phép dữ liệu được gửi qua underlying networks mà không cần underlying networks phải biết bất cứ điều gì về VXLAN.

Khi gói đến Node2, kernel thấy rằng nó được gửi đến UDP port 4789. Kernel cũng biết rằng nó có interface VTEP được liên kết với socket đó. Kết quả là, nó gửi packet đến VTEP để đọc VNID, de-encapsulates gói và gửi nó đến switch Br0 local của chính nó trên Vlan tương ứng với VNID. Từ đó nó được chuyển đến container C2.

Đó là những điều cơ bản về cách công nghệ VXLAN được tận dụng bởi Docker overlay networks.

Một điều cuối cùng cần đề cập về Docker overlay networks là Docker cũng hỗ trợ định tuyến lớp 3 trong cùng một overlay network. Ví dụ: bạn có thể tạo một overlay network với 2 mạng con và Docker sẽ đảm nhiệm việc định tuyến giữa chúng. Lệnh tạo một mạng như thế này có thể là `docker network create –subnet=10.1.1.0/24 –subnet=11.1.1.0/24 -d overlay prod-net`. Điều này sẽ dẫn đến 2 virtual switch Br0 và Br1 được tạo bên trong network namespace và việc định tuyến xảy ra theo mặc định.

## Tài liệu tham khảo
- http://blog.nigelpoulton.com/demystifying-docker-overlay-networking/

