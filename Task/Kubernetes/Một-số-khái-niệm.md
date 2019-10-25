# Một số khái niệm trong k8s
## Pod
Trong VMware, atomic unit	máy ảo (VM). Trong Docker là container. Trong Kubernetes là Pod 

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

Deployments tồn tại trọng Kubernetes từ version	1.2	 và được nâng cấp lên GA (stable) trong version 1.9.Nó được thếm các tính năng như scaling,	zero-downtime updates, và versioned	rollbacks.

## Service

Services	cung cấp networking tin cậy cho Pods

Uploader microservice	nói chuyện với renderer microservice thông qua 1 Kubernetes	Service. Kubernetes	Service	cung cấp 1 Name và IP tin cậy và load-balancing	requests tới 2 renderer	Pods đằng sau nó.

<img src=https://i.imgur.com/dInsMc1.png>

## Kết nối Pod tới service

Services sử dụng labels và label selector để biết Pods nào có load-balance.	Service	có 1 label selector là 1 list	labels Pod phải cps để nhận traffic	từ Service.

Service	được cấu hình để gửi traffic tới tất cả Pods trên cluster. Cả 2 Pods trong hình đều có 3 labels nên Service	sẽ load-balance traffic	tới cả 2.

<img src=https://i.imgur.com/AEIzaml.png>

## 4. Packaging apps

Để một ứng dụng chạy trên Kubernetes cluster, nó cần: 
- Đóng gói như một container
- Được bọc trong một Pod
- Được triển khai thông qua manifest file

Chúng ta viết 1 application	service	với ngôn ngữ của mình sau đó build nó thành 1 container	image	và lưu nó trong 1 registry.	Tại đây application	service	được đóng gói.

Tiếp theo là xác định 1 Kubernetes Pod để chạy service được đóng gói. 1 Pod	cho phép containers	chạy trên Kubernetes cluster.	Khi xác định 1 Pod cho container,	chúng ta sẵn sàng cho việc deploy nó trên cluster.

Kubernetes cung cấp 1 số objects để deploying	và managing	Pods.	Phổ biến nhất là Deployment, cung cấp khả năng mở rộng, tự phục hồi,	rolling updates. Ta xác định chúng trong 1 file YAML chỉ định những thứ như image và số lượng replicas để deploy.

Hình thể hiện các application	code được đóng gói như 1 container,	chạy bên trong 1 Pod, được quản lý bởi 1 Deployment.

<img src=https://i.imgur.com/NkTOamz.png>

Khi mọi thứ được xác định trong Deployment YAML file, chúng ta POST nó vào cluster như trạng thái mong muốn của ứng dụng và để Kubernetes thực hiện nó.

## 5. Declarative model và desired state

Mô hình khai báo và khái niệm trạng thái mong muốn là trung tâm của Kubernetes. Mang chúng đi và Kubernetes vỡ vụn.

Trong Kubernetes, declarative model làm việc như sau:
- Khai báo trạng thái mong muốn của ứng dụng (microservice) trong manifest file
- POST nó lên Kubernetes API server
- Kubernetes lưu trữ chúng trong cluster store dưới dạng trạng thái mong muốn của ứng dụng
- Kubernetes triển khai trạng thái mong muốn trên cluster
- Kubernetes thực hiện các vòng lặp đồng hồ để đảm bảo trạng thái hiện tại của ứng dụng không khác trạng thái mong muốn

Manifest files viết trong YAML và chúng nói với Kubernetes cách chúng ta muốn 1 application trông như thế nào. Chúng ta gọi nó là desired state. Nó bao gồm những thứ như: image được sử dụng, có bao nhiều replicas, network ports nào để listen và cách perform updates.

Khi tạo ra manifest, ta POST nó lên API server. Cách phổ biến nhất để làm điều này là với tiện ích kubectl command-line. POSTs manifest này như 1 request tới control plane thường là port 443.

Khi yêu cầu được xác thực và ủy quyền, Kubernetes kiểm tra manifest, xác định controller nào sẽ gửi nó đến (ví dụ: Deployments controller) và ghi lại cấu hình trong cluster store như 1 phần của cluster’s overall desired state. Một khi điều này được thực hiện, công việc được lên lịch trên cluster. Bao gồm việc pull image, starting containers, building networks và starting the application’s processes.

Cuối cùng, Kubernetes sử dụng các background reconciliation loops theo dõi trạng thái của cluster. Nếu trạng thái hiện tại của cluster thay đổi khác với trạng thái mong muốn, Kubernetes sẽ thực hiện bất kỳ nhiệm vụ nào là cần thiết để giải quyết vấn đề.

<img src=https://i.imgur.com/kjpM4w1.png>

