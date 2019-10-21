# A minimal IPVS Load Balancer demo
Trong cụm cluster, bạn có thể sử dụng K8s ingress controller để định tuyến lưu lượng truy cập đến apps và services cụ thể bằng các quy tắc định tuyến L7 phức tạp (như Host headers, cookies-stickiness, etc..). Tuy nhiên, điều này vẫn có nghĩa là các kết nối TCP có thể bị ngắt tại 1 node trong cụm cluster nếu bạn có DNS được setup theo cách đó. Sau đó, việc thêm L4 IP load balancer bên ngoài cụm K8s để cân bằng lưu lượng giữa tất cả các node chạy ingress controller là cần thiết.

<img src=https://i.imgur.com/vNMa3lq.png>

## Tài liệu tham khảo
- https://medium.com/@benmeier_/a-quick-minimal-ipvs-load-balancer-demo-d5cc42d0deb4
