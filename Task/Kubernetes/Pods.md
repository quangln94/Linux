# Pods
##
Trong Kubernetes, đơn vị nhỏ nhất là Pod. Triển khai các ứng dụng trên Kubernetes có nghĩa là đóng gói chúng trong Pods.

Pod chia sẻ resource cho mỗi container bao gồm: IP addresses, ports, hostname, sockets,	memory,	volumes...

System resources là các kernel namespaces bao gồm:
- Network	namespace:	IP	address,	port	range,	routing	table…
- UTS	namespace:	Hostname
- IPC	namespace:	Unix	domain	sockets…

## Deploy	Pods

Để deploy 1 Pod	tới Kubernetes cluster, ta xác định nó trong 1 file manifest và POST tới API server. Control plane kiểm tra nó,	viết nó vào cluster	store và scheduler triển khai nó đến 1 node healthy với đủ resources.	Quá trình này giống nhau với single-container Pods và multi-container	Pods.

<img src=https://i.imgur.com/AsddeoF.png>
