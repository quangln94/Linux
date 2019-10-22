## 1. Kubernetes	primer
Kubernetes là 1 orchestrator. Phần lớn it	orchestrates	containerized cloud-native	apps. Tuy nhiên có những Projects cho phép nó phối hợp mọi thứ như virtual	machines	và functions (serverless	workloads). Tất cả điều này đang bổ sung cho Kubernetes là nhà soạn nhạc thực tế cho cloud-native	applications.

Thật tuyệt vời, nhưng chúng ta có ý nghĩa gì khi sử dụng các thuật ngữ orchestrator	và	cloud-native	?
tự nhiên	?

Một orchestrator	là 1 back-end	system	thực hiện việc deploys	và manages	applications. Có nghĩa là nó giúp bạn deploy	application,	scale	it	up	and	down,	perform updates	and	rollbacks... Nếu nó là 1 orchestrator tốt,	nó hoạt động mà bạn không cần phải giám sát.

Một cloud-native	application	là 1 business	application	được làm từ  1 set của các services nhỏ độc lập giáo tiếp và hình thành 1 application hữu ích. Như cái tên cho thấy,	design	này chi phép nó đối phó với cloud-like	demands	và run	natively	trên cloud	platforms.	Ví dụ,	cloud-native	applications	được designed	và viết nên nó có thể dễ dàng scaled	up	and	down	khi như cầu tăng hoặc giảm. No cũng đơn giản để update	và perform	rollbacks.	Nó cũng có thể self-heal.

***Mặc dù có tên,	cloud-native	apps	cũng có thể run	on-premises.	Thực tế 1	thuộc tính của 1 cloud-native	app	có thể run	anywhere –	any	cloud,	or	any	on-prem	datacenter.***

### Where	did	Kubernetes	come	from
Kubernetes	came	out	of	Google.	It	is	the	product	of	Google’s	many	years orchestrating	containers	at	extreme	scale.	It	was	open-sourced	in	the	summer	of  2014	and	handed	over	to	the	Cloud	Native	Computing	Foundation	(CNCF).

Kể từ đó, nó trở thành 1 important	cloud-native	technology	on	the planet.

Giống như nhiểu modern	cloud-native	projects,	nó được viết bằng Go	(Golang),	nó có trên Github	tại `kubernetes/kubernetes`	,	nó được thảo luận tích cực trên IRC channels,	bạn có thể follow	trên Twitter	(@kubernetesio),	và slack.k8s.io	là 1 pretty	good	slack	channel.	Ngoài ra còn có các meetups	và conferences	thường xuyên trên thế giới.

### Kubernetes	and	Docker
Kubernetes	và Docker	là công nghệ bổ xung.	Ví dụ, nó là chung để develop	applications	với Docker	và sử dụng Kubernetes	để orchestrate.

Trong mô hình này, bạn viết code bằng ngôn ngữ yêu thích của mình và sau đó sử dụng Docker để đóng gói, test và ship. Nhưng bước cuối cùng của việc chạy nó trong test hoặc product được xử lý bởi Kubernetes.

Ở cấp độ cao hơn, bạn	có thể có 1 cụm Kubernetes	cluster	với 10 nodes	để run	production	applications.	Đăng sau nó, mỗi node	đang chạy Docker như container	runtimecủa nó.	Có nghĩa là Docker	là công nghệ low-level, nó starts	và stops	containers	etc.,	và Kubernetes	là higher-level	technology, nó quan tâm đến bức tranh to hơn như quyết định nodes	để run
containers,	quyết định khi nào scale	up	or	down,	và thực hiện	updates.
