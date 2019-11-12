# Scheduler
Để đảm bảo performance và availability, scheduler sử dụng thuật toán phức tạp để đảm bảo hiểu quả khi triển khai Pods.

Khi chọn Node, scheduler kiểm tra trên mỗi Node xem có thể chưa Pods hay không. Nếu đã khai báo CPU và RAM yêu cầu. Scheduler tính toán như sau: 

**Usable memory = available memory - reserved memory**

`reserved memory`: 
- RAM được sử dụng bởi Kubernetes daemons như kubelet, containerd (hoặc container runtime khác).
- RAM được sử dụng bởi Node’s operating system. Ví dụ như kernel daemons.
By using this equation, the scheduler ensures that no resource starvation occurs on the node as a result of too many Pods competing to consume all the node’s available resources.

**Mặc định quá trình lặp lịch cho Pod trên Node được thực hiện như sau:**

- Scheduler tím kiếm Pod mới được tạo và chưa được gán cho Node nào.
- Kiểm tra các yêu cầu của Pod sau đó sắp xếp các Node không phù hợp.
- Sắp xếp các Node từ cao xuống thấp.
- Chọn Node đầu tiên trong danh sách và gán Pod cho nó.

**Trường hợp muốn chỉ định Node chạy Pod dựa vào 1 số tham số sau:**

**Node name**
```sh
apiVersion: v1
kind: Pod
metadata:
 name: nginx
spec:
 containers:
 - name: nginx
   image: nginx
 nodeName: app-prod01
```
***Chú ý khi Node có hostname bị thay đổi, không đủ tài nguyên chạy Pod***

**Node selector**
```sh
apiVersion: v1
kind: Pod
metadata:
 name: db
spec:
 containers:
 - name: mongodb
   image: mongo
 nodeSelector:
   disktype: ssd
```
Chỉ Node có label `disktype=ssd` được xem xét khi gan Pod

**Node Affinity** 

Cho phép linh hoạt hơn trong việc chọn Node với các yêu cầu cứng và mềm. Các điều kiện cứng phải khớp với Node được chọn trong khi các điều kiện mềm cho phép tăng độ ưu tiên hơn so với Node chỉ có điều kiện cứng.

Xem xét ví dụ sau: 
```sh
apiVersion: v1
kind: Pod
metadata:
 name: db
spec:
 affinity:
   nodeAffinity:
     requiredDuringSchedulingIgnoredDuringExecution:
       nodeSelectorTerms:
       - matchExpressions:
         - key: disk-type
           operator: In
           values:
           - ssd
     preferredDuringSchedulingIgnoredDuringExecution:
     - weight: 1
       preference:
         matchExpressions:
         - key: zone
           operator: In
           values:
           - zone1
           - zone2
 containers:
 - name: db
   image: mongo
```
- `requiredDuringSchedulingIgnoredDuringExecution`: Node phải có `disk-type=ssd` để xem xét triển khai DB Pod.
- `preferredDuringSchedulingIgnoredDuringExecution`: Khi sắp xếp các Node, độ ưu tiên cao hơn cho Node có labels `zone=zone1` hoặc `zone=zone2`. `weight` từ 1 đến 100, `weight` càng cao thì đồ ưu tiên càng cao.

Trong ví dụ sử dụng `In`xác định nhiều hơn 1 label, bất kỳ label tồn tại sẽ thỏa mãn. `NotIn`, `Exists`, `DoesNotExists`, `Lt` (less than), và `Gt` (greater than). `NotIn` và `DoesNotExist` là **Node Anti-Affinity**.

**Pod Affinity**

Được sử dụng khi: 
- Cần tất cả Pods đặt trên cùng 1 Node 
- Tăng security 

Về cơ bản tương tư như đối với Node. Xem xét ví dụ sau:
```sh
apiVersion: v1
kind: Pod
metadata:
 name: middleware
spec:
 affinity:
   podAffinity:
     requiredDuringSchedulingIgnoredDuringExecution:
     - labelSelector:
         matchExpressions:
         - key: role
           operator: In
           values:
           - frontend
       topologyKey: kubernetes.io/hostname
   podAntiAffinity:
     preferredDuringSchedulingIgnoredDuringExecution:
     - weight: 100
       podAffinityTerm:
         labelSelector:
           matchExpressions:
           - key: role
             operator: In
             values:
             - auth
         topologyKey: kubernetes.io/hostname
 containers:
 - name: middleware
   image: redis
```
- `requiredDuringSchedulingIgnoredDuringExecution`: Pod được lên lịch trên Node có nhãn `app-frontend`.
- `preferredDuringSchedulingIgnoredDuringExecution`: Pod không nên nhưng có thể được lên lịch trên nodes đang chạy Pods có labeled `role=auth`. (***Chú ý ở đây là `AntiAffinity`)
- `topologyKey` đưa ra quyết định cụ thể hơn để áp dụng rule cho domain nào. `topologyKey` chấp nhận label phải có trên Node để được xem xét khi lựa chọn.

## Ghi chú về `IgnoredDuringExecution`

## Tài liệu tham khảo
- https://www.magalix.com/blog/influencing-kubernetes-scheduler-decisions




