# Helm repository

Sử dụng `Helmet` như 1 helm repository, thực hiện deploy tới Kubernetes cluster và thên 1 chart. Và dĩ nhiên có thể deploy `Helmet` with Helm.
```sh
[root@server01 ~]# git clone https://github.com/daemonza/helmet.git; cd helmet/helmet-chart
Cloning into 'helmet'...
remote: Enumerating objects: 40, done.
remote: Total 40 (delta 0), reused 0 (delta 0), pack-reused 40
Unpacking objects: 100% (40/40), done.
[root@server01 helmet-chart]#
```
```sh
[root@server01 helmet-chart]# helm package . --debug
Successfully packaged chart and saved it to: /root/helmet/helmet-chart/helmet-chart-0.0.1.tgz
[debug] Successfully saved /root/helmet/helmet-chart/helmet-chart-0.0.1.tgz to /root/.helm/repository/local
```
Gói `helmet-chart-0.0.1.tgz` được tạo ra:
```sh
[root@server01 helmet-chart]# ls
Chart.yaml  helmet-chart-0.0.1.tgz  templates  values.yaml
```
Thực hiện deploy:
```sh
helm install helmet-chart-0.0.1.tgz --debug
```




## Tài liệu tham khảo
- https://daemonza.github.io/2017/02/20/using-helm-to-deploy-to-kubernetes/
