# Namespace
- Kubernetes hỗ trợ multiple virtual clusters được gọi là namespaces. Cho phép nhóm các objects để có thể filter và control
- Sử dụng trong môi trường với nhiều users trên nhiều nhóm hoặc projects.
- Phân chia resources giữa nhiều người dùng (thông qua resource quota).

Show namespaces cluster sử dụng :
```sh
[root@server01 ~]# kubectl get namespace
NAME              STATUS   AGE
default           Active   23h
kube-public       Active   23h
kube-system       Active   23h
```
Kubernetes starts với 3 namespaces: 
- default: cho objects không có namespace
- kube-system: cho objects được tạo bởi Kubernetes system
- kube-public: được tạo tự động và có thể được đọc bới tất cả users (kể cả không được xác thực). This namespace is mostly reserved for cluster usage, in case that some resources should be visible and readable publicly throughout the whole cluster. The public aspect of this namespace is only a convention, not a requirement.

**Setting namespace**

Để set namespace cho 1 request hiện tại sử dụng flag `--namespace`.
```sh
kubectl run nginx --image=nginx --namespace=<insert-namespace-name-here>
kubectl get pods --namespace=<insert-namespace-name-here>
```
Có thể thay đổi namespace mặc định cho tất cả  các lệnh `kubectl` tiếp theo:
```sh
kubectl config set-context --current --namespace=<insert-namespace-name-here>
# Validate it
kubectl config view --minify | grep namespace:
```
## Không phải tất cả Objects đều nằm trong 1 Namespace

Hầu hết Kubernetes resources (pods, services, replication controllers, others) đều nằm trong 1 số namespaces. Tuy nhiên có resources không thuộc namespace nào.
```sh
# In a namespace
kubectl api-resources --namespaced=true
# Not in a namespace
kubectl api-resources --namespaced=false
```
## Namespaces và DNS

Khi tạo 1 Service sẽ có 1 DNS tương ứng có dạng: `<service-name>.<namespace-name>.svc.cluster.local`, có nghĩa là nếu 1 container chỉ sử dụng `<service-name>`, nó sẽ phân giải service local thành 1 namespace. Nó hữu ích cho việc sử dụng cùng 1 cấu hình trên nhiều namespaces như Development, Staging và Production. Nếu muốn tiếp cận namespaces, cần sử dụng fully qualified domain name (FQDN).

## Tài liệu tham khảo
- https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/
- https://rancher.com/blog/2019/2019-01-28-introduction-to-kubernetes-namespaces/
