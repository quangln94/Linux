## Daemonset

Daemonset được tạo ra cho 1 mục đích cụ thể: đảm bảo Pods được quản lý và chạy trên mọi Node. Khi Node joins vào cluster, DaemonSet đảm bảo các các Pods cần thiết chạy trên nó.

## DeamonSet Deployment
Sửa file yaml
```sh
$ vim daemonset.yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: fluentd
  namespace: kube-system
  labels:
	tier: management
	app: fluentd
spec:
  selector:
	matchLabels:
  	name: fluentd
  template:
	metadata:
  	labels:
    	name: fluentd
	spec:
  	containers:
    	- resources:
        	limits:
          	memory: 200Mi
        	requests:
          	cpu: 100m
          	memory: 200Mi
      	securityContext:
        	privileged: true
      	image: fluent/fluentd
      	name: fluentd-elasticsearch
      	volumeMounts:
        	- name: varlog
          	mountPath: /var
        	- name: varlibdockercontainers
          	mountPath: /var/lib/docker/containers
          	readOnly: true
  	volumes:
    	- name: varlog
      	hostPath:
        	path: /var
    	- name: varlibdockercontainers
      	hostPath:
        	path: /var/lib/docker/containers
```
**Deploy app**
```sh
kubectl apply -f daemonset.yaml
```
**Kiểm tra DaemonSet tạo ra cái gì**:
```shkubectl -n kube-system get pods
NAME                                	READY   STATUS	RESTARTS   AGE
coredns-696c56cf6f-gjcs9            	1/1 	Running   0      	6h46m
coredns-696c56cf6f-twj4l            	1/1 	Running   0      	6h50m
coredns-autoscaler-bc55cb685-xpzk6  	1/1 	Running   0      	6h50m
fluentd-f657w                       	1/1 	Running   0      	5h26m
fluentd-wsvdf                       	1/1 	Running   0      	5h26m
heapster-5678f88989-fvdj7           	2/2 	Running   0      	6h46m
kube-proxy-xdggl                    	1/1 	Running   0      	6h47m
kube-proxy-z899d                    	1/1 	Running   0      	6h47m
kubernetes-dashboard-7b749f655b-lbgnp   1/1 	Running   1      	6h50m
metrics-server-5b7d5c6f8d-kss58     	1/1 	Running   1      	6h50m
omsagent-fk4qg                      	1/1 	Running   1      	6h47m
omsagent-lgqkz                      	1/1 	Running   0      	6h47m
omsagent-rs-7b459857cd-g9gsx        	1/1 	Running   1      	6h50m
tunnelfront-5d4d658788-28tdc        	1/1 	Running   0      	6h50
```
## Hạn chế DaemonSets chạy trên các Node cụ thể

Sử dụng `nodeSelector` để chọn Nodes bằng labels hoặc dựa trên 1 số thuộc tính Node đã được xác định.

Chỉnh sửa DaemonSet chỉ định chạy trên Node 1:
```sh
$ kubectl get nodes
NAME                   	STATUS   ROLES   AGE	VERSION
aks-agentpool-30423418-0   Ready	agent   7h2m   v1.12.8
aks-agentpool-30423418-1   Ready	agent   7h2m   v1.12.8
```
```sh
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: fluentd
  namespace: kube-system
  labels:
	tier: management
	app: fluentd
spec:
  selector:
	matchLabels:
  	name: fluentd
  template:
	metadata:
  	labels:
    	name: fluentd
	spec:
  	containers:
    	- resources:
        	limits:
          	memory: 200Mi
        	requests:
          	cpu: 100m
          	memory: 200Mi
      	securityContext:
        	privileged: true
      	image: fluent/fluentd
      	name: fluentd-elasticsearch
      	volumeMounts:
        	- name: varlog
          	mountPath: /var
        	- name: varlibdockercontainers
          	mountPath: /var/lib/docker/containers
          	readOnly: true
  	nodeSelector:
    	  kubernetes.io/hostname: aks-agentpool-30423418-0
  	volumes:
    	- name: varlog
      	hostPath:
        	path: /var
    	- name: varlibdockercontainers
      	hostPath:
        	path: /var/lib/docker/containers
```
**Deploy lại app và check Pods**
```sh
$ kubectl apply -f daemonset.yaml
$ kubectl -n kube-system get pods
NAME                                	READY   STATUS	RESTARTS   AGE
coredns-696c56cf6f-gjcs9            	1/1 	Running   0      	6h55m
coredns-696c56cf6f-twj4l            	1/1 	Running   0      	6h59m
coredns-autoscaler-bc55cb685-xpzk6  	1/1 	Running   0      	6h59m
fluentd-wg7rf                       	1/1 	Running   0      	3s
heapster-5678f88989-fvdj7           	2/2 	Running   0      	6h55m
kube-proxy-xdggl                    	1/1 	Running   0      	6h56m
kube-proxy-z899d                    	1/1 	Running   0      	6h56m
kubernetes-dashboard-7b749f655b-lbgnp   1/1 	Running   1      	6h59m
metrics-server-5b7d5c6f8d-kss58     	1/1 	Running   1      	6h59m
omsagent-fk4qg                      	1/1 	Running   1      	6h56m
omsagent-lgqkz                      	1/1 	Running   0      	6h56m
omsagent-rs-7b459857cd-g9gsx        	1/1 	Running   1      	6h59m
tunnelfront-5d4d658788-28tdc        	1/1 	Running   0      	6h59m
```
Có 1 Pod chạy vì chỉ có 1 Node khớp.

## Tiếp cận 1 DaemonSet Pod
Có 1 vài mẫu thiết kế DaemonSet-pods truyền thông trong cluster:
- The Push pattern: Pod không nhận traffic mà đẩy data tới các services như ElasticSearch.
- NodeIP và known port pattern: Pods sử dụng hostPort để có được IP Node. Clients có thể sử dụng IP Node và known port để connect tới Pod.
- DNS pattern: Tạo 1 Headless Service thu thập DaemonSet pods. Sử dụng Endpoints để khám phá DaemonSet pods.
- Service pattern: Tạo 1 service truyền thông để thu thập DaemonSet pods. Sử dụng NodePort để expose Pods sử dụng port ngẫu nhiên.Hạn chế là không có cách nào để chọn 1 Pod cụ thể.

## Tài liệu tham khảo
- https://www.magalix.com/blog/kubernetes-daemonsets-101
