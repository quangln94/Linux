# Config map
ConfigMaps cho phép tách cấu hình từ nội dung image để giữ các ứng dụng đóng gói có tính di dộng.

<img src=https://matthewpalmer.net/kubernetes-app-developer/articles/configmap-diagram.gif>

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


## Tài liệu tham khảo
- https://matthewpalmer.net/kubernetes-app-developer/articles/ultimate-configmap-guide-kubernetes.html
