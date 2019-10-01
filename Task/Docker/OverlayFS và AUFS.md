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

### 1.2 Overlay

Sơ đồ dưới đây cho thấy cách Docker-image layer và Docker-container layer được xếp. Image-layer là `lowerdir` và container-layer là `upprerdir`. Khung nhìn hợp nhất được thể hiện thông qua một thư mục được gọi là `merged`, đó là containers mount point. Sơ đồ cho thấy cách Docker xây dựng bản đồ cho các cấu trúc OverlayFS.

<img src=https://i.imgur.com/xZqnMRm.png>

Trong đó image-layer và container-layer chứa cùng một file, container-layer che khuất sự tồn tại của file trên image-layer.

Overlay driver chỉ hoạt động với hai layer. Điều này có nghĩa là image nhiều lớp không thể được triển khai dưới dạng nhiều layer OverlayFS. Thay vào đó, mỗi image-layer được triển khai như thư mục riêng của nó trong `/var/lib/docker/overlay`. Hard links sau đó được sử dụng một cách hiệu quả về không gian để tham chiếu dữ liệu được chia sẻ với các lớp thấp hơn. Việc sử dụng Hard links gây ra việc sử dụng quá nhiều inodes, đó là một hạn chế đã biết của overlay storage driver và có thể yêu cầu cấu hình bổ sung backing filesystem. 

Để tạo một container, overlay driver kết hợp thư mục đại diện cho lớp trên cùng image cộng với một thư mục mới cho container. Lớp trên cùng của image là lowerdirvtrong overlay và chỉ đọc. Thư mục mới cho container là `Upperdir` và có thể ghi.

**Image-layer và container-layes trên disk**

Sử dụng `docker pull` để kéo image gồm 5 layer.
```sh
docker pull ubuntu

Using default tag: latest
latest: Pulling from library/ubuntu

5ba4f30e5bea: Pull complete
9d7d19c9dc56: Pull complete
ac6ad7efd0f9: Pull complete
e7491a747824: Pull complete
a3ed95caeb02: Pull complete
Digest: sha256:46fb5d001b88ad904c5c732b086b596b92cfb4a4840a3abd0e35dbb6870585e4
Status: Downloaded newer image for ubuntu:latest
```
**Image-layer**
Mỗi image-layer có thư mục riêng trong `/var/lib/docker/overlay/`, chứa nội dung của nó và ID image-layerkhông tương ứng với ID thư mục
```sh
ls -l /var/lib/docker/overlay/

total 20
drwx------ 3 root root 4096 Jun 20 16:11 38f3ed2eac129654acef11c32670b534670c3a06e483fce313d72e3e0a15baa8
drwx------ 3 root root 4096 Jun 20 16:11 55f1e14c361b90570df46371b20ce6d480c434981cbda5fd68c6ff61aa0a5358
drwx------ 3 root root 4096 Jun 20 16:11 824c8a961a4f5e8fe4f4243dab57c5be798e7fd195f6d88ab06aea92ba931654
drwx------ 3 root root 4096 Jun 20 16:11 ad0fe55125ebf599da124da175174a4b8c1878afe6907bf7c78570341f308461
drwx------ 3 root root 4096 Jun 20 16:11 edab9b5e5bf73f2997524eebeac1de4cf9c8b904fa8ad3ec43b3504196aa3801
```
Các thư mục imagr-layer chứa các file duy nhất cho layer đó cũng như các hard links đến dữ liệu được chia sẻ với các lớp thấp hơn. Điều này cho phép sử dụng hiệu quả disk.
```sh
ls -i /var/lib/docker/overlay/38f3ed2eac129654acef11c32670b534670c3a06e483fce313d72e3e0a15baa8/root/bin/ls
19793696 /var/lib/docker/overlay/38f3ed2eac129654acef11c32670b534670c3a06e483fce313d72e3e0a15baa8/root/bin/ls
```
```sh
ls -i /var/lib/docker/overlay/55f1e14c361b90570df46371b20ce6d480c434981cbda5fd68c6ff61aa0a5358/root/bin/ls
19793696 /var/lib/docker/overlay/55f1e14c361b90570df46371b20ce6d480c434981cbda5fd68c6ff61aa0a5358/root/bin/ls
```
**Container-layer**
Các container cũng tồn tại trên disk trong Docker host’s filesystem `/var/lib/docker/overlay/`. Nếu liệt kê một thư mục Container đang chạy bằng lệnh `ls -l`, ba thư mục và một file tồn tại:
```sh
ls -l /var/lib/docker/overlay/<directory-of-running-container>

total 16
-rw-r--r-- 1 root root   64 Jun 20 16:39 lower-id
drwxr-xr-x 1 root root 4096 Jun 20 16:39 merged
drwxr-xr-x 4 root root 4096 Jun 20 16:39 upper
drwx------ 3 root root 4096 Jun 20 16:39 work
```
Tệp `lower-id` chứa ID của lớp trên cùng của iamge mà container dựa trên, đó là `lowerdir` của OverlayFS.
```sh
cat /var/lib/docker/overlay/ec444863a55a9f1ca2df72223d459c5d940a721b2288ff86a3f27be28b53be6c/lower-id
55f1e14c361b90570df46371b20ce6d480c434981cbda5fd68c6ff61aa0a5358
```
Thư mục phía trên chứa nội dung của layer container đọc-ghi tương ứng OverlayFS `upperdir`.

Thư mục `merged` là union mount của `lowdir` và `Upperdir` bao gồm khung nhìn của filesystem từ bên trong container đang chạy.

Thư mục `work` là bên trông của OverlayFS.

Để xem các mount tồn tại khi bạn sử dụng overlay storage driver, sử dụng lệnh mount:
```sh
mount | grep overlay

overlay on /var/lib/docker/overlay/ec444863a55a.../merged
type overlay (rw,relatime,lowerdir=/var/lib/docker/overlay/55f1e14c361b.../root,
upperdir=/var/lib/docker/overlay/ec444863a55a.../upper,
workdir=/var/lib/docker/overlay/ec444863a55a.../work)
```
`rw` trên dòng thứ hai là `overlay` đọc-ghi.

### 1.3 Cách container reads and writes với overlay và overlay2












## Tài liệu tham khảo
- https://docs.docker.com/storage/storagedriver/overlayfs-driver/
- https://docs.docker.com/storage/storagedriver/aufs-driver/
