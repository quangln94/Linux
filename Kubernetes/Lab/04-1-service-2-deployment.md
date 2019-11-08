# Deploy 2 service sử dụng cùng 1 deployment
**Chỉnh sử file `nginx_deployment_1.yaml` với nội dung sau:**
```sh
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sample-deployment-1
spec:
  replicas: 3
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
        label: two
    spec:
      containers:
        - name: nginx-container
          image: nginx:1.12
          ports:
            - containerPort: 80
```
**Chỉnh sử file `nginx_deployment_2.yaml` với nội dung sau:**
```sh
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sample-deployment-2
spec:
  replicas: 3
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: nginx
      label: two
  template:
    metadata:
      labels:
        app: nginx
        label: two
    spec:
      containers:
        - name: nginx-container
          image: nginx:1.12
          ports:
            - containerPort: 80
```
**Chỉnh sửa file `nginx_service_1.yaml` với nội dung sau:**
```sh
apiVersion: v1
kind: Service
metadata:
  name: mywebservice
spec:
  selector:
    app: nginx
    label: two
  ports:
  - port: 80
    targetPort: 80
  type: NodePort
```
**Thực hiện deploy 2 app sử dụng cả 1 service**
```sh
kubectl apply -f nginx_deployment_1.yaml
kubectl apply -f nginx_deployment_2.yaml
kubectl apply -f nginx_service_1.yaml
```
**Kiểm tra service**
```sh
[root@server01 ~]# kubectl get svc
NAME             TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
kubernetes       ClusterIP   10.96.0.1        <none>        443/TCP        10h
mywebservice01   NodePort    10.106.147.245   <none>        80:32429/TCP   9h
```
- Có 1 `service` map với tất cả các pod

**Kiểm tra service sẽ được gán trên các Pod nào:
```sh
[root@server01 ~]# kubectl describe service mywebservice01
Name:                     mywebservice01
Namespace:                default
Labels:                   <none>
Annotations:              kubectl.kubernetes.io/last-applied-configuration:
                            {"apiVersion":"v1","kind":"Service","metadata":{"annotations":{},"name":"mywebservice01","namespace":"default"},"spec":{"ports":[{"port":8...
Selector:                 app=nginx,label=two
Type:                     NodePort
IP:                       10.104.82.188
Port:                     <unset>  80/TCP
TargetPort:               80/TCP
NodePort:                 <unset>  31216/TCP
Endpoints:                10.244.1.29:80,10.244.1.30:80,10.244.1.31:80 + 3 more...
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>
```
