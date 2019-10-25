# Kubernetes

## 1. Kubernetes	là gì 
Kubernetes là 1 orchestrator thực hiện việc deploys và manages	applications. Nó giúp việc deploy	application, scale up	and	down,	perform updates	and	rollbacks

Kubernetes	came	out	of	Google.	It	is	the	product	of	Google’s	many	years orchestrating	containers	at	extreme	scale.	It	was	open-sourced	in	the	summer	of  2014	and	handed	over	to	the	Cloud	Native	Computing	Foundation	(CNCF).

Kubernetes là một dự án nguồn mở thuộc CNCF, được cấp phép theo giấy phép Apache 2.0 và phiên bản 1.0 được shipped trở lại vào tháng 7 năm 2015. Kể từ đó, nó trở thành 1 công nghệ cloud-native	quan trọng trên thế giới.

Kubernetes được viết bằng Go (Golang), nó có trên Github	tại `kubernetes/kubernetes`

## 2. Kubernetes and Docker

Kubernetes và Docker là các công nghệ bổ xung. Docker dùng để develop	applications và sử dụng Kubernetes	để orchestrate.

Bạn có thể code bằng ngôn ngữ yêu thích sau đó sử dụng Docker để đóng gói, test và ship. Nhưng bước cuối cùng là để test hoặc trong product được xử lý bởi Kubernetes.

Ở cấp độ cao hơn, bạn	có thể có 1 Kubernetes cluster với 10 nodes	để run production	applications.	Mỗi node	chạy Docker như container	runtime của nó.	Docker có thể start	và stop	containers...và Kubernetes	là higher-level	technology, nó quan tâm đến bức tranh to hơn như quyết định nodes	nào run containers,	khi nào scale	up	or	down,	thực hiện	updates.

Hình dưới thể hiện 1 cụm Kubernetes	cluster	đơn giản với 1 vài node	sử dụng	Docker như container	runtime.

<img src=https://i.imgur.com/rUk5FbO.png>

Kubernetes có 1 vài tính năng trừu tượng:

- The	Container	Runtime	Interface	(CRI)	là 1 layer trừu tượng chuẩn hóa 3rd-party	container	runtimes	interface	với Kubernetes.	Nó cho phép container	runtime	code	để tồn tại bên ngoài Kubernetes,	nhưng interface	được hỗ trợ và chuẩn hóa.
- Runtime	Classes	là 1 tính năng mới được giới thiệu trong Kubernetes	1.12. Tính năng này hiện ở dạng alpha	và cho phép các classes	khác nhau của runtimes.	Ví du như gVisor hoặc Kata	Containers	runtimes	có thể cung cấp sự cô lập tốt hơn Docker và containerd.

## 3. Thành phần của Kubernetes
K8s gồm 2 thứ: 
- 1 cluster để running applications
- 1 orchestrator của cloud-native microservices apps.

K8s gồm các master và node:
- Master được coi là control plane, nó expose 1 API, có 1 scheduler để gán task, đưa ra các scheduling, perform monitoring, implement changes, respond to events... cho các node và trạng thái được ghi lại trong một persistent store. Nó chịu trách nhiệm về cluster.
- Node được coi là data plane là nơi các application services chạy. Nó báo cáo cho masters và liên tục cập nhật task mới.

K8s được điều khiển bằng API và sử dụng HTTP RESTful tiêu chuẩn để quan sát và cập nhật cluster

Chúng ta bắt đầu với một ứng dụng, đóng gói và cung cấp cho cluster (Kubernetes). Cluster được tạo thành từ một hoặc nhiều master và nhóm các node.

Để run applications trên 1 Kubernetes cluster ta làm theo các bước sau: 
- Viết application như 1 services với ngôn ngữ tùy chọn.
- Đóng gói mỗi service trong container.
- Wrap mỗi container trong pod.
- Deploy Pods vào cluster thông qua higher-level controllers như: Deployments, DaemonSets, StatefulSets, CronJobs...

Kubernetes quản lý các ứng dụng khai báo. Đây là một mẫu mô tả cách ứng dụng của mình trông và cảm nhận trong một tập hợp các file YAML, POST các tệp này cho Kubernetes, sau đó chờ Kubernetes làm tất cả xảy ra.

Không dừng lại ở đó. Vì mẫu khai báo xác định cách chúng ta muốn một ứng dụng trông như thế nào, Kubernetes có thể xem và đảm bảo mọi thứ sẽ như thế nào. Nếu có thứ gì đó không cần thiết, K8s sẽ cố gắng sửa nó.

### 3.1 Masters and Nodes

1 Kubernetes cluster gồm masters và nodes. Chúng là Linux hosts có thể là VMs, bare metal servers trong data center, hoặc instances trong 1 private hoặc public cloud.

#### 3.1.1 Masters (control plane)
1	Kubernetes master	là 1 bộ sưu tập system services tạo nên control plane của cluster.

Việc chạy tất cả các service master trên 1 host thật đơn giản. Điều này chỉ thích hợp cho môi trương test. Với môi trường product phải có multi-master	high	availability	(HA). Đây là lý do tại sao các cloud providers lớn triển khai các HA	masters	như 1 phần của Kubernetes-as-a-Service platforms	như là Azure	Kubernetes	Service	(AKS),	AWS	Elastic	Kubernetes Service	(EKS),	và Google	Kubernetes	Engine	(GKE).

Cấu hình chạy 3 hoặc 5 replicated	masters	trong  1 HA	được khuyến cáo.

**API	server**  

API server là Grand Central Station của Kubernetes. Tất cả giao tiếp giữa các thành phần đều đi qua API server

Nó exposes 1 RESTful	API	chúng ta `POST`	YAML	configuration	files	lên HTTPS. File YAML thường được gọi là manifests, chứa trạng thái của application.	Như sử dụng container	image nào, expose port nào và có bao nhiêu Pod replicas	để chạy.

Tất cả các requests đến API server đều phải kiểm tra xác thực và ủy quyền, sau khi hoàn thành, cấu hình trong file YAML được xác thực, được lưu vào cluster store và được deployed vào cluster.

**Cluster	store**

Cluster store là phần duy nhất của control plane và nó lưu trữ toàn bộ cấu hình và trạng thái của cluster. Nó là 1 thành phần quan trọng của cluster. No cluster	store, no	cluster.

Cluster	store	dựa trên etcd - cơ sở sữ liệu phân tán (distributed	database). Nên chạy từ 3->5 etcd replicas cho HA và nên cung cấp các cách thích hợp để khôi phục khi gặp lỗi.

Về availability, etcd thích sự nhất quán hơn tính khả dụng. Có nghĩa là nó sẽ không chấp nhận tình huống split-brain và sẽ dừng cập nhật vào cluster để duy trì tính nhất quán. Tuy nhiên, nếu etcd không khả dụng, các ứng dụng chạy trên cluster sẽ tiếp tục hoạt động, nó chỉ cập nhật cấu hình cụm sẽ bị tạm dừng.

Với cơ sở dữ liệu phân tán, tính nhất quán của viêc ghi vào database là rất quan trọng. Ví dụ, việc ghi vào cùng một giá trị nhiều lần từ các node khác nhau cần được xử lý. etcd sử dụng thuật toán đồng thuận RAFT phổ biến để thực hiện điều này.

**Controller manager**

Controller manager thực hiện nhiều vòng điều khiển độc lập theo dõi cluster và phản hồi các events.

Các thành phần bên trong bao gồm: node	controller,	endpoints	controller và replicaset	controller. Mỗi cái chạy background liên tục theo dõi API server để đảm bảo trạng thái hiện tại của cluster khớp với trạng thái mong muốn.

**The scheduler**

Scheduler theo dõi các task mới và gán chúng cho các node khỏe mạnh phù hợp. Nó thực hiện logic phức tạp để lọc các node không có khả năng chạy Pod và sau đó xếp hạng các node có khả năng. Bản thân hệ thống xếp hạng rất phức tạp, nhưng node có điểm xếp hạng cao nhất được chọn để chạy Pod

Khi xác định node có khả năng chạy Pod, scheduler kiểm tra node bị nhiễm độc, có bất kỳ rule affinity hoặc anti-affinity nào không, network port	available	của Pod trên node, node có đủ tài nguyên không... Node không có khả năng chạy Pod đều bị bỏ qua và các Pod còn lại được xếp hạng theo những điều như: node đã có image cần thiết chưa, node có bao nhiêu tài nguyên free, bao nhiêu Pod là node đang chạy. Mỗi tiêu chí đều có điểm và node có nhiều điểm nhất được chọn để chạy Pod.

Nếu scheduler không thể tìm thấy một node phù hợp, Pod không thể được lên lịch và chờ xử lý

Scheduler không thực hiện cơ chế chạy Pods, nó chỉ chọn các node sẽ được lên lịch

**Cloud controller manager**

Nếu đang chạy cluster trên public	cloud	platform được hỗ trợ, chẳng hạn như AWS, Azure hoặc GCP, control	plane của bạn sẽ chạy cloud	controller manager. Công việc của nó là quản lý tích hợp với các công nghệ và dịch vụ cloud cơ bản như: instances, load-balancers, and	storage.

Hình ảnh dưới thể hiện 1 Kubernetes	master (control	plane).

<img src=https://i.imgur.com/vq5xjwo.png>

#### 3.1.2 Node

Nodes	là workers của 1 Kubernetes	cluster. Nó có 3 nhiệm vụ chính:
- Quan sát API	Server để biết task mới 
- Thực hiện task mới 
- Báo cáo lại cho control plane

3 thành phấn chính của 1 node:

<img src=https://i.imgur.com/KYyhCvq.png>

**Kubelet**

Kubelet là thành phần chính của Kubernetes agent và chạy trên mọi node trong cluster. 

Khi 1 node mới join vào cluster, quá trình bao gồm việc cài đặt kubelet và phản hồi.

Một trong những công việc chính của kubelet là xem API server để phân task mới. Bất cứ khi nhìn thấy, nó sẽ thực thi tác vụ và duy trì kênh báo cáo trở lại control	plane. Nó cũng theo dõi các định nghĩa Pod tĩnh cục bộ

Nếu 1 kubelet không thể chạy 1 task cụ thể, nó sẽ báo cáo lại cho master để control plane quyết định hành động tiếp theo. Ví dụ khi 1 Pod không start được trên 1 node, kubelet không phản hổi cho việc tìm kiếm node khác để chạy. Nó đơn giản chỉ báo lại cho control plane  và control plane quyết định phải làm gì.

**Container runtime**

Kubelet cần 1 container	runtime	để thực hiện các tác vụ liên quan đến container như pulling	images, starting	và stopping	containers.

Ban đầu, Kubernetes có native	support	cho 1 vài container	runtimes như Docker. Gần đây có đã chuyển sang 1 mô hình plugin được gọi là Container	Runtime	Interface	(CRI). Đây là 1 lớp trừu tượng cho external	(3rd-party)	container	runtimes	để plug	in	to.	CRI	không thể hiện bộ phận bên trong của Kubernetes	và exposes	1  clean	documented	interface	cho 3rd-party	container	runtimes	để plug	in to.

CRI	hỗ trợ tích hợp runtimes vào Kubernetes.

Có nhiều container runtimes	có sẵn cho Kubernetes.	Phổ biến nhất là cri-containerd. Đây là open-source	project dựa trên cộng đồng chuyển CNCF	containerd	runtime	sang CRI	interface.	Nó có nhiều hỗ trợ và thay thế Docker	là container runtime	được sử dụng trong Kubernetes.

**Kube-proxy**

Kube-proxy chạy trên mọi node trong cluster và chịu trách nhiệm cho local	networking. Ví dụ, nó đảm bảo mỗi node có địa chỉ IP duy nhất và thực hiện các quy tắc IPTABLES hoặc IPVS cục bộ để xử lý định tuyến và load-balancing trên Pod	network.

## Tài liệu tham khảo 
- The	Kubernetes	Book - The	fastest	way	to	get	your	head	around	Kubernetes! - Nigel	Poulton	@nigelpoulton
