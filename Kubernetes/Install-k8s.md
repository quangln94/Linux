# Install k8s trên CentOS 7
## 1. Mô hình Lab
|Server|Vai trò|IP|
|------|-------|--|
|Server01|Master|10.10.10.221|
|Server02|Worker|10.10.10.222|
|Server03|Worker|10.10.10.223|

## 2. Cài đặt
**Thay đổi trên tất cả các Node**

***Nếu không disabled swap, kubelet service sẽ không thể start trên masters và nodes. Nếu chạy nodes với (traditional to-disk) swap, sẽ mất đi nhiều thuộc tính isolation, có thể sharing và không có các dự đoán xung quanh việc performance hoặc latency hoặc IO.***
```sh
$ swapoff -a
```
Update `fstab` để `swap` vẫn bị `disabled` sau khi reboot.
```
$ vim /etc/fstab
#/dev/mapper/cl-swap swap swap defaults 0 0
```
```sh
$ cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
$ sysctl --system
```
**Tắt firewalld và SElinux**
```
systemctl stop firewalld
systemctl disable firewalld
```
**Cài đặt Kubeadm**
```sh
$ cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
$ yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
$ systemctl enable kubelet
```
**Cài đặt Docker**
```sh
yum -y install docker
systemctl start docker
systemctl enable docker
```
### 2.1 Master Node
```sh
kubeadm init --apiserver-advertise-address=10.10.10.221 --pod-network-cidr=10.244.0.0/16
------------------------------------------
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

# the command below is necessary to run on Worker Node when he joins to the cluster, so remember it
kubeadm join 10.10.10.221:6443 --token ya28xk.8uc7mxgxh4xvkqu6 \
    --discovery-token-ca-cert-hash sha256:f06bff4248081281c22fed88452edb2a4dedd16b1155f297fb0d8639d8bab85a
```
Trong đó: 
- `--apiserver-advertise-address:` Chỉ định IP Kubernetes API server.
- `--pod-network-cidr:` Chỉ định network để Pod giao tiếp với nhau.
There are some plugins for Pod Network. (refer to details below)
  ⇒ https://kubernetes.io/docs/concepts/cluster-administration/networking/

**Set cluster admin user**
```sh
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
**Configure Pod Network with Flannel**
```sh
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```
**Kiểm tra state**
```sh
[root@server01 ~]# kubectl get nodes
NAME       STATUS   ROLES    AGE   VERSION
server01   Ready    master   23m   v1.16.2
[root@server01 ~]# kubectl get pods --all-namespaces
NAMESPACE     NAME                               READY   STATUS    RESTARTS   AGE
kube-system   coredns-5644d7b6d9-grjwr           1/1     Running   0          23m
kube-system   coredns-5644d7b6d9-rbwq2           1/1     Running   0          23m
kube-system   etcd-server01                      1/1     Running   0          22m
kube-system   kube-apiserver-server01            1/1     Running   0          22m
kube-system   kube-controller-manager-server01   1/1     Running   0          22m
kube-system   kube-flannel-ds-amd64-87mwj        1/1     Running   0          58s
kube-system   kube-proxy-trc7x                   1/1     Running   0          23m
kube-system   kube-scheduler-server01            1/1     Running   0          22m
```
## Worker Node
```sh
$ kubeadm join 10.10.10.221:6443 --token ya28xk.8uc7mxgxh4xvkqu6     --discovery-token-ca-cert-hash sha256:f06bff4248081281c22fed88452edb2a4dedd16b1155f297fb0d8639d8bab85a
[preflight] Running pre-flight checks
[preflight] Reading configuration from the cluster...
[preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
[kubelet-start] Downloading configuration for the kubelet from the "kubelet-config-1.16" ConfigMap in the kube-system namespace
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Activating the kubelet service
[kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
```
## 3. Chạy ứng dụng
Bước 1: Tạo 02 container với images là nginx, 2 container này chạy dự phòng cho nhau, port của các container là 80
```sh
[root@server01 ~]# kubectl run test-nginx --image=nginx --replicas=2 --port=80
kubectl run --generator=deployment/apps.v1 is DEPRECATED and will be removed in a future version. Use kubectl run --generator=run-pod/v1 or kubectl create instead.
deployment.apps/test-nginx created
```
Tới đây, ta mới tạo ra các container và chỉ có thể truy cập từ các máy trong cụm cluster, bởi vì các container này chưa được mở các port để ánh xạ với các IP của các máy trọng cụm K8S.

Ta có thể kiểm tra lại các container nằm trong các POD:
```sh
[root@server01 ~]# kubectl get pods -o wide
NAME                          READY   STATUS    RESTARTS   AGE     IP           NODE       NOMINATED NODE   READINESS GATES
test-nginx-78bcf56566-6v8m7   1/1     Running   0          5m38s   10.244.2.2   server03   <none>           <none>
test-nginx-78bcf56566-h6lzl   1/1     Running   0          5m38s   10.244.1.2   server02   <none>           <none>
```
Việc phân phố số lượng container này một phần là do thành phần scheduler trong K8S thực hiện

Sử dụng lệnh để dưới để xem các service nào đã sẵn sàng để deployment.
```sh
[root@server01 ~]# kubectl get deployment
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
test-nginx   2/2     2            2           7m24s
```
Bước 2: Thực hiện deploy ứng dụng trên
- Chính là bước phơi các port của container ra.
- Tới bước này, chúng ta chưa thể truy cập vào các container được, cần thực hiện thêm bước deploy các container với các tùy chọn phù hợp, cụ thể như sau
```sh
[root@server01 ~]# kubectl expose deploy test-nginx --port 80 --target-port 80 --type NodePort
service/test-nginx exposed
```
Ngoài các tùy chọn `--port 80` và `--target-port 80` thì ta lưu ý tùy chọn `--type NodePort`, đây là tùy chọn để ánh xạ port của máy cài K8S vào container vừa tạo, sử dụng các lệnh dưới để biết được port mà host ánh xạ là bao nhiêu ở bên dưới.
```sh
[root@server01 ~]# kubectl describe service test-nginx
Name:                     test-nginx
Namespace:                default
Labels:                   run=test-nginx
Annotations:              <none>
Selector:                 run=test-nginx
Type:                     NodePort
IP:                       10.110.236.21
Port:                     <unset>  80/TCP
TargetPort:               80/TCP
NodePort:                 <unset>  31566/TCP
Endpoints:                10.244.1.2:80,10.244.2.2:80
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>
```
Trong đó: 
- `IP: 10.110.236.21:` là IP được cấp cho ứng dụng `test-nginx` vừa tạo ở trên, địa chỉ này có ý nghĩa local.
- `Endpoints: 10.244.1.2:80,10.244.2.2:80:` Đây là địa chỉ của dải mạng nội tại và liên kết các container khi chúng thuộc một POD. Có thể đứng trên một trong các node của cụm cluster K8S và thực hiện lệnh curl để truy cập web, ví dụ: `curl 10.244.1.2` hoặc curl `10.244.2.2`. Kết quả trả về html của web server.
- `Port` và `TargetPort`: là các port nằm trong chỉ định ở lệnh khi ta deploy ứng dụng.
- `NodePort`: <unset> 31566/TCP: Đây chính là port mà ta dùng để truy cập vào web server được tạo ở trên thông qua một trong các IP của các máy trong cụm cluser. Ta sẽ có các kiểm chứng dưới.

Đứng trên node k8s-master thực hiện `curl 10.244.1.2` hoặc `curl 10.244.2.2` như sau:
```sh
[root@server01 ~]# curl 10.244.1.2
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```
Đứng trên node k8s-master và thực hiện kiểm tra port được ánh xạ với container (trong kết quả trên là port 31566/TCP)
```sh
[root@server01 ~]# ss -lan | grep 31566
tcp    LISTEN     0      128    [::]:31566              [::]:*
```

## Tài liệu tham khảo
- https://www.server-world.info/en/note?os=CentOS_7&p=kubernetes&f=3
- https://blogd.net/kubernetes/cai-dat-kubernetes-cluster/
- https://github.com/hocchudong/ghichep-kubernetes/blob/master/docs/kubernetes-5min/02.Caidat-Kubernetes.md
