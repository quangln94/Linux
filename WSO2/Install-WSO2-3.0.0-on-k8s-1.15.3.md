**Mô hình LAB**

|Server|IP|
|------|--|
|master1|10.1.38.128|
|master2|10.1.38.111|
|master3|10.1.38.149|
|worker1|10.1.38.144|
|worker2|10.1.38.146|
|mysql|10.1.38.147|
|NFS|10.1.38.129|

## 1. Thực hiện trên NFS
**Tạo thư mục chia sẻ trên NFS**
```sh
mkdir -p /data/wso2/worker
mkdir -p /data/wso2/dashboard
mkdir -p /data/wso2/apim
```
## 1. Thực hiện trên Node Master
**Tạo 3 file cho 3 serice: `am-analytics-worker.yaml`, `api-manager`, `am-analytics-dashboard`.**

**Tạo file `am-analytics-worker.yaml` với nội dung gồm các đoạn sau:**
```sh
apiVersion: v1
kind: PersistentVolume
metadata:
  name: am-analytics-worker-nfs-pv-log
  namespace: wso2
  labels:
    storage: am-analytics-worker-nfs-pv-log
spec:
  storageClassName: nfs-volume
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Recycle
  nfs:
    server: 10.1.38.129
    path: "/data/wso2/worker"
```
Trong đó: 
- `metadata.name`: Tên của `pv`, ở đây là `am-analytics-worker-nfs-pv-log`
- `metadata.labels`: Label của `pv`, ở đây là `storage: am-analytics-worker-nfs-pv-log`
- `spec.nfs.server`: Đia chỉ IP của NFS, ở đây là `10.1.38.129`
- `spec.nfs.path`: Thư mục chi sẻ trên NFS server, ở đây là `/data/wso2/worker`

**File `PersistentVolumeClaim`**:
```sh
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: am-analytics-worker-nfs-pvc-log
  namespace: wso2
spec:
  storageClassName: nfs-volume
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 2Gi
  selector:
    matchLabels:
      storage: am-analytics-worker-nfs-pv-log
```     
Trong đó:
- `spec.selector.matchLabels.storage`: Khớp với `metadata.labels` của `pv`, ở dây là `am-analytics-worker-nfs-pv-log`

**Tạo `Deployment` với nội dung sau:**
```sh
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: am-analytics-worker-nfs-pvc-log
  namespace: wso2
spec:
  storageClassName: nfs-volume
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 2Gi
  selector:
    matchLabels:
      storage: am-analytics-worker-nfs-pv-log
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: am-analytics-worker-deployment
  namespace: wso2
  labels:
    app: am-analytics-worker
    role: am-analytics-worker
spec:
  selector:
    matchLabels:
      app: am-analytics-worker
      role: am-analytics-worker
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 0
  minReadySeconds: 120
  template:
    metadata:
      labels:
        app: am-analytics-worker
        role: am-analytics-worker
    spec:
      containers:
      - name: am-analytics-worker
        image: wso2/wso2am-analytics-worker:3.0.0
        ports:
        - containerPort: 9091
          name: port1
        - containerPort: 9444
          name: port2          
        resources:
          requests:
            cpu: "1000m"
            memory: "4096Mi"
          limits: 
            cpu: "1000m"
            memory: "4096Mi"
        volumeMounts:
        - mountPath: /home/wso2carbon/wso2-config-volume
          name: am-analytics-worker-log
      volumes:
      - name: am-analytics-worker-log
        persistentVolumeClaim:
          claimName: am-analytics-worker-nfs-pvc-log
```          
**Paste tất cả các file trên thành 1 file `am-analytics-worker.yaml` như sau:
```sh
cat << EOF > am-analytics-worker.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: am-analytics-worker-nfs-pv-log
  namespace: wso2
  labels:
    storage: am-analytics-worker-nfs-pv-log
spec:
  storageClassName: nfs-volume
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Recycle
  nfs:
    server: 10.1.38.129
    path: "/data/wso2/worker"
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: am-analytics-worker-nfs-pvc-log
  namespace: wso2
spec:
  storageClassName: nfs-volume
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 2Gi
  selector:
    matchLabels:
      storage: am-analytics-worker-nfs-pv-log
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: am-analytics-worker-deployment
  namespace: wso2
  labels:
    app: am-analytics-worker
    role: am-analytics-worker
spec:
  selector:
    matchLabels:
      app: am-analytics-worker
      role: am-analytics-worker
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 0
  minReadySeconds: 120
  template:
    metadata:
      labels:
        app: am-analytics-worker
        role: am-analytics-worker
    spec:
      containers:
      - name: am-analytics-worker
        image: wso2/wso2am-analytics-worker:3.0.0
        ports:
        - containerPort: 9091
          name: port1
        - containerPort: 9444
          name: port2          
        resources:
          requests:
            cpu: "1000m"
            memory: "4096Mi"
          limits: 
            cpu: "1000m"
            memory: "4096Mi"
        volumeMounts:
        - mountPath: /home/wso2carbon/wso2-config-volume
          name: am-analytics-worker-log
      volumes:
      - name: am-analytics-worker-log
        persistentVolumeClaim:
          claimName: am-analytics-worker-nfs-pvc-log
---
apiVersion: autoscaling/v2beta1
kind: HorizontalPodAutoscaler
metadata:
  name: hpa-am-analytics-worker
  namespace: wso2
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: am-analytics-worker-deployment
# Số lượng Replicas tăng/giảm    
  minReplicas: 1
  maxReplicas: 1
  metrics:
  - type: Resource
# RAM lớn hơn 80% tăng Pod  
    resource:
      name: memory   
      targetAverageUtilization: 80
  - type: Resource
# CPU lớn hơn 80% tăng Pod  
    resource:
      name: cpu
      targetAverageUtilization: 80
---
# Deploy service để truy cập từ bên ngoài
apiVersion: v1
kind: Service
metadata:
  name: am-analytics-worker
  namespace: wso2
spec:
  type: NodePort
  ports:
# Expose Port để truy cập
  - port: 9091
    name: port1
    nodePort: 31122
# Expose Port để truy cập
  - port: 9444
    name: port2
    nodePort: 31123
  selector:
    app: am-analytics-worker
    role: am-analytics-worker
EOF
```
**Tạo file `api-manager.yaml` với nội dung sau:**
```sh
cat << EOF > api-manager.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: api-manager-nfs-pv-log
  namespace: wso2
  labels:
    storage: api-manager-nfs-pv-log
spec:
  storageClassName: nfs-volume
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Recycle
  nfs:
    server: 10.1.38.129
    path: "/data/wso2/apim"
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: api-manager-nfs-pvc-log
  namespace: wso2
spec:
  storageClassName: nfs-volume
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 2Gi
  selector:
    matchLabels:
      storage: api-manager-nfs-pv-log
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-manager-deployment
  namespace: wso2
  labels:
    app: api-manager
    role: api-manager
spec:
  selector:
    matchLabels:
      app: api-manager
      role: api-manager
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 0
  minReadySeconds: 120
  template:
    metadata:
      labels:
        app: api-manager
        role: api-manager
    spec:
      containers:
      - name: api-manager
        image: wso2/wso2am:3.0.0
        ports:
        - containerPort: 9763
          name: port1
        - containerPort: 9443
          name: port2
        - containerPort: 8280
          name: port3
        - containerPort: 8243
          name: port4
        resources:
          requests:
            cpu: "1000m"
            memory: "4096Mi"
          limits: 
            cpu: "1000m"
            memory: "4096Mi"
        volumeMounts:
        - mountPath: /home/wso2carbon/wso2-config-volume
          name: api-manager-log
        - mountPath: /home/wso2carbon/wso2-artifact-volume
          name: api-manager-log
      volumes:
      - name: api-manager-log
        persistentVolumeClaim:
          claimName: api-manager-nfs-pvc-log
---
apiVersion: autoscaling/v2beta1
kind: HorizontalPodAutoscaler
metadata:
  name: hpa-api-manager
  namespace: wso2
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: api-manager-deployment
  minReplicas: 1
  maxReplicas: 1
  metrics:
  - type: Resource
    resource:
      name: memory
      targetAverageUtilization: 80
  - type: Resource
    resource:
      name: cpu
      targetAverageUtilization: 80
---
apiVersion: v1
kind: Service
metadata:
  name: api-manager
  namespace: wso2
spec:
  type: NodePort
  ports:
  - port: 9763
    name: port1
    nodePort: 31124
  - port: 9443
    name: port2
    nodePort: 31125
  - port: 8280
    name: port3
    nodePort: 31126
  - port: 8243
    name: port4
    nodePort: 31127
  selector:
    app: api-manager
    role: api-manager
EOF
```
**Tạo file `am-analytics-dashboard.yaml` với nội dung sau:**
```sh
cat << EOF > am-analytics-dashboard.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: am-analytics-dashboard-nfs-pv-log
  namespace: wso2
  labels:
    storage: am-analytics-dashboard-nfs-pv-log
spec:
  storageClassName: nfs-volume
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Recycle
  nfs:
    server: 10.1.38.129
    path: "/data/wso2/dashboard"
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: am-analytics-dashboard-nfs-pvc-log
  namespace: wso2
spec:
  storageClassName: nfs-volume
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 2Gi
  selector:
    matchLabels:
      storage: am-analytics-dashboard-nfs-pv-log
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: am-analytics-dashboard-deployment
  namespace: wso2
  labels:
    app: am-analytics-dashboard
    role: am-analytics-dashboard
spec:
  selector:
    matchLabels:
      app: am-analytics-dashboard
      role: am-analytics-dashboard
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 0
  minReadySeconds: 120
  template:
    metadata:
      labels:
        app: am-analytics-dashboard
        role: am-analytics-dashboard
    spec:
      containers:
      - name: am-analytics-dashboard
        image: wso2/wso2am-analytics-dashboard:3.0.0
        ports:
        - containerPort: 9643
          name: port1
        resources:
          requests:
            cpu: "1000m"
            memory: "4096Mi"
          limits: 
            cpu: "1000m"
            memory: "4096Mi"
        volumeMounts:
        - mountPath: /home/wso2carbon/wso2-config-volume
          name: am-analytics-dashboard-log
        - mountPath: /home/wso2carbon/wso2-artifact-volume
          name: am-analytics-dashboard-log
      volumes:
      - name: am-analytics-dashboard-log
        persistentVolumeClaim:
          claimName: am-analytics-dashboard-nfs-pvc-log
---
apiVersion: autoscaling/v2beta1
kind: HorizontalPodAutoscaler
metadata:
  name: hpa-am-analytics-dashboard
  namespace: wso2
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: am-analytics-dashboard-deployment
  minReplicas: 1
  maxReplicas: 1
  metrics:
  - type: Resource
    resource:
      name: memory
      targetAverageUtilization: 80
  - type: Resource
    resource:
      name: cpu
      targetAverageUtilization: 80
---
apiVersion: v1
kind: Service
metadata:
  name: am-analytics-dashboard
  namespace: wso2
spec:
  type: NodePort
  ports:
  - port: 9643
    name: port1
    nodePort: 31128
  selector:
    app: am-analytics-dashboard
    role: am-analytics-dashboard
EOF
```
## 2. Thực hiện deploy các `service`, `deployment`, `hpa`, `pv`, `pvc` vừa tạo như sau:
Tạo Namespace `wso2`
```sh
kubectl create namespace wso2
```
Thực hiện `deploy`, `service`, `deployment`, `hpa`, `pv`, `pvc`
```sh
kubectl apply -f am-analytics-dashboard.yaml
kubectl apply -f api-manager.yaml
kubectl apply -f am-analytics-worker.yaml
```
