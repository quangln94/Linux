## 1. Kubernetes	primer
Kubernetes là 1 orchestrator. Phần lớn nó	orchestrates	containerized cloud-native	apps. Tuy nhiên có những Projects cho phép nó phối hợp mọi thứ như VM	và functions (serverless	workloads). Tất cả điều này đang bổ sung cho Kubernetes là orchestrator thực tế cho cloud-native applications.

Một orchestrator là 1 back-end system	thực hiện việc deploys và manages	applications. Có nghĩa là nó giúp bạn deploy	application, scale up	and	down,	perform updates	and	rollbacks... Nếu nó là 1 orchestrator tốt,	nó hoạt động mà bạn không cần phải giám sát.

Một cloud-native	application	là 1 business	application	được làm từ  1 nhóm các services nhỏ độc lập giáo tiếp và hình thành 1 application hữu ích. Thiết kế này cho phép nó đối phó với cloud-like	demands	và run	natively	trên cloud	platforms.	Ví dụ,	cloud-native	applications	được designed	và viết nên nó có thể dễ dàng scaled	up	and	down	khi nhu cầu tăng hoặc giảm. Nó cũng đơn giản để update	và perform	rollbacks.	Nó cũng có thể self-heal.

***Cloud-native	apps có thể run	on-premises.	Thực tế 1	thuộc tính của 1 cloud-native	app	có thể run	anywhere –	any	cloud,	or	any	on-prem	datacenter.***

### Where	did	Kubernetes	come	from
Kubernetes	came	out	of	Google.	It	is	the	product	of	Google’s	many	years orchestrating	containers	at	extreme	scale.	It	was	open-sourced	in	the	summer	of  2014	and	handed	over	to	the	Cloud	Native	Computing	Foundation	(CNCF).

Kubernetes là một dự án nguồn mở thuộc CNCF, được cấp phép theo giấy phép Apache 2.0 và phiên bản 1.0 được shipped trở lại vào tháng 7 năm 2015.

Kể từ đó, nó trở thành 1 công nghệ cloud-native	quan trọng trên thế giới.

Giống như nhiểu modern	cloud-native	projects,	nó được viết bằng Go	(Golang),	nó có trên Github	tại `kubernetes/kubernetes`	,	nó được thảo luận tích cực trên IRC channels,	bạn có thể follow	trên Twitter	(@kubernetesio),	và slack.k8s.io	là 1 pretty	good	slack	channel.	Ngoài ra còn có các meetups	và conferences	thường xuyên trên thế giới.

### Kubernetes	and	Docker
Kubernetes	và Docker	là các công nghệ bổ xung.	Ví dụ, nó có đặc điểm chung là để develop	applications	với Docker	và sử dụng Kubernetes	để orchestrate.

Trong mô hình này, bạn viết code bằng ngôn ngữ yêu thích của mình và sau đó sử dụng Docker để đóng gói, test và ship. Nhưng bước cuối cùng của việc chạy nó để test hoặc trong product được xử lý bởi Kubernetes.

Ở cấp độ cao hơn, bạn	có thể có 1 cụm Kubernetes	cluster	với 10 nodes	để run	production	applications.	Mỗi node	chạy Docker như container	runtime của nó.	Có nghĩa là Docker	là công nghệ low-level, nó start	và stop	containers	etc.,	và Kubernetes	là higher-level	technology, nó quan tâm đến bức tranh to hơn như quyết định nodes	nào run containers,	khi nào scale	up	or	down,	thực hiện	updates.

Hình dưới thể hiện 1 cụm Kubernetes	cluster	đơn giản với 1 vài node	sử dụng	Docker như container	runtime.

<img src=https://i.imgur.com/rUk5FbO.png>

Như hình trên Docker	không chỉ là 	container	runtime	mà Kubernetes	hỗ trợ. Trong thực tế Kubernetes	có 1 vài tính năng trừu tượng
the	container	runtime:

- The	Container	Runtime	Interface	(CRI)	là 1 layer trừu tượng chuẩn hóa 3rd-party	container	runtimes	interface	với Kubernetes.	Nó cho phép container	runtime	code	để tồn tại bên ngoài Kubernetes,	nhưng interface	được hỗ trợ và chuẩn hóa.
- Runtime	Classes	là 1 tính năng mới được giới thiệu trong Kubernetes	1.12. Tính năng này hiện ở dạng alpha	và cho phép các classes	khác nhau của runtimes.	Ví du như gVisor hoặc Kata	Containers	runtimes	có thể cung cấp sự cô lập tốt hơn Docker và containerd.

### A	data	center	OS

Nếu các ứng dụng cũ của bạn có hàng trăm VM, thì rất có thể các cloud-native	apps của bạn sẽ có hàng nghìn container. Với suy nghĩ này, chúng tôi rất cần một cách để quản lý chúng.

Ngoài ra, chúng ta sống trong một thế giới kinh doanh và công nghệ ngày càng bị phân mảnh và trong tình trạng gián đoạn liên tục. Với suy nghĩ này, chúng tôi rất cần một khuôn khổ và nền tảng có mặt khắp nơi và che giấu sự phức tạp.

## 2. Kubernetes principles of operation

### Kubernetes from 40K feet

Ở cấp cao nhất, K8s gồm 2 thứ: 
- 1 cluster để running applications
- 1 orchestrator của cloud-native microservices apps.

Ở cluster front, Kubernetes giống như bất kỳ cluster nào khác - gồm các node và control plane. Control plane expose 1 API, có 1 scheduler để gán công việc cho các node và trạng thái được ghi lại trong một persistent store. Các node là nơi các application services  chạy.

Kubernetes được điều khiển bằng API và sử dụng  HTTP RESTful tiêu chuẩn để xem và cập nhật cụm

Ở orchestrator front, orchestrator chỉ là một cái tên lạ mắt cho một ứng dụng được tạo ra từ rất nhiều dịch vụ nhỏ độc lập hoạt động cùng nhau để tạo thành một ứng dụng hữu ích

Chúng ta bắt đầu với một ứng dụng, đóng gói và cung cấp cho cluster (Kubernetes). Cluster được tạo thành từ một hoặc nhiều master và nhóm các node.

Master thi thoảng được gọi là heads hoặc head nodes, chịu trách nhiệm về cluster. Có nghĩa là nó đưa ra các scheduling, perform monitoring, implement changes, respond to events... Với các lí do đó, chúng ta thường để cập đến masters như control plane .

Nodes là nơi application services run, và chúng ta gọi nó là data plane . Nó có 1 báo cáo tới masters, và liên tục xem các công việc mới.

Để run applications trên 1 Kubernetes cluster ta làm theo các bước sau: 
- Viết application như 1 services với ngôn ngữ bạn thích.
- Đóng gói mỗi service trong container của bạn.
- Wrap mỗi container trong pod của bạn.
- Deploy Pods vào cluster thông qua higher-level controllers như :Deployments, DaemonSets, StatefulSets, CronJobs...

Kubernetes quản lý các ứng dụng khai báo. Đây là một mẫu mô tả cách ứng dụng của mình trông và cảm nhận trong một tập hợp các file YAML, POST các tệp này cho Kubernetes, sau đó chờ Kubernetes làm tất cả xảy ra.

Nhưng nó không dừng lại ở đó. Vì mẫu khai báo xác định cách chúng ta muốn một ứng dụng trông như thế nào, Kubernetes có thể xem nó và đảm bảo mọi thứ sẽ như thế nào. Nếu có thứ gì đó không cần thiết, Kubernetes sẽ cố gắng sửa nó.

### Masters and Nodes

1 Kubernetes cluster gồm masters và nodes. Chúng là Linux hosts có thể là VMs, bare metal servers trong data center, hoặc instances trong 1 private hoặc public cloud.

### Masters (control plane)
