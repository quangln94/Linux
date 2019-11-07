**Chỉnh sử file `nginx_deployment_stable.yaml` với nội dung sau:**
```sh
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sample-deployment-stable
spec:
  replicas: 6
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx-container
          image: nginx:1.12
          ports:
            - containerPort: 80
```
**Chỉnh sửa file `nginx_deployment_canary.yaml` với nội dung sau:**
```sh
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sample-deployment-canary
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
    spec:
      containers:
        - name: nginx-container
          image: nginx:1.13
          ports:
            - containerPort: 80
```
**Chỉnh sửa file `nginx_service_canary.yaml` với nội dung sau:**
```sh
apiVersion: v1
kind: Service
metadata:
  name: mywebservice
spec:
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
  type: NodePort
  ```
  
