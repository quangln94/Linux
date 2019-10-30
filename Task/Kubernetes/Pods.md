# Pods
## Pod trong k8s

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







## Deploy	Pods

Để deploy 1 Pod	tới Kubernetes cluster, ta xác định nó trong 1 file manifest và POST tới API server. Control plane kiểm tra nó,	viết nó vào cluster	store và scheduler triển khai nó đến 1 node healthy với đủ resources.	Quá trình này giống nhau với single-container Pods và multi-container	Pods.

<img src=https://i.imgur.com/AsddeoF.png>
