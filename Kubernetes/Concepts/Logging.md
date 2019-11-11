# Kubernetes Logging
## Cơ bản của Kubernetes Logging

Kubernetes khuyến nghị để output log của application tới stdout và stderr. Kubelet chạy ở mỗi Node sẽ thu thập segmented output logs và augment vào 1 singular log file. Automatically log files cho mỗi container sẽ được quản lý và giới hạn 10MB. Basic topology of how Kubernetes natively handles logs can be seen in below illustration.

Hình minh họa k8s xử lý log

<img src=https://i.imgur.com/HCO0VlB.png>

## Types of Logs

K8s có 2 loại logs chính: Node Logs và Component Logs. Node logs được tạo bời Nodes và services trên Nodes. Component logs được tạo bởi Pods, Containers, Kubernetes components, DaemonSets, và các Kubernetes Services khác.

Mỗi Nodes trong k8s chạy services cho phép tạo Pod cũng như nhận commands và giao tiếp với Node khác. How these logs are formatted and where they reside depend on the host operating system. On a Linux server for example you can retrieve the logs by running journalctl -u kubelet, however on other systems Kubernetes places the logs in the default /var/log directory.

Component logs được captured bới k8s và được truy cập bằng k8s API. Các ứng dụng sẽ viết tất cả các essages tới STDOUT hoặc STDERR.

## Log Viewing







## Tài liệu tham khảo
- https://www.magalix.com/blog/kubernetes-logging-101
