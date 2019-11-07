# Rolling Update
## Sử dụng RoolingUpdate để cập nhật version
**Bước 1: Tạo file `deployment.yml` với nội dung như sau:**
```sh
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sample-fixed-strategy
spec:
  replicas: 4
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
  selector:
    matchLabels:
      app: fixed-strategy
  template:
    metadata:
      labels:
        app: fixed-strategy
    spec:
      containers:
        - name: nginx-container
          image: nginx:1.12
          ports:
            - containerPort: 80

---
apiVersion: v1
kind: Service
metadata:
  name: mywebservice
spec:
  selector:
    app: fixed-strategy
  ports:
  - port: 80
    targetPort: 80
  type: NodePort
  ```
**Thực hiện deploy app sau đó kiểm tra trạng thái**
```sh
[root@server01 ~]# kubectl apply -f sample-fixed-strategy.yml
[root@server01 ~]# kubectl get pods
NAME                                    READY   STATUS    RESTARTS   AGE
sample-fixed-strategy-f969b9b5b-62qf9   1/1     Running   0          12s
sample-fixed-strategy-f969b9b5b-9bn5r   1/1     Running   0          12s
sample-fixed-strategy-f969b9b5b-sfwtv   1/1     Running   0          11s
sample-fixed-strategy-f969b9b5b-wm4g2   1/1     Running   0          11s
```
**Bước 2: Nâng cấp version cho image sau đó thực hiện RollingUpdate**
**Sửa file `deployment.yml` để nâng cập nhật image như sau:
```sh
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sample-fixed-strategy
spec:
  replicas: 4
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
  selector:
    matchLabels:
      app: fixed-strategy
  template:
    metadata:
      labels:
        app: fixed-strategy
    spec:
      containers:
        - name: nginx-container
          image: nginx:1.13
          ports:
            - containerPort: 80

---
apiVersion: v1
kind: Service
metadata:
  name: mywebservice
spec:
  selector:
    app: fixed-strategy
  ports:
  - port: 80
    targetPort: 80
  type: NodePort
```
**Thực hiện deploy add và kiểm tra như sau:**
[root@server01 ~]# kubectl apply -f sample-fixed-strategy.yml
[root@server01 ~]# kubectl get pods
NAME                                     READY   STATUS        RESTARTS   AGE
sample-fixed-strategy-7468bd7c5f-p85nc   1/1     Running       0          5s
sample-fixed-strategy-7468bd7c5f-tdsck   1/1     Running       0          4s
sample-fixed-strategy-7468bd7c5f-tvx4c   1/1     Running       0          5s
sample-fixed-strategy-7468bd7c5f-w2v7p   1/1     Running       0          4s
sample-fixed-strategy-f969b9b5b-62qf9    0/1     Terminating   0          12m
sample-fixed-strategy-f969b9b5b-9bn5r    0/1     Terminating   0          12m
sample-fixed-strategy-f969b9b5b-sfwtv    0/1     Terminating   0          12m
sample-fixed-strategy-f969b9b5b-wm4g2    0/1     Terminating   0          12m
test-nginx-78bcf56566-6v8m7              1/1     Running       0          6d19h
test-nginx-78bcf56566-7sm5k              1/1     Running       0          2d1h
test-nginx-78bcf56566-gws67              1/1     Running       0          3d
test-nginx-78bcf56566-h6lzl              1/1     Running       0          6d19h
test-nginx-78bcf56566-n6jcr              1/1     Running       0          2d1h
[root@server01 ~]# kubectl get pods
NAME                                     READY   STATUS        RESTARTS   AGE
sample-fixed-strategy-7468bd7c5f-p85nc   1/1     Running       0          8s
sample-fixed-strategy-7468bd7c5f-tdsck   1/1     Running       0          7s
sample-fixed-strategy-7468bd7c5f-tvx4c   1/1     Running       0          8s
sample-fixed-strategy-7468bd7c5f-w2v7p   1/1     Running       0          7s
sample-fixed-strategy-f969b9b5b-9bn5r    0/1     Terminating   0          12m
sample-fixed-strategy-f969b9b5b-sfwtv    0/1     Terminating   0          12m
test-nginx-78bcf56566-6v8m7              1/1     Running       0          6d19h
test-nginx-78bcf56566-7sm5k              1/1     Running       0          2d1h
test-nginx-78bcf56566-gws67              1/1     Running       0          3d
test-nginx-78bcf56566-h6lzl              1/1     Running       0          6d19h
test-nginx-78bcf56566-n6jcr              1/1     Running       0          2d1h
[root@server01 ~]# kubectl get pods
NAME                                     READY   STATUS    RESTARTS   AGE
sample-fixed-strategy-7468bd7c5f-p85nc   1/1     Running   0          9s
sample-fixed-strategy-7468bd7c5f-tdsck   1/1     Running   0          8s
sample-fixed-strategy-7468bd7c5f-tvx4c   1/1     Running   0          9s
sample-fixed-strategy-7468bd7c5f-w2v7p   1/1     Running   0          8s
test-nginx-78bcf56566-6v8m7              1/1     Running   0          6d19h
test-nginx-78bcf56566-7sm5k              1/1     Running   0          2d1h
test-nginx-78bcf56566-gws67              1/1     Running   0          3d
test-nginx-78bcf56566-h6lzl              1/1     Running   0          6d19h
test-nginx-78bcf56566-n6jcr              1/1     Running   0          2d1h
```
***Có thể thấy RollingUpdate luôn duy trì đủ số Replica và sẽ lần lượt Update version trong quá trình update.***

## Tài liệu tham khảo
- https://blog.vietnamlab.vn/2019/11/05/kubernetes-best-pratice-zero-downtime-rolling-update/
