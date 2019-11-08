# Quản lý Resources trong container
- Khi chỉ định Pod có thể chỉ định tài nguyên CPU và RAM trên mỗi container. 
- Giới hạn Resource để tránh chanh chấp tài nguyên giữa các container.
- Mỗi Node có 1 lượng resource để cung cấp cho Pod. 
- Có 2 loài Resource là: CPU đơn vị là core và RAM đơn vị là byte

## Local ephemeral storage

Resource ephemeral-storage để quản lý local ephemeral storage. Trong mỗi Node, kubelet’s root directory mặc định `/var/lib/kubelet` và log directory `/var/log` được lưu trữ trong root partition của Node. Partition này chia sẻ và đươc Pod sử dụng thông qua `emptyDir volumes`, `container logs`, `image layers` và `container writable layers`.

Partition này `ephemeral` và ứng dụng không thể mong đợi bất kì performance SLAs (ví dụ: Disk IOPS) từ partition này. Local ephemeral storage management chỉ áp dụng cho root partition, partition tùy chọn cho image layer và writable layer nằm ngoài phạm vi.

***Nếu 1 optional runtime partition được sử dụng, root partition sẽ không giữa bất kỳ image layer hoặc writable layers.***

## Tài liệu tham khảo
- https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/
- https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/memory-default-namespace/
