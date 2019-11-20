# Using Helm to deploy to Kubernetes.md

## 1. Building a Helm chart

clone repo sau:
```sh
git clone https://github.com/daemonza/testapi.git; cd testapi
```
Tạo Chart
```sh
helm create testapi-chart
```
Lệnh `helm lint` đưa đường dẫn tới `chart` và chạy kiểm tra để đảm bảo `chart` được định dạng tốt. 

```sh
[root@server01 testapi]# helm lint testapi-chart
==> Linting testapi-chart
[INFO] Chart.yaml: icon is recommended

1 chart(s) linted, no failures
```
Nếu everything is good, thì có thể package chart như 1 release bằng cách chạy:
```sh
[root@server01 testapi]# helm package testapi-chart --debug
Successfully packaged chart and saved it to: /root/testapi/testapi-chart-0.1.1.tgz
[debug] Successfully saved /root/testapi/testapi-chart-0.1.1.tgz to /root/.helm/repository/local
```
Flag `--debug` để show output của việc đóng gói `chart`. 

Deploy bản release:
```sh
[root@server01 testapi]# helm install testapi-chart-0.1.1.tgz
NAME:   moldy-squid
LAST DEPLOYED: Wed Nov 20 15:15:32 2019
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Deployment
NAME                       AGE
moldy-squid-testapi-chart  0s

==> v1/Pod(related)
NAME                                        AGE
moldy-squid-testapi-chart-7d8d7d67c5-rkzpq  0s

==> v1/Service
NAME                       AGE
moldy-squid-testapi-chart  0s

==> v1/ServiceAccount
NAME                       AGE
moldy-squid-testapi-chart  0s


NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=testapi-chart,app.kubernetes.io/instance=moldy-squid" -o jsonpath="{.items[0].metadata.name}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl port-forward $POD_NAME 8080:80
```
Output trên thể hiện 1 deployment được tạo trong k8s, testapi thực hiện scaled 1 pods và 1 service được tạo để expose deployment trên cluster IP on port 80. File NOTES.txt show cách access pod.

Show packages được deployed với release versions bằng cách:
```sh
[root@server01 testapi]# helm ls
NAME            REVISION        UPDATED                         STATUS          CHART                   APP VERSION     NAMESPACE
hasty-ferret    1               Wed Nov 20 15:13:08 2019        DEPLOYED        testapi-chart-0.1.0     1.0             default
```
Chỉnh sửa file `Chart.yaml` và thay đổi version từ `0.1.0` thành `0.1.1` đóng gói và deploy chaart `0.1.1`. Chạy lại `helm ls` để show 2 packages của `testapi` được deployed:
```sh
apiVersion: v1
appVersion: "1.0"
description: A Helm chart for Kubernetes
name: testapi-chart
version: 0.1.1
```
```sh
[root@server01 testapi]# helm package testapi-chart --debug
Successfully packaged chart and saved it to: /root/testapi/testapi-chart-0.1.1.tgz
[debug] Successfully saved /root/testapi/testapi-chart-0.1.1.tgz to /root/.helm/repository/local
------------------------------------------------------------------------------------------------
[root@server01 testapi]# helm install testapi-chart-0.1.1.tgz
NAME:   moldy-squid
LAST DEPLOYED: Wed Nov 20 15:15:32 2019
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Deployment
NAME                       AGE
moldy-squid-testapi-chart  0s

==> v1/Pod(related)
NAME                                        AGE
moldy-squid-testapi-chart-7d8d7d67c5-rkzpq  0s

==> v1/Service
NAME                       AGE
moldy-squid-testapi-chart  0s

==> v1/ServiceAccount
NAME                       AGE
moldy-squid-testapi-chart  0s


NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=testapi-chart,app.kubernetes.io/instance=moldy-squid" -o jsonpath="{.items[0].metadata.name}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl port-forward $POD_NAME 8080:80
```
Confirm lại việc `testapi` được deployed và có 2 versions đang chạy:
```sh
[root@server01 testapi]# kubectl get deployments
NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
hasty-ferret-testapi-chart   1/1     1            1           3m4s
moldy-squid-testapi-chart    1/1     1            1           40s
```
Thực hiện xóa version cũ:
```sh
[root@server01 testapi]# helm delete hasty-ferret
release "hasty-ferret" deleted
```
Confirm lại với `kubectl get deployments` xem nó đã thực sự removed chưa:
```sh
[root@server01 testapi]# kubectl get deployments
NAME                        READY   UP-TO-DATE   AVAILABLE   AGE
moldy-squid-testapi-chart   1/1     1            1           103s
```
Nếu muốn quay lại version cũ thực hiện rollback như sau:
```sh
[root@server01 testapi]# helm rollback hasty-ferret 1
Rollback was a success.
```
Nếu không nhớ tên của package đã deleted hoăc muốn xem tất cả packages đã deleted:
```
[root@server01 testapi]# helm ls --deleted
NAME            REVISION        UPDATED                         STATUS  CHART                   APP VERSION     NAMESPACE
flabby-zorse    1               Wed Nov 20 14:29:16 2019        DELETED testapi-chart-0.1.0     1.0             default
gone-turtle     1               Wed Nov 20 14:25:28 2019        DELETED testapi-chart-0.1.0     1.0             default
```
Thêm flag `-d` để hiển thị theo thời gian.

Khi muốn upgrade 1 bản release, ta sửa file `Chart.yaml` thay đổi `Description` và `version number` sau đó dùng lệnh `helm upgrad name_package` thay đi đóng gọi lại.
```sh
[root@server01 testapi-chart]# vim Chart.yaml
apiVersion: v1
appVersion: "1.0"
description: A Helm chart for Kubernetes update
name: testapi-chart
version: 0.1.2
```
```sh
[root@server01 testapi-chart]# helm upgrade hasty-ferret .
Release "hasty-ferret" has been upgraded.
LAST DEPLOYED: Wed Nov 20 15:31:17 2019
NAMESPACE: default
STATUS: DEPLOYED

RESOURCES:
==> v1/Deployment
NAME                        AGE
hasty-ferret-testapi-chart  13m

==> v1/Pod(related)
NAME                                         AGE
hasty-ferret-testapi-chart-5cb469cd59-wdds7  13m

==> v1/Service
NAME                        AGE
hasty-ferret-testapi-chart  13m

==> v1/ServiceAccount
NAME                        AGE
hasty-ferret-testapi-chart  13m


NOTES:
1. Get the application URL by running these commands:
  export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=testapi-chart,app.kubernetes.io/instance=hasty-ferret" -o jsonpath="{.items[0].metadata.name}")
  echo "Visit http://127.0.0.1:8080 to use your application"
  kubectl port-forward $POD_NAME 8080:80
```
Thực hiện check `helm ls` để thấy version mới của `hasty-ferret` và tất nhiên vẫn có thể `rollback` lại bản release trước.
```sh
[root@server01 testapi-chart]# helm ls
NAME            REVISION        UPDATED                         STATUS          CHART                   APP VERSION     NAMESPACE
hasty-ferret    3               Wed Nov 20 15:31:17 2019        DEPLOYED        testapi-chart-0.1.2     1.0             default
moldy-squid     1               Wed Nov 20 15:15:32 2019        DEPLOYED        testapi-chart-0.1.1     1.0             default
```
## Tài liệu tham khảo
- https://daemonza.github.io/2017/02/20/using-helm-to-deploy-to-kubernetes/
