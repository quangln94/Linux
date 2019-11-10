# etcd
## etcd là gi
- K8s chạy trên nhiều host cùng 1 lúc nên cần 1 distributed database để dễ dàng lưu trữ data trên cluster.
- Kubernetes sử dụng etcd như 1 key-value database store. Nó lưu cấu hình cluster bên trongn etcd nên hãy đảm bảo việc back up cho nó.
- Sử dụng chức năng watch để giám sát các thay đổi. Nếu bị chia rẽ, k8s thực hiện thay đổi để điều chỉnh trạng thái hiên tại và trạng thái mong muốn.
- Lưu trữ output của `kubectl get`, Node crashing, process dying hoặc `kubectl create` cũng làm values trong etcd thay đổi.
- Tập hợp các process tạo nên Kubernetes sử dụng etcd để lưu trữ dữ liệu và thông báo cho nhau về các thay đổi.








## Tài liệu tham khảo
- https://matthewpalmer.net/kubernetes-app-developer/articles/how-does-kubernetes-use-etcd.html
