# OverlayFS và AUFS
## 1. OverlayFS
### 1.1 Overlay2

Các thư mục này được gọi là các layer và tiến trình hợp nhất được gọi là union mount. OverlayFS đề cập đến thư mục thấp hơn là `lowerdir` và thư mục cao hơn là `Upperdir`. Chế độ xem thống nhất được hiển thị thông qua thư mục riêng được gọi là `merged`.

Overlay2 hỗ trợ tối đa 128 OverlayFS layer. Khả năng này cung cấp hiệu suất tốt hơn cho các lệnh Docker liên quan đến layer Docker build và Docker commit và tiêu thụ ít inodes hơn trên backing filesystem.

**Image-layer và container-layes trên disk**

Sau khi download 1 image có 5 layer bằng cách sử dụng `docker pull ubuntu`, bạn có thể thấy sáu thư mục trong `/var/lib/docker/overlay2`.
```sh
ls -l /var/lib/docker/overlay2

total 24
drwx------ 5 root root 4096 Jun 20 07:36 223c2864175491657d238e2664251df13b63adb8d050924fd1bfcdb278b866f7
drwx------ 3 root root 4096 Jun 20 07:36 3a36935c9df35472229c57f4a27105a136f5e4dbef0f87905b2e506e494e348b
drwx------ 5 root root 4096 Jun 20 07:36 4e9fa83caff3e8f4cc83693fa407a4a9fac9573deaf481506c102d484dd1e6a1
drwx------ 5 root root 4096 Jun 20 07:36 e8876a226237217ec61c4baf238a32992291d059fdac95ed6303bdff3f59cff5
drwx------ 5 root root 4096 Jun 20 07:36 eca1e4e1694283e001f200a667bb3cb40853cf2d1b12c29feda7422fed78afed
drwx------ 2 root root 4096 Jun 20 07:36 l
```
Thư mục `l` mới chứa các định danh layer rút ngắn làm symbolic links. Các mã định danh này được sử dụng để tránh nhấn vào giới hạn kích thước trang trên các đối số đối với lệnh mount.
```sh
ls -l /var/lib/docker/overlay2/l

total 20
lrwxrwxrwx 1 root root 72 Jun 20 07:36 6Y5IM2XC7TSNIJZZFLJCS6I4I4 -> ../3a36935c9df35472229c57f4a27105a136f5e4dbef0f87905b2e506e494e348b/diff
lrwxrwxrwx 1 root root 72 Jun 20 07:36 B3WWEFKBG3PLLV737KZFIASSW7 -> ../4e9fa83caff3e8f4cc83693fa407a4a9fac9573deaf481506c102d484dd1e6a1/diff
lrwxrwxrwx 1 root root 72 Jun 20 07:36 JEYMODZYFCZFYSDABYXD5MF6YO -> ../eca1e4e1694283e001f200a667bb3cb40853cf2d1b12c29feda7422fed78afed/diff
lrwxrwxrwx 1 root root 72 Jun 20 07:36 NFYKDW6APBCCUCTOUSYDH4DXAT -> ../223c2864175491657d238e2664251df13b63adb8d050924fd1bfcdb278b866f7/diff
lrwxrwxrwx 1 root root 72 Jun 20 07:36 UL2MW33MSE3Q5VYIKBRN4ZAGQP -> ../e8876a226237217ec61c4baf238a32992291d059fdac95ed6303bdff3f59cff5/diff
```

## Tài liệu tham khảo
- https://docs.docker.com/storage/storagedriver/overlayfs-driver/
- https://docs.docker.com/storage/storagedriver/aufs-driver/
