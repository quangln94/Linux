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
1	Kubernetes	master	là 1 bộ sưu tập system	services tạo nên control plane của cluster.

Đơn giản nhất là việc chạy tất cả các service master trên 1 host. Điều này chỉ thích hợp cho môi trương test. Với môi trường product multi-master	high	availability	(HA)	là phải có. Đây là lý do tại sao các cloud providers lớn triển khai các HA	masters	như 1 phần của Kubernetes-as-a-Service platforms	như là Azure	Kubernetes	Service	(AKS),	AWS	Elastic	Kubernetes Service	(EKS),	và Google	Kubernetes	Engine	(GKE).

Cấu hình chạy 3 hoặc  5 replicated	masters	trong  1 HA	được khuyến cáo.

Nó cũng được coi là một thực hành tốt để không chạy user	applications	trên	masters. Điều này cho phép các master tập trung hoàn toàn vào việc quản lý cluster.

#### The	API	server  

API server là Grand Central Station của Kubernetes. Tất cả giao tiếp giữa các thành phần đều đi qua API server

Nó exposes 1 RESTful	API	chúng ta `POST`	YAML	configuration	files	lên HTTPS.	YAML	files	thường được gọi là manifests,	chứa trạng thái của application.	Bao gồm những thứ như,	sử dụng container	image nào, expose port nào và có bao nhiêu Pod	replicas	để chạy.

Tất cả các requests đến API serrver đều phải kiểm tra xác thực và ủy quyền, nhưng sau khi hoàn thành, cấu hình trong YAML file được xác thực, được lưu vào cluster store và được deployed vào cluster.

Bạn có thể nghĩ rằng API server như là bộ não của cluster

#### The	cluster	store

Nếu API server là bộ não của cluster thì cluster store là trái tim. Nó là phần duy nhất của control plane và nó lưu trữ toàn bộ cấu hình và trạng thái của cluster. Như vậy, nó là một thành phần quan trọng của cluster - no	cluster	store,	no	cluster.

Cluster	store	đang dựa trên etcd	,	1	distributed	database phổ biến. Nó là single	source	của truth	cho cluster,	bạn nên chạy từ 3-5 etcd replicas	cho high-availability, và bạn nên cung cấp các cách thích hợp để khôi phục khi gặp lỗi.

Về availability, etcd thích sự nhất quán hơn tính khả dụng. Điều này có nghĩa là nó sẽ không chấp nhận tình huống split-brain và sẽ dừng cập nhật vào cluster để duy trì tính nhất quán. Tuy nhiên, nếu etcd không khả dụng, các ứng dụng chạy trên cluster sẽ tiếp tục hoạt động, nó chỉ cập nhật cấu hình cụm sẽ bị tạm dừng.

Với cơ sở dữ liệu phân tán, tính nhất quán của ghi vào database là rất quan trọng. Ví dụ, việc ghi vào cùng một giá trị nhiều lần từ các node khác nhau cần được xử lý. etcd sử dụng thuật toán đồng thuận RAFT phổ biến để thực hiện điều này.

#### The	controller	manager

Controller	manager	là 1 controller	của controllers và được shipped dưới dạng nhị phân đơn nguyên. Mặc dù nó chạy như một tiến trình đơn lẻ, nó thực hiện nhiều vòng điều khiển độc lập theo dõi cluster và phản hồi các events.

Một số vòng điều khiển bao gồm: node	controller,	endpoints	controller và replicaset	controller. Mỗi cái chạy background liên tục theo dõi API server để đảm bảo trạng thái hiện tại của cluster khớp với trạng thái mong muốn.

#### The	scheduler

Ở mức cao, scheduler theo dõi các nhiệm vụ công việc mới và gán chúng cho các node khỏe mạnh phù hợp. Nó thực hiện logic phức tạp để lọc các node không có khả năng chạy Pod và sau đó xếp hạng các node có khả năng. Bản thân hệ thống xếp hạng rất phức tạp, nhưng node có điểm xếp hạng cao nhất được chọn để chạy Pod

Khi xác định node có khả năng chạy Pod, scheduler thực hiện kiểm tra. Bao gồm node bị nhiễm độc, có bất kỳ rule affinity hoặc anti-affinity nào không, network port	available	của Pod trên node, node có đủ tài nguyên không... Mọi node không có khả năng chạy Pod đều bị bỏ qua và các Pod còn lại được xếp hạng theo những điều như: node đã có image cần thiết chưa, node có bao nhiêu tài nguyên free, bao nhiêu Pod là node đang chạy. Mỗi tiêu chí đều có điểm và node có nhiều điểm nhất được chọn để chạy Pod.

Nếu scheduler không thể tìm thấy một node phù hợp, Pod không thể được lên lịch và chờ xử lý

Scheduler không thực hiện cơ chế chạy Pods, nó chỉ chọn các node sẽ được lên lịch

#### The cloud controller manager

Nếu bạn đang chạy cluster của mình trên public	cloud	platform được hỗ trợ, chẳng hạn như AWS, Azure hoặc GCP, control	plane của bạn sẽ chạy cloud	controller manager. Công việc của nó là quản lý tích hợp với các công nghệ và dịch vụ cloud cơ bản như: instances, load-balancers, and	storage.

Hình ảnh dưới thể hiện 1 Kubernetes	master (control	plane).

<img src=https://i.imgur.com/vq5xjwo.png>

### Node

Nodes	là workers của 1 Kubernetes	cluster. 3 nhiệm vụ chính của nó là:
- Xem API	Server để biết công việc mới 
- Thực hiện công việc mới 
- Báo cáo lại cho control	plane

3 thành phấn chính của 1 node:

<img src=https://i.imgur.com/KYyhCvq.png>

#### Kubelet

Kubelet là thành phần nổi bật trện mỗi node. Nó là thành phần chính của Kubernetes agent và nó chạy trên mọi node trong cluster. 

Khi join 1 node mới vào cluster, quá trình này bao gồm việc cài đặt kubelet và phản hồi. Điều này có hiệu quả gộp CPU CPU, RAM và lưu trữ vào nhóm cụm rộng hơn. Nghĩ lại chương trước nơi chúng ta đã nói về Kubernetes là HĐH trung tâm dữ liệu và trừu tượng hóa tài nguyên trung tâm dữ liệu thành một nhóm có thể sử dụng được.

Một trong những công việc chính của kubelet là xem API server để phân công công việc mới. Bất cứ khi nhìn thấy, nó sẽ thực thi tác vụ và duy trì kênh báo cáo trở lại control	plane. Nó cũng theo dõi các định nghĩa Pod tĩnh cục bộ

Nếu 1 kubelet không thể chạy 1 task cụ thể, nó sẽ báo cáo lại cho master để control plane quyết định hành động tiếp theo. Ví dụ khi 1 Pod không start đc trên 1 node, kubelet không phản hổi cho việc tìm kiếm node khác để chạy. Nó đơn giản chỉ báo lại cho control plane  và control plane quyết định phải làm gì.

#### Container	runtime

Kubelet cần 1 container	runtime	để thực hiện các tác vụ liên quan đến container như pulling	images, starting	và stopping	containers.

Trong những ngày đầu,	Kubernetes có native	support	cho 1 vài container	runtimes như Docker. Gần đây có đã chuyển sang 1 mô hình plugin được gọi là Container	Runtime	Interface	(CRI). Đây là 1 lớp trừu tượng cho external	(3rd-party)	container	runtimes	để plug	in	to.	CRI	không thể hiện bộ phận bên trong của Kubernetes	và exposes	1  clean	documented	interface	cho 3rd-party	container	runtimes	để plug	in to.

CRI	hỗ trợ tích hợp runtimes vào Kubernetes.

Có nhiều container runtimes	có sẵn cho Kubernetes.	Phổ biến nhất là cri-containerd. Đây là open-source	project dựa trên cộng đồng chuyển CNCF	containerd	runtime	sang CRI	interface.	Nó có nhiều hỗ trợ và thay thế Docker	là container runtime	được sử dụng trong Kubernetes.

#### Kube-proxy

Phần cuối cùng của node là proxy kube. Nó chạy trên mọi node trong cluster và chịu trách nhiệm cho local	networking. Ví dụ, nó đảm bảo mỗi node có địa chỉ IP duy nhất và thực hiện các quy tắc IPTABLES hoặc IPVS cục bộ để xử lý định tuyến và load-balancing trên Pod	network.

### Packaging	apps

Để một ứng dụng chạy trên Kubernetes cluster, nó cần: 
- Đóng gói như một container
- Được bọc trong một Pod
- Được triển khai thông qua manifest file

Chúng ta viết 1 application	service	với ngôn ngữ của mình sau đó build nó thành 1 container	image	và lưu nó trong 1 registry.	Tại đây application	service	được đóng gói.

Tiếp theo là xác định 1 Kubernetes Pod để chạy service được đóng gói. 1 Pod	cho phép containers	chạy trên Kubernetes cluster.	Khi xác định 1 Pod cho container,	chúng ta sẵn sàng cho việc deploy nó trên cluster.

Kubernetes cung cấp 1 số objects để deploying	và managing	Pods.	Chung nhất là Deployment, cung cấp khả năng mở rộng, tự phục hồi,	rolling updates.	Ta xác định chúng trong 1 file YAML chỉ định những thứ như image để sử dụng và có bao nhiểu replicas để deploy.

Hình thể hiện các application	code được đóng gói như 1 container,	chạy bên trong 1 Pod, được quản lý bởi 1 Deployment.

<img src=https://i.imgur.com/NkTOamz.png>
