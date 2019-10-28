# Kubernetes Deployments

Pods không thực hiện việc self-heal, scale, updates	hoặc rollbacks. Deployments sẽ làm công việc này.

Deployment chỉ có thể quản lý 1 loại Pod duy nhất. Tuy nhiên, 1	Deployment có thể manage nhiều replicas của của cùng 1 

Deployments	là objects chính trong Kubernetes	API. Chúnng được xác đính trong file manifest	khi ta POST	lên API	server

Deployments tận dụng 1 object khác được gọi là ReplicaSet. Nó sử dụng ReplicaSets để cung cấp self-healing và scalability 

<img src=https://i.imgur.com/wiak285.png>

Hãy nghĩ về việc Deployments quản lý ReplicaSets và ReplicaSets	quản lý Pods.	Đặt chúng cạnh nhau và chúng ta có 1 cách tốt để deploy và manage	applications trên Kubernetes.

## Self-healing	and	scalability

Pods	are	great. Thêm các container bằng cách chia sẻ location, volumes, memory, networking... Nhưng không cung cấp khả năng self-healing và scalability nếu Pod fails hoặc node bị lỗi, Pod sẽ không được restarted.

## Desired state
- Desired	state: Desired	state	là những gì bạn cần.
- Current	state: trạng thái đang có
- Declarative	model: declarative model là cachs để Kubernetes	biết trạng thái mong muốn của bạn là gì mà không cần đi vào chi tiết cách triển khai nó.

Có 2 competing models:
- Declarative model: Mô hình khai báo là tất cả về mô tả về những gì bạn muốn. 
- Imperative model: Mô hình bắt buộc là danh sách những việc cần làm để đạt Declarative model.

## Rolling	updates	with	Deployments

Khi thiết kế applications	với mỗi service như 1 Pod. Để self-healing,	scaling, rolling updates... Ta bọc Pods trong Deployments. Có nghĩa là tạo 1 file configuration YAML với các mô tả sau: 
- Có bao nhiểu Pod	replicas
- Image nào được sử dụng cho containers của Pod
- Network	ports	nào được sử dụng
- Chi tiết về cách thực hiện rolling updates

Bạn POST file YAML tới API	server và Kubernetes làm phần còn lại. Khi mợi thứ up và running,	Kubernetes sets	up các vòng lặp để chắc chắn trạng thái quan sát khớp với desired	state.

**Điều gì thực sự xảy ra**

Khi có lỗi sảy ra và cần phải deploy 1 updated để fix. Để làm được việc này, bạn phải update Deployment YAML file với new	image	version, và re-POST	nó tới API	server.	Nó sẽ đăng ký 1 desired	state	mới trên cluster với cùng số Pods nhưng tất cả đều chạy với new	version. Để làm được điều này Kubernetes tạo ra 1 ReplicaSet mới cho Pods với image mới. Giờ ta có 2 ReplicaSets:	–	the	original	one	for	the	Pods	with	the	old	version	of	the	image,	and
another	for	the	Pods	with	the	new	version.	As	Kubernetes	increases	the	number
of	Pods	in	the	new	ReplicaSet	(with	the	new	version	of	the	image)	it	decreases
the	number	of	Pods	in	the	old	ReplicaSet	(with	the	old	version	of	the	image).	Net
result,	we	get	a	smooth	rolling	update	with	zero	downtime.	And	we	can	rinse	and
repeat	the	process	for	future	updates	–	just	keep	updating	that	manifest	file
(which	should	be	stored	in	a	version	control	system)
