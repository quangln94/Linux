**Note: Một số lỗi trong quá trình cài đặt:**

***Pod Tiller bị pending sau khi cài:***

Kiểm tra xem cluster có node master và worker chưa. Với mô hình Lab chỉ có Node Master thì cho phép Node vừa là Master vừa là worker:
```sh
kubectl taint nodes --all node-role.kubernetes.io/master-
```

## 1. Installing Helm
Helm cung cấp 1 script để install trên MacOS, Windows, Linux.

Download script từ Helm’s GitHub repository:
```sh
cd /tmp
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > install-helm.sh
chmod u+x install-helm.sh
./install-helm.sh
```
## 2. Installing Tiller

Tạo tiller serviceaccount:
```sh
kubectl -n kube-system create serviceaccount tiller
```
Liên kết `tiller serviceaccount` với vai trò `cluster-admin:
```sh
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
```
Chạy lệnh `helm init` cài đặt `Tiller` trên cluster.
```sh
helm init --service-account tiller
```
Mặc đinh `Tiller` được triển khai với policy không an toàn `allow unauthenticated users`.

Xem thêm [tại đây](https://docs.helm.sh/using_helm/#securing-your-helm-installation)

Để xác thức `Tiller` đang chạy, list pods trong namespace `thekube-system`:
```sh
kubectl get pods --namespace kube-system
NAME                                    READY     STATUS    RESTARTS   AGE
. . .
kube-dns-64f766c69c-rm9tz               3/3       Running   0          22m
kube-proxy-worker-5884                  1/1       Running   1          21m
kube-proxy-worker-5885                  1/1       Running   1          21m
kubernetes-dashboard-7dd4fc69c8-c4gwk   1/1       Running   0          22m
tiller-deploy-5c688d5f9b-lccsk          1/1       Running   0          40s
```
## 3. Installing Helm Chart
Helm software packages được gọi là `charts`. Helm comes preconfigured with a curated chart repository called stable. You can browse the available charts in their GitHub repo. We are going to install the Kubernetes Dashboard as an example.

## 4. Một số command hay dùng
```sh
helm list
helm upgrade dashboard-demo stable/kubernetes-dashboard --set fullnameOverride="dashboard"
helm rollback dashboard-demo 1
helm delete dashboard-demo
helm list --deleted
helm delete dashboard-demo --purge
```

## Tài liệu tham khảo
- https://www.digitalocean.com/community/tutorials/how-to-install-software-on-kubernetes-clusters-with-the-helm-package-manager
