# Rolling Update
## Sử dụng RoolingUpdate để cập nhật version
**Bước 1: Tạo file `sample-fixed-strategy.yml` với nội dung như sau:**
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
          image: nginx:1.12       # Version ban đầu
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

**Sửa file `sample-fixed-strategy.yml` để nâng cập nhật image như sau:
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
          image: nginx:1.13       # Version mới
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
```sh
[root@server01 ~]# kubectl apply -f sample-fixed-strategy.yml
[root@server01 ~]# kubectl get pods
NAME                                     READY   STATUS        RESTARTS   AGE
sample-fixed-strategy-7468bd7c5f-p85nc   1/1     Running             0          6m12s
sample-fixed-strategy-7468bd7c5f-tdsck   0/1     Terminating         0          6m11s
sample-fixed-strategy-7468bd7c5f-tvx4c   1/1     Terminating         0          6m12s
sample-fixed-strategy-7468bd7c5f-w2v7p   1/1     Terminating         0          6m11s
sample-fixed-strategy-f969b9b5b-55cfz    0/1     ContainerCreating   0          0s
sample-fixed-strategy-f969b9b5b-5bjsh    1/1     Running             0          2s
sample-fixed-strategy-f969b9b5b-8qvjc    1/1     Running             0          2s
sample-fixed-strategy-f969b9b5b-np2lx    0/1     ContainerCreating   0          0s

[root@server01 ~]# kubectl get pods
NAME                                     READY   STATUS        RESTARTS   AGE
sample-fixed-strategy-7468bd7c5f-p85nc   1/1     Running       0          8s
sample-fixed-strategy-7468bd7c5f-tdsck   1/1     Running       0          7s
sample-fixed-strategy-7468bd7c5f-tvx4c   1/1     Running       0          8s
sample-fixed-strategy-7468bd7c5f-w2v7p   1/1     Running       0          7s
sample-fixed-strategy-f969b9b5b-9bn5r    0/1     Terminating   0          12m
sample-fixed-strategy-f969b9b5b-sfwtv    0/1     Terminating   0          12m
[root@server01 ~]# kubectl get pods
NAME                                     READY   STATUS    RESTARTS   AGE
sample-fixed-strategy-7468bd7c5f-p85nc   1/1     Running   0          9s
sample-fixed-strategy-7468bd7c5f-tdsck   1/1     Running   0          8s
sample-fixed-strategy-7468bd7c5f-tvx4c   1/1     Running   0          9s
sample-fixed-strategy-7468bd7c5f-w2v7p   1/1     Running   0          8s
```
- Có thể thấy RollingUpdate luôn duy trì đủ số Replica và sẽ lần lượt Update version trong quá trình update. TH này thường được dùng cho việc tung ra các bản update thử nghiệm chạy song song với bản hiện tại để đưa ra 1 bản update chính thức. 
- Nếu thay `.strategy.type: RollingUpdate` bằng `.strategy.type: Recreate` thì sẽ xóa toàn bộ Replicate cũ và thay bằng Replicate mới. TH này thường được sử dụng cho việc thay đổi ứng dụng do có lỗ hổng.
 
## Tài liệu tham khảo
- https://blog.vietnamlab.vn/2019/11/05/kubernetes-best-pratice-zero-downtime-rolling-update/
