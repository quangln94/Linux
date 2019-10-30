# Pod

Trong VMware, atomic unit là	máy ảo (VM). Trong Docker là container. Trong Kubernetes là Pod 

<img src=https://i.imgur.com/Ws73Ex7.png>

K8s chạy các ứng dụng được đóng gói. Tuy nhiên không thể chạy 1 container trực tiếp trên Kubernetes cluster. Container phải luôn chạy bên trong Pods

Khi chạy nhiều containers trong 1 Pod, chúng chia sẻ môi trường: IPC namespace, memory, volumes, network stack...Ví dụ tất cả containers
trong cùng Pod sẽ chia sẻ IP (IP Pod).	
 
<img src=https://i.imgur.com/s6h8pcA.png>
 
Nếu có 2 containers	trong 1 Pod	muốn giao tiếp với nhau chúng có thể sử dụng Pod’s localhost interface

<img src=https://i.imgur.com/PNIiHXW.png>

## Scaling Pods

Pods là đơn vị lập lịch nhỏ nhất trong k8s. Khi cần mở rộng, bạn thêm hoặc xóa Pods. Không mở rộng bằng cách thêm nhiều container vào Pod hiện có. Pod nhiều container chỉ dành cho trường hợp trong đó có 2 container khác nhau, container cần chia sẻ tài nguyên. 

Cách scale `nginx`	front-end	của 1 app	sử dụng nhiều Pods làm đơn vị scaling

<img src=https://i.imgur.com/DdybfSI.png>

## Vòng đời của Pod

Pods được tạo ra, sống sau đó chết. Nếu chết đột ngột ta không thể đưa nó trở lại. Thay vào đó k8s starts	1 Pod mới thay thế có ID và IP mới.

## Deployments

Deployments có trong Kubernetes từ version	1.2 và được nâng cấp lên GA (stable) trong version 1.9. Nó được thêm các tính năng như scaling,	zero-downtime updates, và versioned	rollbacks.

## Service

Services	cung cấp networking tin cậy cho Pods

Uploader microservice	nói chuyện với renderer microservice thông qua 1 Kubernetes	Service. Kubernetes	Service	cung cấp 1 Name và IP tin cậy và load-balancing	requests tới 2 renderer	Pods đằng sau nó.

<img src=https://i.imgur.com/dInsMc1.png>

## Kết nối Pod tới service

Services sử dụng labels và label selector để biết Pods nào có load-balance.	Service	có 1 label selector là 1 list	labels Pod phải có để nhận traffic	từ Service.

Service	được cấu hình để gửi traffic tới tất cả Pods trên cluster. Cả 2 Pods trong hình đều có 3 labels nên Service	sẽ load-balance traffic	tới cả 2.

<img src=https://i.imgur.com/AEIzaml.png>

## Packaging apps

Để một ứng dụng chạy trên Kubernetes cluster, nó cần: 
- Đóng gói như một container
- Được bọc trong một Pod
- Được triển khai thông qua manifest file

1 application	service	được build thành 1 container	image	và lưu trong 1 registry.	Tại đây application	service	được đóng gói.

Tiếp theo là xác định 1 Kubernetes Pod để chạy service được đóng gói. 1 Pod	cho phép containers	chạy trên Kubernetes cluster.	Khi xác định 1 Pod cho container,	chúng ta sẵn sàng cho việc deploy nó trên cluster.

Kubernetes cung cấp 1 số objects để deploying	và managing	Pods.	Phổ biến nhất là Deployment, cung cấp khả năng mở rộng, tự phục hồi,	rolling updates. Ta xác định chúng trong 1 file YAML chỉ định những thứ như image và số lượng replicas để deploy.

Hình thể hiện các application	code được đóng gói như 1 container,	chạy bên trong 1 Pod, được quản lý bởi 1 Deployment.

<img src=https://i.imgur.com/NkTOamz.png>

Khi mọi thứ được xác định trong Deployment YAML file, chúng ta POST nó vào cluster như trạng thái mong muốn của ứng dụng và để Kubernetes thực hiện nó.
