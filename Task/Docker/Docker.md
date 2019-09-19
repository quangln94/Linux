## Part 1: The picture of the stuff

1 ứng dụng trên 1 server

Linux đã không thể có công nghệ an toàn hay bảo mật để chạy nhiều ứng dụng trên cùng 1 server.

Khi cần 1 ứng dụng mới, thông thường phải mua thêm server

Để giải quyết vấn đề này VMware ra đời

Nhăm tối ưu về phần cứng như OS, RAM, DISK, CPU Containers ra đời

=> Linux containers

Docker, Inc. made containers simple!

Một số công nghệ phát triển containers gần đây như: kernel namespaces, control groups, union filesystems và Docker. 

Docker Engine là phần mềm dùng để tạo ra Docker image và chạy Docker container.

Windows containers: This way developers and sysadmins familiar with the Docker toolset from the Linux platform will feel at home using 

Windows containers.

Windows containers vs Linux containers

What about Kubernetes

Kubernetes is an open-source project out of Google that has quickly emerged as the leading orchestrator of containerized apps
Kubernetes uses Docker as its default container runtime the piece of Kubernetes that starts and stops containers, as well as pulls images etc. 

Kubernetes là một phần mềm giúp chúng ta triển khai các ứng dụng được đóng gói và giữ cho chúng chạy.

Kubernetes sử dụng Docker như là container runtime mặc định, Kubernetes có thể starts và stops containers, cũng như kéo images... However, Kubernetes has a pluggable container runtime interface called the CRI. This makes it easy to swap-out Docker for a different container runtime.

Kubernetes là 1 nền tảng cao cấp hơn Docker

2: Docker


