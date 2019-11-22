# ConfigMap
ConfigMaps cho phép tách cấu hình từ nội dung image để giữ các ứng dụng đóng gói có tính di dộng.

**Cách hoạt động**

- Đầu tiên bạn có nhiều ConfigMaps cho môi trường khác nhau
- ConfigMap được tạo và thêm vào Kubernetes cluster.
- Containers trong Pod tham khảo ConfigMap và sử dụng values của nó.

<img src=https://i.imgur.com/tOOg8hx.gif>

## 1. Tạo ConfigMap
Có thể sử dụng `kubectl create configmap` hoặc 1 ConfigMap generator trong `kustomization.yaml` để tạo ConfigMap
### 1.1 Sử dụng `kubectl create configmap`
Sử dụng `kubectl create configmap` để tạo `configmaps` từ `directories`, `files`, hoặc `literal values`:
```sh
kubectl create configmap <map-name> <data-source>
```
Trong đó: 
- `<map-name>:` tên gán cho ConfigMap
- `<data-source>:` là `directory`, `file`, `literal value` lấy dữ liệu.

Data source tương ứng với cặp key-value trong ConfigMap
Trong đó: 
- key = file name hoặc key cung cấp trong command line
- value = file contents hoặc literal value cung cấp trong command line.

Có thể sử dụng `kubectl describe` hoặc `kubectl get`  để lấy thông tin về 1 ConfigMap.

### 1.2 Define ConfigMap trong file YAML.
Tạo file `config-map.yaml` 
```sh
kind: ConfigMap 
apiVersion: v1 
metadata:
  name: example-configmap 
data:
  # Configuration values can be set as key-value properties
  database: mongodb
  database_uri: mongodb://localhost:27017
  
  # Or set as complete file contents (even JSON!)
  keys: | 
    image.public.key=771 
    rsa.public.key=42
```
Tạo `ConfigMap` sử dụng lệnh:
```sh
kubectl apply -f config-map.yaml
```
### 1.3 Mount ConfigMap thông qua Volume

Mỗi trên thuộc tính trong `ConfigMap` sẽ thành 1 file mới trong thư mục được mount`/etc/config`.

Tạo file `pod.yaml` với nội dung sau:
```sh
kind: Pod 
apiVersion: v1 
metadata:
  name: pod-using-configmap 

spec:
  # Thêm ConfigMap như 1 volume đến Pod
  volumes:
    # 'name' phải khớp với 'name' chỉ định trong volume mount
    - name: example-configmap-volume
      # Populate the volume with config map data
      configMap:
        # 'name' phải khớp với 'name' được chỉ định trong 'ConfigMap' 
        name: example-configmap

  containers:
    - name: container-configmap
      image: nginx:1.7.9
      # Mount the volume chứa configuration data đến container filesystem của bạn
      volumeMounts:
        # 'name' phải khớp với 'name' từ 'volumes' section của pod này
        - name: example-configmap-volume
            mountPath: /etc/config
```
Attach vào Pod được tạo sử dụng
```sh
kubectl exec -it pod-using-configmap sh
```
Sau đó chạy lệnh:
```sh
ls /etc/config
```
Có thể thấy mỗi key từ `ConfigMap` được thêm vào như 1 file trong thư mục. Sử dụng `cat` để xem nội dung của mỗi file và sẽ thấy các values từ `ConfigMap`.

## 1.4 Sử dụng COnfigMap với biến môi trường và `envFrom`

**Thêm `envFrom` vào Pod**
```sh
kind: Pod 
apiVersion: v1 
metadata:
  name: pod-env-var 
spec:
  containers:
    - name: env-var-configmap
      image: nginx:1.7.9 
      envFrom:
        - configMapRef:
            name: example-configmap
```
Attach để tạo Pod sử dụng `kubectl exec -it pod-env-var sh`. Sau đó chạy `env` và thấy rằng mỗi key trong ConfigMap đã available như biến môi trường.

**Có 3 cách tạo ConfigMaps sử dụng `kubectl create configmap`.**
- Sử dụng toàn bộ nội dung bên trong thư mục: `kubectl create configmap my-config --from-file=./my/dir/path/`
- Sử dụng nội dung của file chỉ định: `kubectl create configmap my-config --from-file=./my/file.txt`
- Sử dụng các cặp key-value: `kubectl create configmap my-config --from-literal=key1=value1 --from-literal=key2=value2`


## Tài liệu tham khảo
- https://matthewpalmer.net/kubernetes-app-developer/articles/ultimate-configmap-guide-kubernetes.html
