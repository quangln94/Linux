# Pods
## Pod là gì

Trong Kubernetes, đơn vị nhỏ nhất là Pod. Triển khai các ứng dụng trên Kubernetes có nghĩa là đóng gói chúng trong Pods.

Pod chia sẻ resource cho mỗi container bao gồm: IP addresses, ports, hostname, sockets,	memory,	volumes...

System resources là các kernel namespaces bao gồm:
- Network	namespace:	IP	address,	port	range,	routing	table…
- UTS	namespace:	Hostname
- IPC	namespace:	Unix	domain	sockets…

<img src=https://i.imgur.com/ngmh7k1.png>

Giáo tiếp giữa các Pods

<img src=https://i.imgur.com/kXWJypr.png>

Control	Groups (cgroups) ngăn các container tiêu thụ tất cả CPU, RAM và IOPS có sẵn trên 1 node. Chúng tôi có thể nói rằng các nhóm tích cực sử dụng tài nguyên cảnh sát.

Tất cả containers trong 1 Pod	sẽ được lên lịch trên cùng 1 node.

## Pod lifecycle

Pod lifecycle	được xác định trong YAML manifest	file và POST manifest	tới API	server.	Nội dung của manifest được duy trì trong cluster store như 1 bản ghi của desired state và Pod được lên lịch trên healthy node với đủ resources.	Khi được lên lịch trên 1 node, trạng thái của nó là pending	trong khi chờ node downloads images và starts	containers.	Khi mọi thứ đã sẵn sàng	Pod	chuyển sang trạng thái running. Sau đó chuyển sang trạng thái succeeded khi nó hoàn thành các tasks.

Trương họp Pod không thể start, trạng thái của nó là pending hoặc failed.

<img src=https://i.imgur.com/5zISriI.png>

Pods được deployed thông qua manifest files, không có replicated và self-healing capabilities. Do đó thường deploy Pods thông qua Deployments	và DaemonSets để có thể reschedule khi Pods	fail.

## Pod manifest	files

Cùng xem Pod manifest file. ***It’s available in the book’s GitHub repo	under the pods folder called pod.yml***
```sh
apiVersion: v1
kind: Pod
metadata:
  name: hello-pod
  labels:
   zone:prod 
   version:v1
spec:
  containers:
  - name: hello-ctr
    image:nigelpoulton/k8sbook:latest
    ports:
    - containerPort: 8080
```
Chúng ta có thể thấy 4 top-level resources:
- apiVersion
- kind
- metadata
- spec

Trường `.apiVersion` cho biết: API group và API	version được dùng đề tạo object. Format chung là <api-group>/<version>.	Tuy nhiên	Pods được xác định trong 1 special API group được gọi là core group mà bỏ qua phần `api-group`. Ví dụ StorageClass objects được xác định trong v1 của storage.k8s.io API group và được mô tả trong YAML files `storage.k8s.io/v1`. Tuy nhiên Pods trong core API group đặc biệt vì nó bỏ qua API group name, vì vậy chúng được mô tả trong YAML files v1.

Một resource có thể được xác định trong nhiều versions của 1 API group. Ví dụ: some-api-group/v1 và some-api-group/v2. Trong trường hợp này, định nghĩa trong group này có thể bao gồm các tính năng bổ xung và and khả năng mở rộng resource. 

Trường `.kind` nói cho Kubernetes loại object được deployed.

Phần `.metadata` là nơi attach name và labels. Giúp xác đinh object trong cluster, và labels tạo kết nối couplings. Cũng có thể xác định namespace mà object deployed. Namespaces cho phép phân chia clusters để quản lý. Nếu không chỉ định namespace nó sẽ dùng mặc định.

Phần `.spec` xác định containers chạy trong Pod. Ví dụ trên deploying 1 Pod với 1 container `nigelpoulton/k8sbook:latest image`. Nó được gọi là container `hello-ctr` và exposing trên port `8080`.

## Deploying Pods từ manifest file

Để deploy 1 Pod	tới Kubernetes cluster, ta xác định nó trong file manifest và POST tới API server. Control plane kiểm tra nó, ghi nó vào cluster store và scheduler triển khai nó đến 1 node healthy với đủ resources. Quá trình này giống nhau với single-container Pods và multi-container Pods.

<img src=https://i.imgur.com/AsddeoF.png>

Dùng lệnh `kubectl` để POST manifest tới API server.
```sh
$ kubectl apply	-f pod.yml
pod/hello-pod created
```
Dùng lệnh `kubectl get pods` để check trạng thái.
```sh
$ kubectl get pods
NAME		READY	STATUS			RESTARTS	AGE
hello-pod	0/1	ContainerCreating	0		9s
```
Thêm `--watch` flag vào lệnh `kubectl get pods` để xem khi trạng thái thay đổi.

Được monitored local bằng `kubelet` process. `kubelet` process là Kubernetes agent chạy trên node.

Flag `-o wide`	thêm 1 vài cột nhưng vẫn là 1 dòng 

Flag `-o yaml` trả về manifest từ cluster store. Output được chia thành 2 phần:
- desired state	(.spec)
- current observed state (.status)

Lệnh `kubectl describe` cung cấp formatted multi-line overview của 1 object. Nó cũng bao gồm 1 số object quan trọng và lifecycle	events.

Lệnh `kubectl exec` để login và execute	1 Pod.
