# Kubernetes Deployments

Pods không thực hiện việc self-heal, scale, updates	hoặc rollbacks. Deployments sẽ làm công việc này.

Deployment chỉ có thể quản lý 1 loại Pod duy nhất. Tuy nhiên, 1	Deployment có thể manage nhiều replicas của của cùng 1 

Deployments	là objects chính trong Kubernetes	API. Chúnng được xác đính trong file manifest	khi ta POST	lên API	server

Deployments tận dụng 1 object khác được gọi là ReplicaSet. Nó sử dụng ReplicaSets để cung cấp self-healing và scalability 

<img src=https://i.imgur.com/wiak285.png>

Hãy nghĩ về việc Deployments quản lý ReplicaSets và ReplicaSets	quản lý Pods.	Đặt chúng cạnh nhau và chúng ta có 1 cách tốt để deploy và manage	applications trên Kubernetes.
