# Kubernetes Services

Cơ bản về Kubernetes Services.
- Service REST trong Kubernetes API. Giống như Pod, ReplicaSet, hoặc Deployment, 1 Kubernetes Service là 1 object trong API có thế xác định trong manifest và POST tới API server.
- Mỗi Service đều có IP, DNS name và port của riêng nó.
- Services sử dụng labels để tự động chọn Pods trong cluster chúng sẽ gửi traffic tới.

***Vậy cái gì cho phép Services cung cấp networking tới 1 Pods động.***

Pods và Services được ghép thông qua labels và label selectors. Đây là cùng một công nghệ triển khai vào Pods và là chìa khóa cho tính linh hoạt được cunng cấp bởi Kubernetes. 

Hình dưới có 3 Pods có nhãn `zone=prod` và `version=1` và Service có 1 label selector khớp.

<img src=https://i.imgur.com/nW7W16e.png>

Service cung cấp stable networking tới 3 Pods, có thể gửi requests tới Service và nó sẽ proxy chúng trên Pods. Nó cũng cung cấp load-balancing đơn giản.

Để Pod match 1 Service, nó phải có đủ labels mà Service tìm kiếm.

<img src=https://i.imgur.com/Cb4VxFN.png>

## Services và Endpoint objects

Khi Pods come-and-go (scaling up and down, failures, rolling updates etc.), Service tự động updates danh sách Pods healthy phù hợp thông qua việc kết hợp label selector và 1 construct được gọi là 1 Endpoint object.

Mỗi Service được tạo tự động nhận 1 associated Endpoint object. Tất cả Endpoint object là 1 danh sách tự động của healthy Pods trên cluster khớp với Service’s label selector.

**Cách hoạt động** 

K8s liên tục đánh giá Service’s label selector dựa trên danh sách healthy Pods hiện tại trên cluster. Bất kỳ Pods mới khớp với selector được thêm vào Endpoint object và Pods không còn sẽ bị xóa. Có nghĩa là Endpoint luôn luôn up-to-date. Sau đó khi 1 Service gửi traffic tới Pods, nó truy vấn Endpoint object của nó đế biết danh sách healthy Pods khớp mới nhất.

Endpoint object có API endpoint riêng mà Kubernetes-native apps có thể truy vấn cho danh sách matching Pods mới nhất. Các apps sau đó có thể gửi traffic thẳng tới Pods. Non-native Kubernetes apps không thể truy vẫn Endpoints object, gửi traffic tới Service’s stable IP (VIP).

**Truy cập Services từ bên trong cluster** 

Kubernetes supports 1 số loại Service. Mặc định là ClusterIP.

1 ClusterIP Service có 1 IP stable và port chỉ có thể truy cập từ bên trong cluster là ClusterIP và nó được lập trình vào trong network fabric và được đảm bảo ổn đinhh cho vòng đời của Service.

ClusterIP được đăng ký với tên của Service trong cluster’s native DNS service. Tất cả Pods trong cluster được lập trình sẵn để biết  về cluster’s DNS service, có nghĩa là tất cả Pods đều có thể phân giải Service names.

**Truy cập Services từ bên ngoài cluster**

Kubernetes có 1 loại Service được gọi là NodePort	Service. Nó được builds on top of ClusterIP	và cho phép truy cập từ bên ngoài cluster.

khi tạo 1 Service và sử dụng labels	để liên kết với Pods.	Service	object có  reliable	NodePort được map với mỗi node trong cluster, giá trị NodePort giống nhau trên mỗi node. Có nghĩa là traffic từ bên ngoài cluster có thể vào bất kỳ node nào trong cluster trên NodePort và tới ứng dụng (Pods).

<img src=https://i.imgur.com/ok2h273.png>

Hình thể hiện 1 NodePort Service có 3 Pods exposed port	30050	trên mỗi node	trong cluster:
- Client truy câp vào Node 2 qua port 30050.
- Nó chuyển hướng tới Service	object (Node 2 không chạy Pod	từ Service).
- Service	có 1 liên kết tới Endpoint object và luôn up-to-date	danh sách Pods matching	với label	selector.
- Client truy cập pod1 trên Node 1.

Các request có thể điều hướng client tới pod2	hoặc pod3 hoặc Pod khác thông qua load-balancing.

Có nhiều loại Srvices như LoadBalancer Services.	These
integrate	with	load-balancers	from	your	cloud	provider	such	as	AWS,	Azure,	and

## Service discovery

Kubernetes thực hiện Service discovery theo 1 số cách: 
- DNS	(preferred)
- Environment variables	(definitely	not	preferred)

DNS	add-on liên tục theo dõi API server cho Services mới và tự động đăng ký chúng trong DNS. Có nghĩa là mỗi Service lấy 1 DNS name	để có thể phân giải trên toàng bộ cluster.

Một hình thức thay khác là thông qua biến môi trường. Mỗi Pod	nhận được 1 tập hợp biến môi trường để phân giải mọi Service hiện có trong cluster.	Tuy nhiên đây chỉ là trường hợp dự phòng cho việc không sử dụng DNS	trong cluster của bạn. Nhược điểm của biến môi trường là chúng chỉ được chèn vào Pod khi Pod được tạo lúc đầu. Pods không có cách nào tìm hiểu về Service mới được thêm vào cluster sau khi Pod được tạo.

