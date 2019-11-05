# ReplicaSets - StatefulSets - DaemonSets
## ReplicaSets
- ReplicaSet tạo và quản lý Pods. Nếu 1 Pod shutdown trên 1 Node fails, ReplicaSet tự động thay thế Pod trên Node khác. 
- Nên tạo ReplicaSet thông qua Deployment hơn là tạo trực tiếp để có thể dễ dàng update app với Deployment.
## StatefulSets
- Giống ReplicaSets, StatefulSet quản lý việc deployment và scaling 1 nhóm Pods dựa trên container spec. 
- Không giống như Deployment, StatefulSet’s Pods không hoán đổi. Pod có ID duy nhất để controller duy trì rescheduling. 
- StatefulSets tốt cho khả năng duy trì, stateful backends giống như databases.
- Thông tin tráng thái Pod được lưu trung Volume liên kết với StatefulSet. 
## DaemonSet
- DaemonSets là cho continuous process. Khi chạy 1 Pod trêm 1 Node. Mỡi Node mới thêm vào tự động started bới DaemonSet.
- DaemonSets hữu ích cho task chạy background như monitoring và thu thập log.

***StatefulSets và DaemonSets ngang cấp với ReplicaSets nhưng không được quản lý bởi Deployment.***
