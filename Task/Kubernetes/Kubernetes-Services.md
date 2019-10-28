# Kubernetes Services
Ba điều cơ bản về Kubernetes Services.
- Service REST trong Kubernetes API. Giống như 1 Pod, ReplicaSet, hoặc Deployment, 1 Kubernetes Service là 1 object trong API có thế xác định trong manifest và POST tới API server.
- Mỗi Service đều có IP, DNS name và port của riêng nó.
- Services sử dụng labels để tự động chọn Pods trong cluster chúng sẽ gửi traffic tới.

***Vậy cái gì cho phép Services cung cấp networking tới 1 Pods động.***

Pods và Services được ghép thông qua labels và label selectors. Đây là cùng một công nghệ triển khai vào Pods và là chìa khóa cho tính linh hoạt được cunng cấp bởi Kubernetes. 

Hình dưới có 3 Pods có nhãn `zone=prod` và `version=1` và Service có 1 label selector khớp.

<img src=https://i.imgur.com/nW7W16e.png>

Service cung cấp stable networking tới 3 Pods, có thể gửi requests tới Service và nó sẽ proxy chúng trên Pods. Nó cũng cung cấp load-balancing đơn giản.

Để Pod match 1 Service, nó phải có đủ labels mà Service tìm kiếm.

<img src=https://i.imgur.com/Cb4VxFN.png>

## Services and Endpoint objects

Khi Pods come-and-go (scaling up and down, failures, rolling updates etc.), Service tự động updates danh sachs Pods healthy phù hợp thông qua việc kết hợp label selector và 1 construct được gọi là 1 Endpoint object.

Mỗi Service được tạo tự động nhận 1 associated Endpoint object. Tất cả Endpoint object là 1 danh sách tự động của healthy Pods trên cluster khớp với Service’s label selector.

**Nó hoạt động như thế nào** 

Kubernetes liên tục đánh giá Service’s label selector dựa trên danh sách healthy Pods hiện tại trên cluster. Bất kỳ Pods mới khớp với selector được thêm vào Endpoint object và bất kỳ Pods biến mất sẽ bị xóa. Có nghĩa là Endpoint luôn luôn up-to-date. Sau đó khi 1 Service gửi traffic tới Pods, nó truy vấn Endpoint object của nó đế biết danh sách healthy Pods khớp mới nhất.

Endpoint object có API endpoint riêng mà Kubernetes-native apps có thể truy vấn cho danh sách matching Pods mới nhất. Các apps sau đó có thể gửi traffic thẳng tới Pods. Non-native Kubernetes apps không thể truy vẫn Endpoints object, gửi traffic tới Service’s stable IP (VIP).

**Truy cập Services từ bên trong cluster** 

Kubernetes supports 1 số loại Service. Mặc định là ClusterIP.

1 ClusterIP Service có 1 IP stable và port chỉ có thể truy cập từ bên trong cluster là ClusterIP và nó được programmed vào trong network fabric và được đảm bảo ổn đinhh cho vòng đời của Service.

ClusterIP gets được đăng ký với tên của Service trong cluster’s native DNS service. Tất cả Pods trong cluster được lập trình sẵn để biết  về cluster’s DNS service, có nghĩa là tất cả Pods đều có thể phân giải Service names.
