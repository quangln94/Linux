# Kubernetes ingress là gì
Kubernetes ingress là tập hợp các rule quản lý cách user bên ngoài truy cập services trong k8s. 

## 1. Ingress trong Kubernetes

Trong k8s , có 3 cách để expose ứng dụng
- Sử dụng type `NodePort` để exposes ứng dụng trên 1 port của mỗi Nodes
- Sử dụng type `LoadBalancer`, tạo 1 load balancer bên ngoài trỏ đến service trong k8s
- Sử dụng 1 Kubernetes Ingress Resource

### 1.1 NodePort

NodePort là Port mở trên mỗi Node của cluster.

NodePort thường được gán trong khoảng 30000–32767. While this is likely not a problem for most TCP or UDP clients, HTTP or HTTPS traffic end up being exposed on a non-standard port.

## 1.2 Load Balancer

LoadBalancer tự động deploys 1 external load balancer liên kết với IP cụ thể và định tuyến các traffic bên ngoài đến service trong k8s.

Việc triển khai LoadBalancer phụ thuộc vào Cloud provider, và không phải tất cả Cloud providers đều hỗ trợ LoadBalancer service type. Nếu tự triển khải bạn sẽ phải tự triển khai load balancer của riêng bạn.

## 1.3 Ingress Controllers và Ingress Resources

Ingress cho phép host hoặc URL dựa trên định tuyến HTTP routing. Ingress controller chịu trách nhiệm cho việc đọc thông tin Ingress Resource và xử lý dữ liệu cho phù hợp.

Lưu ý rằng Ingress controller thường không loại bỏ sự cần thiết của 1 external load balancer, Ingress controller chỉ thêm 1 lớp định tuyến và điều khiển bổ sung sau load balancer.

## Tài liệu tham khảo
- https://blog.getambassador.io/kubernetes-ingress-nodeport-load-balancers-and-ingress-controllers-6e29f1c44f2d


