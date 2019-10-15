# Cài đặt Docker Swarm
## 1. Topology
3 Node cài CentOS7: 1 node master và 2 node worker
- Node master: 10.10.10.221
- Node worker 1: 10.10.10.222
- Node worker 2: 10.10.10.223

## 2. Cài đăt docker engine và cấu hình docker swarm

### 2.1 Cài đặt docker trên 3 node

- Cài đặt docker engine và chuẩn bị để sẵn sàng cấu hình docker swarm trên cả 03 node.
```sh
curl -sSL https://get.docker.com/ | sudo sh
```
- Phân quyền cho user để sử dụng docker 
```sh
sudo usermod -aG docker root
```
- Khởi động docker engine

```sh
systemctl start docker.service
systemctl enable docker.service
```
- Kiểm tra phiên bản của docker engine
```sh
docker version
```
- Kiểm tra hoạt động của docker engine sau khi cài 
```sh
systemctl status docker.service
```
- Disable live-store trên cả 03 node (vì docker swarm không dùng tùy chọn này). Soạn file `/etc/docker/daemon.json` với nội dung dưới

```sh
cat <<EOF> /etc/docker/daemon.json
{
    "live-restore": false
}
EOF
```
- Khởi động lại docker engine 
```sh
systemctl restart docker 
```
### 2.2 Cấu hình docker swarm
- Đứng trên node master thực hiện lệnh dưới để thiết lập docker swarm
 ```sh
docker swarm init --advertise-addr eth0
```
- Trong đó:
  - Nếu có nhiều NICs thì cần chỉ định thêm tùy chọn `--advertise-addr` để chỉ ra tên của interfaces mà docker swarm sẽ dùng, các node worker sẽ dùng IP này để join vào cluster.

  - Kết quả của lệnh trên như bên dưới, lưu ý dòng thông báo trong kết quả nhé. Dòng này để sử dụng trên các node worker.

```sh
[root@server01 ~]# docker swarm init --advertise-addr eth0
Swarm initialized: current node (v79xdwlmqs1yd15vs2vff6xbl) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-587brhrevpeamzw61rx66r22xx05pj9zgs2nqqduoz8hs0v1m5-876nb2phj3ufn388sltlhomr0 10.10.10.221:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

[root@server01 ~]#
 ```
- Đứng trên node `worker1` và `worker2` để join vào node master. Thực hiện cả trên 02 node worker còn lại.
```sh
    docker swarm join --token SWMTKN-1-587brhrevpeamzw61rx66r22xx05pj9zgs2nqqduoz8hs0v1m5-876nb2phj3ufn388sltlhomr0 10.10.10.221:2377
```
- Kết quả sẽ có thông báo như sau: 
 ```sh
docker swarm join --token SWMTKN-1-587brhrevpeamzw61rx66r22xx05pj9zgs2nqqduoz8hs0v1m5-876nb2phj3ufn388sltlhomr0 10.10.10.221:2377
This node joined a swarm as a worker.
[root@server02 ~]#
```
- Đứng trên node master thực hiện lệnh `docker node ls` để kiểm tra xem các node worker đã join hay chưa. Nếu chưa ổn thì kiểm tra kỹ lại các bước ở trên.

```sh
[root@server01 ~]# docker node ls
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
v79xdwlmqs1yd15vs2vff6xbl *   server01            Ready               Active              Leader              19.03.3
kbq8bz75is7m4x7h16vf7wivs     server02            Ready               Active                                  19.03.3
mjxwdp4sz6msbgcuxc901igzl     server03            Ready               Active                                  19.03.3
[root@server01 ~]#
```
    
### Kiểm tra hoạt động của cụm docker swarm vừa dựng.

- Tạo file `Dockerfile` với nội dung bên dưới trên tất cả các node. Ở đây tôi sẽ tạo ra một images chạy web server, lưu ý, tôi sẽ tạo các nội dung các web server khác nhau với 03 node để khi kiểm tra sẽ thấy các kết quả của container trên từng node.

- Trên node master
```sh
cat <<EOF> /root/Dockerfile
FROM centos
MAINTAINER hocchudong <admin@hocchudong.com>
RUN yum -y install httpd
RUN echo "Node master Hello DockerFile" > /var/www/html/index.html
EXPOSE 80
CMD ["-D", "FOREGROUND"]
ENTRYPOINT ["/usr/sbin/httpd"]
EOF
```
- Trên node worker1
```sh
cat <<EOF> /root/Dockerfile
FROM centos
MAINTAINER hocchudong <admin@hocchudong.com>
RUN yum -y install httpd
RUN echo "Node worker1 Hello DockerFile" > /var/www/html/index.html
EXPOSE 80
CMD ["-D", "FOREGROUND"]
ENTRYPOINT ["/usr/sbin/httpd"]
EOF
```
- Trên node worker2
```sh
cat <<EOF> /root/Dockerfile
FROM centos
MAINTAINER hocchudong <admin@hocchudong.com>
RUN yum -y install httpd
RUN echo "Node worker2 Hello DockerFile" > /var/www/html/index.html
EXPOSE 80
CMD ["-D", "FOREGROUND"]
ENTRYPOINT ["/usr/sbin/httpd"]
EOF
```
- Thực hiện build image với `Dockerfile` vừa tạo ở trên trên cả 3 node (lưu ý dấu . nhé, lúc này đang đứng tại thư mục `root`)
```sh
docker build -t web_server:latest . 
```
- Kết quả:

<img src=https://i.imgur.com/ezOXfCO.png>
  
- Tạo container từ image ở trên với số lượng bản sao là 03. Lúc này đứng trên node master thực hiện các lệnh dưới.
```sh
[root@server01 ~]# docker service create --name swarm_cluster --replicas=3 -p 80:80 web_server:latest
image web_server:latest could not be accessed on a registry to record
its digest. Each node will access web_server:latest independently,
possibly leading to different nodes running different
versions of the image.

r22njcntrxt9j8o9xarwha0rb
overall progress: 3 out of 3 tasks
1/3: running   [==================================================>]
2/3: running   [==================================================>]
3/3: running   [==================================================>]
verify: Service converged
[root@server01 ~]#
```
- Kiểm tra lại kết quả bằng lệnh `docker service ls` 
```sh
[root@server01 ~]# docker service list
ID                  NAME                MODE                REPLICAS            IMAGE               PORTS
r22njcntrxt9        swarm_cluster       replicated          3/3                 web_server:latest   *:80->80/tcp
[root@server01 ~]#
```
- Kiểm tra sâu hơn bên trong của cluster 
```sh
[root@server01 ~]# docker service inspect swarm_cluster --pretty

ID:             r22njcntrxt9j8o9xarwha0rb
Name:           swarm_cluster
Service Mode:   Replicated
 Replicas:      3
Placement:
UpdateConfig:
 Parallelism:   1
 On failure:    pause
 Monitoring Period: 5s
 Max failure ratio: 0
 Update order:      stop-first
RollbackConfig:
 Parallelism:   1
 On failure:    pause
 Monitoring Period: 5s
 Max failure ratio: 0
 Rollback order:    stop-first
ContainerSpec:
 Image:         web_server:latest
 Init:          false
Resources:
Endpoint Mode:  vip
Ports:
 PublishedPort = 80
  Protocol = tcp
  TargetPort = 80
  PublishMode = ingress

[root@server01 ~]#
```
- Kiểm tra trạng thái của các service bằng lệnh `docker service ps swarm_cluster`, các container sẽ nằm đều trên các node,kết quả như bên dưới.
```sh
[root@server01 ~]# docker service ps swarm_cluster
ID                  NAME                IMAGE               NODE                DESIRED STATE       CURRENT STATE           ERROR               PORTS
t1rj74s9mpr3        swarm_cluster.1     web_server:latest   server03            Running             Running 2 minutes ago
oo20wl1jotkj        swarm_cluster.2     web_server:latest   server01            Running             Running 2 minutes ago
8wbw2h2nwk73        swarm_cluster.3     web_server:latest   server02            Running             Running 2 minutes ago
[root@server01 ~]#
```
- Có thể kiểm tra các container trên từng node bằng lệnh `docker ps`, kết quả là thực hiện kiểm tra trên `worker1` và `worker2`

<img src=https://i.imgur.com/0VKAly3.png>
    
- Thử thay đổi số lượng container bằng lệnh. Lúc này container sẽ được tăng lên. 
```sh
[root@server01 ~]# docker service scale swarm_cluster=4
swarm_cluster scaled to 4
overall progress: 4 out of 4 tasks
1/4: running   [==================================================>]
2/4: running   [==================================================>]
3/4: running   [==================================================>]
4/4: running   [==================================================>]
verify: Service converged
[root@server01 ~]#
```

- Kiểm tra lại bằng lệnh `docker service ps swarm_cluster`

<img src=https://i.imgur.com/rftZmTP.png>

- Khi tắt thử các container trên một trong các node, sẽ có container mới được sinh ra để đảm bảo số container đúng với thiết lập.

<img src=https://i.imgur.com/rVuRrO4.png>

## Tài liệu tham khảo
- https://github.com/hocchudong/ghichep-docker/blob/master/docs/docker-coban/docker-thuchanh-caidat-docker-swarm.md
