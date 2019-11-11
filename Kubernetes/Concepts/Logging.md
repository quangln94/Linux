# Kubernetes Logging
## Cơ bản của Kubernetes Logging

Kubernetes khuyến nghị để output log của application tới stdout và stderr. Kubelet chạy ở mỗi Node sẽ thu thập segmented output logs và augment vào 1 singular log file. Automatically log files cho mỗi container sẽ được quản lý và giới hạn 10MB. Basic topology of how Kubernetes natively handles logs can be seen in below illustration.

Hình minh họa k8s xử lý log

<img src=https://i.imgur.com/HCO0VlB.png>


## Tài liệu tham khảo
- https://www.magalix.com/blog/kubernetes-logging-101
