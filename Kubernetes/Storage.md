# Storage

K8s hỗ trợ nhiều loại storage được gọi là volume
in your on-premises data center.
K8s có 1 persistent volume subsystem


Một số tính chất của PV trong file YAMLe.

`.spec.accessModesdefines` Cách PV mounted. Có 3 options:
- ReadWriteOnce(RWO): PV chỉ có thể mounted/bound như R/W bới 1 PVC đơn. Nhiều PVCs để bind (claim) nó sẽ fail.
- ReadWriteMany(RWM): Chỉ định 1 PV có thể bound như R/W bới multiple PVCs. Mode này thường chỉ được supported bởi file và object storage như NFS. Block storage thưởng chỉ supports RWO
- ReadOnlyMany(ROM): chỉ định 1 PV có thể bound bởi nhiều PVCs như R/O.

1 PV chỉ có thể được mở trong 1 Mode - không thể có 1 PV có PVC bound với nó trong Mode ROM và PVC khác bound với nó trong Mode RWM. Pods
không hành động trực tiếp trên PVs, chúng luôn hành dộng trên PVC object bound với PV.

`.spec.storageClassName` nói k8s nhóm PV này trong 1 storage class được gọi là `test`. 

`isspec.persistentVolumeReclaimPolicy` nói Kubernetes làm gì với 1 PV khi PVC đã được released. Hai policies đang có: 
- `Delete` là mặc định cho PVs được tạo tự động qua storage classes. Nó deletes PV và storage resource liên quan trên external storage system.
- `Retain` giữ PV object liên quan trên cluster cũng như bất kỳ data được lưu trữ trên external asset liên quan. Tuy nhiên nó sẽ ngăn chặn PVC khác sử dụng PV trong tương lai.

Nếu muốn sử dụng lại 1 retained PV thực hiện 3 bước như sau:
1. Manually delete the PV on Kubernetes
2. Re-format the associated storage asset on the external storage system to wipe any data
3. Recreate the PV

`.spec.capacity` nói Kubernetes PV nên lớn như thế nào. Giá trị này có thể nhỏ hơn giá trị thật nhưng không được lớn hơn.

Dòng cuối cùng links PV tới tên của device trên back-end. Có thể chỉ định nhà cunng cấp cụ thể sử dụng `.parameterssection`.

Tiếp theo tạo 1 PVC để 1 Pod có thể claim access tới storage.
```sh
$ vim gke-pvc.yml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
name: pvc1
spec:
accessModes:
- ReadWriteOnce
storageClassName: test
resources:
requests:
storage: 10Gi
```
