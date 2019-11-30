Chạy image `MariaDB` trên k8s. `image` cần 1 biến môi trường để set `MYSQL_ROOT_PASSWORD`, `MYSQL_ALLOW_EMPTY_PASSWORD`, hoặc `MYSQL_RANDOM_ROOT_PASSWORD` để khởi tạo database.

## 1. Tạo Secret 
Tạo `secret` chứa `MYSQL_ROOT_PASSWORD` đặt password và convert sang `base64`:
```sh
echo -n 'MYSQL_ROOT_PASSWORD' | base64
S3ViZXJuZXRlc1JvY2tzIQ==
```
Tạo file `mysql-secret.yaml` với nội dung sau:
```sh
$ vim mysql-secret.yaml

apiVersion: v1
kind: Secret
metadata:
  name: mariadb-root-password
type: Opaque
data:
  password: S3ViZXJuZXRlc1JvY2tzIQ==
```
Tạo `Secret` bằng lệnh sau:
```sh
$ kubectl apply -f mysql-secret.yaml
secret/mariadb-root-password created
```
Kiểm tra file vừa tạo:
```sh
$ kubectl describe secret mariadb-root-password
Name:         mariadb-root-password
Namespace:    secrets-and-configmaps
Labels:       <none>
Annotations:
Type:         Opaque

Data
====
password:  16 bytes
```
Tạo `MYSQL_USER` và `MYSQL_PASSWORD`
```sh
$ kubectl create secret generic mariadb-user-creds \
      --from-literal=MYSQL_USER=kubeuser\
      --from-literal=MYSQL_PASSWORD=kube-still-rocks
secret/mariadb-user-creds created
```
Kiểm tra lại 
```sh
$ kubectl get secret mariadb-user-creds -o jsonpath='{.data.MYSQL_USER}' | base64 --decode -
kubeuser

$ kubectl get secret mariadb-user-creds -o jsonpath='{.data.MYSQL_PASSWORD}' | base64 --decode -
kube-still-rocks
```
## 2. Tạo ConfigMap
Tạo file `max_allowed_packet.cnf` với nội dung sau:
```sh
[mysqld]
max_allowed_packet = 64M
```
Tạo file `configmap`:
```sh
$ kubectl create configmap mariadb-config --from-file=max_allowed_packet.cnf
configmap/mariadb-config created
```
Kiểm tra file vừa tạo
```sh
$ kubectl get configmap mariadb-config
NAME             DATA      AGE
mariadb-config   1         9m
```
```sh
$ kubectl describe cm mariadb-config
Name:         mariadb-config
Namespace:    secrets-and-configmaps
Labels:       <none>
Annotations:  <none>


Data
====
max_allowed_packet.cnf:
----
[mysqld]
max_allowed_packet = 64M

Events:  <none>
```
```sh
$ kubectl get configmap mariadb-config -o "jsonpath={.data['max_allowed_packet\.cnf']}"

[mysqld]
max_allowed_packet = 32M
```



## 3. Sử dụng Secrets và ConfigMaps
Tạo file `mariadb-deployment.yaml` với nội dung sau:
```sh
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: mariadb
  name: mariadb-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mariadb
  template:
    metadata:
      labels:
        app: mariadb
    spec:
      containers:
      - name: mariadb
        image: docker.io/mariadb:10.4
        env:                                       # Thêm biến môi trường từ đây
          - name: MYSQL_ROOT_PASSWORD              #############################
            valueFrom:                             #############################
              secretKeyRef:                        #############################
                name: mariadb-root-password        # secret
                key: password                      # pass trong secret
        envFrom:                                   # sử dụng envFrom
        - secretRef:                               #
            name: mariadb-user-creds               #
        ports:
        - containerPort: 3306
          protocol: TCP
#       volumeMounts:
#       - mountPath: /var/lib/mysql
#         name: mariadb-volume-1
#     volumes:
#     - emptyDir: {}
#       name: mariadb-volume-1
        volumeMounts:
        - mountPath: /var/lib/mysql
          name: mariadb-volume-1
        - mountPath: /etc/mysql/conf.d
          name: mariadb-config-volume
      volumes:
      - emptyDir: {}
        name: mariadb-volume-1
      - configMap:
          name: mariadb-config
          items:
            - key: max_allowed_packet.cnf
              path: max_allowed_packet.cnf
        name: mariadb-config-volume
```        
Create MariaDB instance
```sh
$ kubectl create -f mariadb-deployment.yaml
deployment.apps/mariadb-deployment created
```
## Tài liệu tham khảo
- https://opensource.com/article/19/6/introduction-kubernetes-secrets-and-configmaps
