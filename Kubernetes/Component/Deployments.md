# Kubernetes Deployments

Pods không thực hiện việc self-heal, scale, updates	hoặc rollbacks. Deployments sẽ làm công việc này.

Deployment chỉ có thể quản lý 1 loại Pod duy nhất. Tuy nhiên, 1	Deployment có thể manage nhiều replicas của của cùng 1 Pod

Deployments	là objects chính trong Kubernetes	API. Chúng được xác định trong file manifest khi ta POST lên API	server

Deployments sử dụng 1 object khác được gọi là ReplicaSet. Nó sử dụng ReplicaSets để cung cấp self-healing và scalability 

<img src=https://i.imgur.com/wiak285.png>

## Self-healing	và scalability

Pods	are	great. Thêm các container bằng cách chia sẻ location, volumes, memory, networking... Nhưng không cung cấp khả năng self-healing và scalability nếu Pod fails hoặc node bị lỗi, Pod sẽ không được restarted.

## Desired state
- Desired	state: Desired	state	là những gì bạn cần.
- Current	state: trạng thái đang có
- Declarative	model: declarative model là cách để Kubernetes	biết trạng thái mong muốn của bạn là gì mà không cần đi vào chi tiết cách triển khai nó.

Có 2 competing models:
- Declarative model: Mô hình khai báo là tất cả về mô tả về những gì bạn muốn. 
- Imperative model: Mô hình bắt buộc là danh sách những việc cần làm để đạt Declarative model.

## Rolling	updates	với	Deployments

Khi thiết kế applications	với mỗi service như 1 Pod. Để self-healing,	scaling, rolling updates... Ta bọc Pods trong Deployments. Có nghĩa là tạo 1 file configuration YAML với các mô tả sau: 
- Có bao nhiểu Pod	replicas
- Image nào được sử dụng cho containers của Pod
- Network	ports	nào được sử dụng
- Chi tiết về cách thực hiện rolling updates

Bạn POST file YAML tới API	server và Kubernetes làm phần còn lại. Khi mợi thứ up và running,	Kubernetes sets	up các vòng lặp để chắc chắn trạng thái quan sát khớp với desired	state.

**Điều gì thực sự xảy ra**

Khi có lỗi sảy ra và cần phải deploy 1 bản updated để fix. Bạn phải update Deployment YAML file với image	version mới và re-POST nó tới API	server.	Nó sẽ đăng ký 1 desired	state	mới trên cluster với cùng số Pods nhưng tất cả đều chạy với version mới. Để làm được điều này Kubernetes tạo ra 1 ReplicaSet mới cho Pods với image mới. Giờ ta có 2 ReplicaSets:	original cho Pods với image cũ và Pods khác với image mới. Khi Kubernetes tăng số lượng Pods trong ReplicaSet mới, nó giảm số lượng Pods trong ReplicaSet cũ.	Kết quả chúng ta nhận được 1 smooth	rolling	update với zero downtime. Và ta có thể rinse và repeat quá trình cho future	updates	–	chỉ cẩn tiếp tục updating	file manifest (được lưu trong 1	version	control	system)

<img src=https://i.imgur.com/YFk5h9D.png>

## Rollbacks

Rollbacks là quá trình ngược lại với rolling updates

ReplicaSets cũ không quản lý Pods nào nữa nhưng vẫn tồn tại với cấu hình cũ. Và ta có thể reverting về versions cũx. 

<img src=https://i.imgur.com/WS0cN70.png>

## Cách tạo 1 Deployment

