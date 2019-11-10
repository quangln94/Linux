# etcd
## etcd là gi
- K8s chạy trên nhiều host cùng 1 lúc nên cần 1 distributed database để dễ dàng lưu trữ data trên cluster.
- Kubernetes sử dụng etcd như 1 key-value database store. Nó lưu cấu hình cluster bên trongn etcd nên hãy đảm bảo việc back up cho nó.
- Sử dụng chức năng watch để giám sát các thay đổi. Nếu bị chia rẽ, k8s thực hiện thay đổi để điều chỉnh trạng thái hiên tại và trạng thái mong muốn.
- Lưu trữ output của `kubectl get`, Node crashing, process dying hoặc `kubectl create` cũng làm values trong etcd thay đổi.
- Tập hợp các process tạo nên Kubernetes sử dụng etcd để lưu trữ dữ liệu và thông báo cho nhau về các thay đổi.
- etcd sử dụng thuật toán đồng thuận [Raft](http://thesecretlivesofdata.com/raft/)

## Etcd trong Kubernetes

Trong ví dụ này `etcd` được deployed như Pods trên masters.

<img src=https://i.imgur.com/sihMtB7.png>

Để tăng security và khả năng phục hồi nó cũng có thể được triển khai như một external cluster.

<img src=https://i.imgur.com/qi2JPT5.png>

Đưới đây lag ví dụn minh họa API Server tương tác với `ectd`.

<img src=https://i.imgur.com/gfn5sNr.png>

## The Etcd Pod
List tất cả các Pods chạy trong cluster
```sh
[root@server01 ~]# kubectl get pods --all-namespaces
NAMESPACE     NAME                                   READY   STATUS    RESTARTS   AGE
kube-system   coredns-5644d7b6d9-ngkcf               1/1     Running   0          2d22h
kube-system   coredns-5644d7b6d9-thpz9               1/1     Running   0          2d22h
kube-system   etcd-server01                          1/1     Running   0          2d22h
kube-system   kube-apiserver-server01                1/1     Running   0          2d22h
kube-system   kube-controller-manager-server01       1/1     Running   0          2d22h
kube-system   kube-flannel-ds-amd64-4jp5w            1/1     Running   0          2d22h
kube-system   kube-flannel-ds-amd64-flqxh            1/1     Running   0          2d22h
kube-system   kube-flannel-ds-amd64-xw4hg            1/1     Running   0          2d22h
kube-system   kube-proxy-9lpxc                       1/1     Running   0          2d22h
kube-system   kube-proxy-hqs7j                       1/1     Running   0          2d22h
kube-system   kube-proxy-l788n                       1/1     Running   0          2d22h
kube-system   kube-scheduler-server01                1/1     Running   0          2d22h
```
Chúng ta quan tâm đến Pods `etcd-server01`









## Tài liệu tham khảo
- https://matthewpalmer.net/kubernetes-app-developer/articles/how-does-kubernetes-use-etcd.html
