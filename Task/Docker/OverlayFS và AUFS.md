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
**Reading files**

Xem xét 3 Trường hớp trong đó một container mở một file để truy cập đọc với overlay.

- File không tồn tại trong container-layer: Nếu 1 container mở file truy cập đọc và file không tồn tại trong container (Upperdir), nó sẽ đọc từ image (lowdir). Điều này phát sinh 1 ít hiệu năng cao.
- File chỉ tồn tại trong container-layer: Nếu 1 container mở file truy cập đọc và file tồn tại trong container (Upperdir) chứ không phải trong image (lowdir), nó được đọc trực tiếp từ container.
- File tồn tại trong cả container-layer và image-layer: Nếu 1 container mở file để truy cập đọc và file tồn tại trong image-layer và container-layer, phiên bản file trong container-layer được đọc. Các file trong container-layer (Upperdir) che khuất các file có cùng tên trong image-layer (lowdir).

**Modifying files or directories**

Xem xét một số tình huống trong đó các file trong 1 container được chỉnh sửa.

- Ghi vào 1 file lần đầu tiên: Lần đầu tiên 1 container ghi vào file có sẵn, file đó không tồn tại trong container (Upperdir). Overlay/overlay2 driver thực hiện thao tác copy_up để sao chép file từ image (lowdir) vào container (Upperdir). Container sau đó ghi các thay đổi vào bản sao mới của file trong container-layer.

Tuy nhiên, OverlayFS hoạt động ở cấp độ file chứ không phải cấp block. Điều này có nghĩa là tất cả các hoạt động của OverlayFS copy_up sao chép toàn file, ngay cả khi file rất lớn và chỉ một phần nhỏ của nó đang được sửa đổi. Điều này có thể có một tác động đáng chú ý đến hiệu suất ghi container. Tuy nhiên, có hai điều đáng chú ý:

 - Hoạt động copy_up chỉ xảy ra lần đầu tiên khi một file đã cho được ghi vào.
 - OverlayFS chỉ hoạt động với hai layer. Điều này có nghĩa là hiệu suất tốt hơn AUFS, có thể chịu độ trễ đáng kể khi tìm kiếm file trong image có nhiều layer. Đặc điểm này đúng cho cả overlay và overlay2 drivers. Overlayfs2 ít hiệu năng hơn một chút so với overlayfs khi đọc ban đầu, bởi vì nó phải xem qua nhiều layer hơn, nhưng nó lưu trữ kết quả nên đây chỉ là một điểm trừ nhỏ.
 
**Deleting files and directories:**

- Khi một file bị xóa trong 1 container, 1 file trắng sẽ được tạo trong container (Upperdir). Phiên bản của file trong image-layer (lowdir) không bị xóa (vì lowdir chỉ đọc). Tuy nhiên, file trắng ngăn không cho nó khả dụng cho container.
- Khi một file bị xóa trong 1 container, 1 thư mục mờ được tạo trong container (Upperdir). Điều này hoạt động theo cách tương tự như 1 file trắng và ngăn chặn hiệu quả thư mục khỏi bị truy cập, mặc dù nó vẫn tồn tại trong image (lowdir).

**Renaming directories**

Gọi `rename(2)` cho 1 thư mục chỉ được phép khi cả nguồn và đường dẫn đích nằm ở layer trên cùng. Nếu không, nó sẽ trả về lỗi EXDEV (liên kết chéo thiết bị không được cho phép). Ứng dụng của bạn cần được thiết kế để xử lý EXDEV và quay lại chiến lược `copy and unlink`.

## 2. AUFS
### 2.1 Cách AUFS storage driver hoạt động

AUFS là một union filesystem, có nghĩa là nó xếp nhiều thư mục trên một máy chủ Linux và trình bày chúng dưới dạng một thư mục. Các thư mục này được gọi là các nhánh trong thuật ngữ AUFS và các layer trong thuật ngữ Docker.

Sơ đồ bên dưới hiển thị Docker container dựa trên image ubuntu:latest

<img src=https://i.imgur.com/RdjPoC7.png>

Mỗi image-layer và container-layer được biểu diễn trên Docker-host dưới dạng các thư mục con trong `/var/lib/docker/`. Union mount cung cấp cái nhìn thống nhất của tất cả các layer. Tên thư mục không tương ứng với ID của các layer.

AUFS sử dụng chiến lược Copy-on-Write (CoW) để tối đa hóa hiệu quả lưu trữ và giảm thiểu chi phí.

**Cấu trúc image và container trên disk**

Sử dụng `docker pull` tải xuống image bao gồm 5 layer.
```sh
docker pull ubuntu

Using default tag: latest
latest: Pulling from library/ubuntu
b6f892c0043b: Pull complete
55010f332b04: Pull complete
2955fb827c94: Pull complete
3deef3fcbd30: Pull complete
cf9722e506aa: Pull complete
Digest: sha256:382452f82a8bbd34443b2c727650af46aced0f94a44463c62a9848133ecb1aa8
Status: Downloaded newer image for ubuntu:latest
```

**Image-layer**

Tất cả thông tin về các image-layer và container-layer được lưu trữ trong các thư mục con của `/var/lib/docker/aufs/`.
- `diff/`: nội dung của mỗi layer, mỗi layer được lưu trữ trong một thư mục con riêng
- `layer/`: metadata về cách các image-layer được xếp chồng lên nhau. Thư mục này chứa 1 file cho mỗi image-layer hoặc container-layer chứa trên Docker-host. Mỗi file chứa ID của tất cả các layer bên dưới nó trong stack (cha mẹ của nó).
- `mnt/`: Mount points, một điểm trên mỗi image-layer hoặc container-layer, được sử dụng để lắp ráp và gắn kết filesystem thống nhất cho một container. Đối với image chỉ đọc, các thư mục này luôn trống.

**Container-layer**

Nếu 1 container đang chạy, nội dung của `/var/lib/docker/aufs/` thay đổi theo các cách sau:
- `diff/`: Sự khác biệt được giới thiệu trong layer container có thể ghi, chẳng hạn như các tệp mới hoặc sửa đổi.
- `layers/`: Metadata về container-layer có thể ghi của lớp cha mẹ.
- `mnt/`: Một điểm gắn kết cho mỗi container đang chạy filesystem thống nhất, chính xác như nó xuất hiện từ bên trong container.

## 2.3 Cách container reads and writes với aufs

**Reading files**

Xem xét 3 trường hợp trong đó 1 container mở một tệp để truy cập đọc với aufs.
- File không tồn tại trong container-layer: Nếu 1 container mở file để truy cập đọc và file không tồn tại trong container-layer, storage driver tìm kiếm file trong các image-layer, bắt đầu với layer ngay bên dưới container-layer. Nó được đọc từ layer nơi nó được tìm thấy.
- File chỉ tồn tại trong container-layer: Nếu 1 container mở file để truy cập đọc và file tồn tại trong container-layer, nó được đọc từ đó.
- File tồn tại trong cả container-layer và image-layer: Nếu container mở file để truy cập đọc và file tồn tại trong container-layer và 1 hoặc nhiều image-layer, file sẽ được đọc từ container-layer. Các file trong container-layer che khuất các file có cùng tên trong các image-layer.

**Modifying files or directories**

Xem xét một số tình huống trong đó các file trong 1 container được sửa đổi.
- Ghi vào một file lần đầu tiên: Lần đầu tiên một container ghi vào một file hiện có, file đó không tồn tại trong container (Upperdir). Driver aufs thực hiện thao tác copy_up để sao chép file từ image-layer nơi nó tồn tại sang container-layer có thể ghi. Container sau đó ghi các thay đổi vào bản sao mới của file trong container-layer.

Tuy nhiên, AUFS hoạt động ở cấp độ file chứ không phải cấp block. Điều này có nghĩa là tất cả các hoạt động copy_up sao chép toàn bộ file, ngay cả khi file rất lớn và chỉ một phần nhỏ của nó đang được sửa đổi. Điều này có thể có một tác động đáng chú ý đến hiệu suất ghi container. AUFS có thể chịu độ trễ đáng chú ý khi tìm kiếm file trong image có nhiều layer. Tuy nhiên, điều đáng chú ý là thao tác copy_up chỉ xảy ra lần đầu tiên khi một file đã cho được ghi vào. Sau đó ghi vào cùng một file hoạt động chống lại bản sao của file đã được sao chép vào container.

- Deleting files and directories:

Khi một file bị xóa trong 1 container, 1 file trắng sẽ được tạo trong container-layer. Phiên bản của file trong image-layer không bị xóa (vì các image-layer chỉ đọc). Tuy nhiên, file trắng ngăn không cho nó có sẵn cho container.

Khi 1 thư mục bị xóa trong 1 container, 1 file mờ được tạo trong container-layer. Điều này hoạt động theo cách tương tự như 1 file trắng và ngăn chặn hiệu quả thư mục khỏi bị truy cập, mặc dù nó vẫn tồn tại trong image-layer.
- Đổi tên thư mục: Gọi `rename(2)` cho 1 thư mục không được hỗ trợ đầy đủ trên AUFS. Nó trả về EXDEV (liên kết giữa các thiết bị chéo không được cho phép), ngay cả khi cả hai nguồn và đường dẫn đích nằm trên cùng 1 layer AUFS, trừ khi thư mục không có con. Ứng dụng của bạn cần được thiết kế để xử lý EXDEV và quay lại chiến lược `copy and unlink`.

## Tài liệu tham khảo
- https://docs.docker.com/storage/storagedriver/overlayfs-driver/
- https://docs.docker.com/storage/storagedriver/aufs-driver/
