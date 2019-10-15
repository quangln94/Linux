# Docker Swarm Reference Architecture: Exploring Scalable, Portable Docker Container Networks

## Table of Contents

1. What You Will Learn
2. Prerequisites
3. Challenges of Networking Containers and Microservices
4. The Container Networking Model
5.CNM Constructs
6.CNM Driver Interfaces
7.Docker Native Network Drivers
8. Network Scope
9. Docker Remote Network Drivers
10. Docker Remote IPAM Drivers
11. Linux Network Fundamentals
12. The Linux Bridge
13. Network Namespaces
14. Virtual Ethernet Devices
15. iptables
16. Microsoft Network Fundamentals
17. Networking in Windows 2016 and 2019
18. Windows Docker Network Drivers
19. Joining Windows to the Swarm
20. Networking in Windows: Further Reading
21. Docker Network Control Plane
22. Docker Host Network Driver
23. Docker Bridge Network Driver
24. Default Docker Bridge Network
25. User-Defined Bridge Networks
26. External Access for Standalone Containers
27. Overlay Driver Network Architecture
28. VXLAN Data Plane
29. Overlay Driver Internal Architecture
30. External Access for Docker Services
31. MACVLAN
32. VLAN Trunking with MACVLAN
33. None (Isolated) Network Driver
34. Physical Network Design Requirements
35. Swarm Native Service Discovery
36. Docker Native Load Balancing
37. UCP Internal Load Balancing
38. Swarm External L4 Load Balancing (Docker Routing Mesh)
39. UCP External L7 Load Balancing (HTTP Routing Mesh)
40. Docker Network Security and Encryption
41. Network Segmentation and Data Plane Security
42. Control Plane Security
43. Data Plane Network Encryption
44. Management Plane Security & RBAC with UCP
45. IP Address Management
46. Network Troubleshooting
47. Network Deployment Models
48. Bridge Driver on a Single Host
49. Multi-Host Bridge Driver with External Service Discovery
50. Multi-Host with Overlay Driver
51. Tutorial App: MACVLAN Bridge Mode
52. Conclusion


## 1. What You Will Learn

Docker container bao bọc một phần mềm trong một filesystem hoàn chỉnh chứa mọi thứ cần thiết để chạy: code, runtime, system tools, system libraries - bất cứ thứ gì có thể được cài đặt trên server. Điều này đảm bảo rằng phần mềm sẽ luôn chạy như nhau, bất kể môi trường của nó. Theo mặc định, containers cô lập các ứng dụng với nhau và cơ sở hạ tầng bên dưới, đồng thời cung cấp lớp bảo vệ bổ sung cho ứng dụng.

Điều gì xảy ra nếu các ứng dụng cần liên lạc với nhau, với host hay mạng bên ngoài? Làm thế nào để thiết kế một mạng để cho phép kết nối phù hợp trong khi duy trì tính di động của ứng dụng- application portability, service discovery, load balancing, security, performance, and scalability ? Tài liệu này là tổng quan về các khái niệm kiến trúc và thiết kế để xây dựng và mở rộng Docker container networks cho cả Linux và Microsoft servers.

## Challenges of Networking Containers and Microservices

Các thực tiễn của microservice đã cải thiện khả năng scale của các ứng dụng, điều này thậm chí còn quan trọng hơn đối với các phương thức kết nối và cách ly được cung cấp cho các ứng dụng. Triết lý Docker networking là hướng ứng dụng. Nó nhằm mục đích cung cấp các tùy chọn và tính linh hoạt cho các nhà khai thác mạng cũng như mức độ trừu tượng phù hợp cho các nhà phát triển ứng dụng.

Giống như bất kỳ thiết kế nào, network design là một hành động cân bằng. Docker Enterpirse và Docker ecosystem cung cấp nhiều công cụ cho network engineers để đạt được sự cân bằng tốt nhất cho các ứng dụng và môi trường của họ. Mỗi lựa chọn cung cấp lợi ích và sự đánh đổi khác nhau. Phần còn lại của hướng dẫn này nêu chi tiết từng lựa chọn này để các network engineers có thể hiểu điều gì có thể là tốt nhất cho môi trường của họ.

Docker đã phát triển một cách mới để cung cấp các ứng dụng và cùng với đó, các container cũng đã thay đổi một số khía cạnh về cách tiếp cận mạng. Các chủ đề sau đây là các chủ đề thiết kế phổ biến cho các ứng dụng được đóng gói:

- Portability (Tính di động): Làm cách nào để đảm bảo tính di động tối đa trên các môi trường mạng khác nhau trong khi tận dụng các đặc điểm mạng duy nhất?
- Service Discovery: Làm thế nào để biết nơi các dịch vụ đang sống khi chúng được scaled up and down ?
- Load Balancing: Làm cách nào để cân bằng tải trên các dịch vụ khi bản thân các dịch vụ được brought up and scaled?
- Security: Làm cách nào để phân đoạn để ngăn các container truy cập lẫn nhau?
Làm cách nào để đảm bảo rằng một container có lưu lượng kiểm soát ứng dụng và cụm là an toàn?
- Performance: Làm cách nào để cung cấp dvanced network services trong khi giảm thiểu độ trễ và tối đa hóa băng thông?
- Scalability: Làm cách nào để đảm bảo rằng không có đặc điểm nào trong số những đặc điểm này bị mất khi nhân rộng các ứng dụng trên nhiều máy chủ?

## The Container Networking Model

Kiến trúc Docker networking được xây dựng trên một tập hợp các giao diện được gọi là Container Networking Model (CNM). Triết lý của CNM là cung cấp tính di động ứng dụng trên các cơ sở hạ tầng đa dạng. Mô hình này tạo ra sự cân bằng để đạt được tính di động của ứng dụng và cũng tận dụng các tính năng và khả năng đặc biệt của cơ sở hạ tầng.

<img src=https://i.imgur.com/xdvNwlf.png>


## CNM Constructs

Có một số cấu trúc cấp cao trong CNM. Chúng đều là OS và cơ sở hạ tầng bất khả tri để các ứng dụng có thể có trải nghiệm thống nhất bất kể cơ sở hạ tầng.

- ***Sandbox*** - 1 Sandbox chứa cấu hình của 1 container's network stack. Điều này bao gồm việc quản lý interafces, routing table và cài đặt DNS của container. Việc triển khai Sandbox có thể là Windows HNS hoặc Linux Network Namespace, 1 FreeBSD Jail, hoặc khái niệm tương tự khác. Một Sandbox có thể chứa nhiều endpoints từ multiple networks.
- ***Endpoint*** - 1 Endpoint kết nối 1 Sandbox với 1 Network. Cấu trúc Endpoint tồn tại để kết nối thực tế với mạng có thể được trừu tượng hóa khỏi ứng dụng. Điều này giúp duy trì tính di động để một dịch vụ có thể sử dụng các loại network drivers khác nhau mà không cần quan tâm đến cách kết nối với mạng đó.
- ***Network*** - CNM không chỉ định Network theo mô hình OSI. Việc triển khai Network có thể là Linux bridge, VLAN,... Network là tập hợp các endpoint có kết nối giữa chúng. Các endpoint không được kết nối với mạng không có kết nối trên mạng.

## CNM Driver Interfaces

Container Networking Model cung cấp 2 pluggable và open interfaces có thể được sử dụng bởi người dùng, cộng đồng và nhà cung cấp để tận dụng chức năng, khả năng hiển thị hoặc kiểm soát bổ sung trong mạng.

Các network drivers tồn tại:
-
- 

## Network Scope

Sử dụng `docker network ls`, Docker network drivers có một khái niệm về *scope*. network scope là domain của driver có thể là `local` hoặc `swarm` scope. Local scope drivers cung cấp kết nối và network services (như DNS hoặc IPAM) trong phạm vi của host. Swarm scope drivers cung cấp kết nối và network services trên một cụm swarm. Swarm scope networks có cùng network ID trên toàn bộ cụm trong khi local scope networks có một network ID duy nhất trên mỗi host.

## Docker Remote Network Drivers

Cộng đồng và vendor tạo ra remote network drivers tương thích với CNM. Mỗi cung cấp khả năng độc đáo và network services cho container.

|Driver|Description|
|------|-----------|
|||
|||
|||

## Docker Remote IPAM Drivers

Cộng đồng và vendor tạo ra  IPAM drivers cũng có thể được sử dụng để cung cấp tích hợp với các hệ thống hiện có hoặc các khả năng đặc biệt.

|Driver|Description|
|------|-----------|
|||

Có rất nhiều Docker plugins tồn tại và đang được tạo ra nhiều hơn nữa mọi lúc. Docker duy trì một danh sách các [plugin phổ biến nhất](https://docs.docker.com/engine/extend/legacy_plugins/).

## Nguyên tắc cơ bản của Linux Network

Linux kernel có tính năng triển khai TCP/IP stack cực kỳ hoàn thiện và hiệu quả (ngoài các native kernel features khác như VXLAN và packet filtering). Docker networking sử dụng kernel's networking stack làm cơ sở để tạo network drivers cấp cao hơn. Nói một cách đơn giản, Docker networking là Linux networking.

Việc triển khai các tính năng Linux kernel hiện có đảm bảo hiệu năng cao và mạnh mẽ. Quan trọng nhất, nó cung cấp tính di động trên nhiều bản phân phối và sersion, giúp tăng cường tính di động của ứng dụng.

Có một số Linux networking xây dựng blocks sử dụng để triển khai native CNM network drivers. Danh sách này bao gồm ***Linux bridges, network namespaces, veth pairs, và iptables*** . Sự kết hợp của các công cụ này, được triển khai như network drivers, cung cấp các quy tắc chuyển tiếp, phân đoạn mạng và các công cụ quản lý cho chính sách dynamic network.

## External Access for Docker Services

Swarm & UCP cung cấp quyền truy cập vào các service từ cluster port publishing bên ngoài. Vào và ra cho các service không phụ thuộc vào gateways, nhưng phân phối vào/ra trên host nơi service cụ thể đang chạy. Có hai chế độ publishing port cho service, `host` mode và `ingress` mode.

### Ingress Mode Service Publishing

`ingress` mode port publishing sử dụng `Swarm Routing Mesh` để áp dụng `load balancing` trên các tasks trong 1 service. Ingress mode publishes exposed port trên mỗi UCP/Swarm node. Lưu lượng truy cập vào published port được cân bằng tải bởi Routing Mesh và được điều hướng thông qua round robin load balancing tời 1 trong các healthy tasks của service. Ngay cả khi một host nhất định không chạy service task, port được published trên host và được load balanced với máy chủ có task. Khi Swarm báo hiệu 1 task stop, mục nhập loadbalancer của nó bị tắt để nó dừng nhận lưu lượng truy cập mới.
```sh
$ docker service create --replicas 2 --publish mode=ingress,target=80,published=8080 nginx
```
***`mode=ingress` là chế độ mặc định cho service. Lệnh này cũng có thể được viết ngắn gọn như sau: `-p 80: 8080`. Port `8080` expose trên mỗi host trên cụm cluster và load balanced với 2 container trong service này.***

### Host Mode Service Publishing

`host` mode port publishing chỉ exposes ports trên host nơi các service tasks cụ thể đang chạy. Port được ánh xạ trực tiếp đến container trên host đó. Để ngăn va chạm port, chỉ 1 task duy nhất của 1 service nhất định có thể chạy trên mỗi host.
```sh
$ docker service create --replicas 2 --publish mode=host,target=80,published=8080 nginx
```
`host` mode yêu cầu `mode=host` flag. Nó publishes port `8080` locally trên các hosts nơi 2 container này đang chạy. Nó không áp dụng load balancing, vì vậy lưu lượng truy cập đến các node đó chỉ được hướng đến local container. Điều này có thể gây ra xung đột port nếu không có đủ host với port được published cho số lượng replicas.

### Ingress Design

Có nhiều good use-cases cho publishing mode. `ingress` mode hoạt động tốt cho các service có nhiều replica và yêu cầu load balancing giữa các replicas đó. `host` mode hoạt động tốt nếu external service discovery được cung cấp bởi một tool khác. Một trường hợp sử dụng tốt khác cho `host` mode là cho các  global containers tồn tại một trên mỗi host. Các container này có thể tiết lộ thông tin cụ thể về local host (như monitoring hoặc logging) chỉ liên quan đến host đó và do đó bạn không muốn load balance khi truy cập service đó.

<img src=https://i.imgur.com/IThw3C9.png>

## 31. MACVLAN

## Multi-Host Bridge Driver with External Service Discovery

Vì bridge driver là local scope driver, multi-host networking yêu cầu 1 multi-host service discovery (SD). SD bên ngoài đăng ký location và status của một container hoặc service và sau đó cho phép các service khác khám phá vị trí đó. Vì bridge driver exposes ports để truy cập bên ngoài, SD bên ngoài lưu trữ host-ip:port như là vị trí của một container nhất định.

Trong ví dụ sau, vị trí của mỗi dịch vụ được cấu hình thủ công, mô phỏng external service discovery. Vị trí của dịch vụ `db` được truyền tới `web` thông qua biến môi trường `DB`.
```sh
#Create the backend db service and expose it on port 8500
host-B $ docker run -d -p 8500:8500 --name db consul

#Display the host IP of host-B
host-B $ ip add show eth0 | grep inet
    inet 172.31.21.237/20 brd 172.31.31.255 scope global eth0
    inet6 fe80::4db:c8ff:fea0:b129/64 scope link

#Create the frontend web service and expose it on port 8000 of host-B
host-B $ docker run -d -p 8000:5000 -e 'DB=172.31.21.237:8500' --name web chrch/docker-pets:1.0
```
Dịch vụ `web` hiện đang phục vụ trang `web` trên port `8000` của địa chỉ IP `host-B`.

<img src=https://i.imgur.com/yATOceR.png>

## Tài liệu tham khảo
- https://success.docker.com/article/networking
