# Kubernetes Networking

## 1. Pod Networking
Mỗi Pod có 1 IP, tất cả containers trong Pod chia sẻ địa chỉ IP này và giao tiếp với nhau qua lo loopback interface sử dụng localhost hostname. Điều này được thực hiện bằng cách gán tất cả containers vào cùng network stack.

## 2. Giao tiếp giữa các Pod
### 2.1 Giao tiếp giữa các Pod trên 1 Node

<img src=https://i.imgur.com/rNqXQUf.png>

Mỗi Node có 1 network interface – eth0 in được gắn vào Kubernetes cluster network. 














## Tài liệu tham khảo
- https://www.digitalocean.com/community/tutorials/kubernetes-networking-under-the-hood
- https://www.digitalocean.com/community/tutorials/how-to-inspect-kubernetes-networking
- https://matthewpalmer.net/kubernetes-app-developer/articles/kubernetes-networking-guide-beginners.html
