apiVersion: v1
kind: Service
metadata:
  name: mywebservice
spec:
  selector:
    app: nginx-green
  ports:
  - port: 80
    targetPort: 80
  type: NodePort
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sample-deployment-green
spec:
  replicas: 4
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: nginx-green
  template:
    metadata:
      labels:
        app: nginx-green
    spec:
      containers:
        - name: nginx-container
          image: nginx:1.12
          ports:
            - containerPort: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sample-deployment-blue
spec:
  replicas: 4
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: nginx-blue
  template:
    metadata:
      labels:
        app: nginx-blue
    spec:
      containers:
        - name: nginx-container
          image: nginx:1.13
          ports:
            - containerPort: 80
