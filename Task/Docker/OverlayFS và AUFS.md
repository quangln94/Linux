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
Layer thấp nhất chứa một file gọi là link, chứa tên của mã định danh được rút ngắn và một file có tên là diff chứa nội dung layer.
```sh
ls /var/lib/docker/overlay2/3a36935c9df35472229c57f4a27105a136f5e4dbef0f87905b2e506e494e348b/
diff  link
```
```sh
cat /var/lib/docker/overlay2/3a36935c9df35472229c57f4a27105a136f5e4dbef0f87905b2e506e494e348b/link
6Y5IM2XC7TSNIJZZFLJCS6I4I4
```
```sh
ls  /var/lib/docker/overlay2/3a36935c9df35472229c57f4a27105a136f5e4dbef0f87905b2e506e494e348b/diff
bin  boot  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
```

Lớp thấp thứ hai và mỗi lớp cao hơn chứa một file gọi là lower, biểu thị cha mẹ của nó và một file có tên diff chứa nội dung của nó. Nó cũng chứa một file `merged`, chứa các nội dung hợp nhất của lớp cha và chính nó, và một file `word` được sử dụng bên trong bởi OverlayFS.

```sh
ls /var/lib/docker/overlay2/223c2864175491657d238e2664251df13b63adb8d050924fd1bfcdb278b866f7
diff  link  lower  merged  work
```
```sh
cat /var/lib/docker/overlay2/223c2864175491657d238e2664251df13b63adb8d050924fd1bfcdb278b866f7/lower
l/6Y5IM2XC7TSNIJZZFLJCS6I4I4
```
```sh
ls /var/lib/docker/overlay2/223c2864175491657d238e2664251df13b63adb8d050924fd1bfcdb278b866f7/diff/
etc  sbin  usr  var
```

Để xem các `mount` tồn tại khi bạn sử dụng overlay storage driver với Docker, hãy sử dụng lệnh `mount`.
```sh
mount | grep overlay

overlay on /var/lib/docker/overlay2/9186877cdf386d0a3b016149cf30c208f326dca307529e646afce5b3f83f5304/merged
type overlay (rw,relatime,
lowerdir=l/DJA75GUWHWG7EWICFYX54FIOVT:l/B3WWEFKBG3PLLV737KZFIASSW7:l/JEYMODZYFCZFYSDABYXD5MF6YO:l/UL2MW33MSE3Q5VYIKBRN4ZAGQP:l/NFYKDW6APBCCUCTOUSYDH4DXAT:l/6Y5IM2XC7TSNIJZZFLJCS6I4I4,
upperdir=9186877cdf386d0a3b016149cf30c208f326dca307529e646afce5b3f83f5304/diff,
workdir=9186877cdf386d0a3b016149cf30c208f326dca307529e646afce5b3f83f5304/work)
```
`rw` trên dòng thứ hai cho thấy `overlay` mount là read-write

### 1.1 Overlay

Sơ đồ dưới đây cho thấy cách Docker-image layer và Docker-container layer được xếp. Image-layer là `lowerdir` và container-layer là `upprerdir`. Khung nhìn hợp nhất được thể hiện thông qua một thư mục được gọi là `merged`, đó là containers mount point. Sơ đồ cho thấy cách Docker xây dựng bản đồ cho các cấu trúc OverlayFS.

<img src=https://i.imgur.com/xZqnMRm.png>

Trong đó image-layer và container-layer chứa cùng một file, container-layer che khuất sự tồn tại của file trên image-layer.

Overlay driver chỉ hoạt động với hai layer. Điều này có nghĩa là image nhiều lớp không thể được triển khai dưới dạng nhiều layer OverlayFS. Thay vào đó, mỗi image-layer được triển khai như thư mục riêng của nó trong `/var/lib/docker/overlay`. Hard links sau đó được sử dụng một cách hiệu quả về không gian để tham chiếu dữ liệu được chia sẻ với các lớp thấp hơn. Việc sử dụng Hard links gây ra việc sử dụng quá nhiều inodes, đó là một hạn chế đã biết của overlay storage driver và có thể yêu cầu cấu hình bổ sung backing filesystem. 

Để tạo một container, overlay driver kết hợp thư mục đại diện cho lớp trên cùng image cộng với một thư mục mới cho container. Lớp trên cùng của image là lowerdirvtrong overlay và chỉ đọc. Thư mục mới cho container là `Upperdir` và có thể ghi.

## Tài liệu tham khảo
- https://docs.docker.com/storage/storagedriver/overlayfs-driver/
- https://docs.docker.com/storage/storagedriver/aufs-driver/
