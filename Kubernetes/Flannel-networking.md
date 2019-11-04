# Flannel networking
Flannel là giải pháp software defined network được tạo bởi CoreOS cho Kubernetes networking.

<img src=https://i.imgur.com/oOnWTdf.png>

Có 3 networks trong cluster:
- 3 Node có thể giáo tiếp với nhau vì cùng trong 1 LAN có subnet 172.20.32.0/19.
- Flannel tạo ra network 100.96.0.0/16 và gán network 100.96.x.0/24 cho mỗi Pods trong Node.
- `docker0` sẽ sử dụng network 100.96.x.0/24 để tạo containers mới.
- Containers trong cùng host có thể giáo tiếp với nhau qua `docker0`.
- Để giao tiếp giữa các Node flannel sử dụng kernel route table và UDP encapsulation để thực hiện.


## Tài liệu tham khảo
- https://blog.laputa.io/kubernetes-flannel-networking-6a1cb1f8ec7c
