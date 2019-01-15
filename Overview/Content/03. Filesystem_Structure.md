# Filesystem Structure

Trên nhiều hệ điều hành, bao gồm cả linux, `filesystem` có cấu trúc dạng cây. Cây thường bắt đầu từ thư mục `root(/)` tất cả các thứ mục khác sẽ là con của thư mục này.</br>
Đơn giản filesystem là các quy chuẩn về: cách thức cấp phát không gian lưu trữ cho file, quản lý thuộc tính của file, cách tổ chức sắp xếp dữ liệu trên các thiết bị sao cho việc tìm kiếm, truy cập tới dữ liệu nhanh chóng và thuận tiện.</br>
Các định dạng filesystem mà linux hỗ trợ:

* ext3, ext4, btrfs, xfs (native Linux filesystems)
* vfat, ntfs, hfs (filesystems from other operating systems)

Mỗi hệ thống tiệp tin nằm trên một partition của đĩa cứng. Partitions giúp tổ chức nội dung của ổ đĩa theo các loại data nó chứa và cách nó sử dụng. Ví dụ, các chương trình quan trọng cần thiết để chạy hệ thống thường được lưu trữ trên một partition riêng biệt hơn là chứa các file của người dùng thông thường. Ngoài ra các file tạm thời được tạo và hủy trong quá trình hoạt động bình thường của linux thường nằm trên một partition riêng; theo cách này, việc sử dụng tất cả các không gian có sẵn trên một patition cụ thể có thể không ảnh hưởng đến hoạt động bình thường của hệ thống.

Trước khi bạn có thể bắt đầu sử dụng filesystem, bạn cần mount nó lên filesystem tree tại **mountpoint**. Đây đơn giản là một thư mục (có thể để trống hoặc không) nơi các hệ thống tệp tin được gắn vào (mounted). Đôi khi bạn cần tạo một directory nếu nó không tồn tại. Nếu bạn mount một filesystem trên một directory không rỗng thì các nội dung trước đó sẽ được che đi và không thể truy cập cho đến khi filesystem unmounted. Vì vậy các mount point thường là các directory rỗng.

Lệnh `mount` được sử dụng để đính kèm một hệ thống tập tin ở đâu đó trong cây hệ thống tập tin. Đối số gồm nút thiết bị(device node) và điểm gắn kết(mount point).</br>
`$ mount /dev /sda6 /mnt`

Nó sẽ đính kèm hệ thống tệp tin chứa trong phân vùng đĩa được kết hợp với nút thiết bị `/dev/sda5` vào cây hệ thống tệp tin tại điểm gắn kết `/mnt`.Lưu ý rằng trừ khi hệ thống được cấu hình theo cách khác chỉ người dùng `root` có quyền chạy kết nối. Nếu bạn muốn nó tự động có sẵn mỗi lần hệ thống khởi động, bạn cần chỉnh sửa file  `/etc /fstab` cho phù hợp.Tên viết tắt cho Bảng hệ thống tệp. Nhìn vào tập tin này sẽ cho bạn thấy cấu hình của tất cả các hệ thống tập tin được cấu hình trước đó.

Khi cài đặt cần tạo ra ít nhất 2 phân vùng, một để mount root cho `\`, một cho `swap`. 

* Bạn có thể mount tự động thông qua file `/etc/fstab`, kernel sẽ đọc thông tin ở đây khi nó khởi động. Nếu sửa nội dung file này thì cần mount lại: 

		$ sudo mount -a

vd: sử dụng câu lệnh `mount` gắn ổ với định dạng `ntfs` tên `/dev/sda4` muốn `mount` vào hệ thông Linux để sử dụng thì đầu tiên cần tạo một thư mục để gắn nó, rồi sau đó `mount`:

	$ mkdir /mnt/Windows
	$ mount -v -t ntfs /dev/sda4 /mnt/Windows
	
Lúc này `/dev/sda4` là đường dẫn cần `mount`, `/mnt/Windowns` là `mountpoint`, từ giờ có thể truy cập đến ổ qua `/mnt/Windows`

Lệnh `umount` được sử dụng để tách hệ thống tập tin khỏi điểm gắn kết.</br>
`$ umount /mnt`

vd: Nếu không muốn dùng nữa thì `unmount` đi

	$ sudo umount /mnt/Windows
	hoặc
	$ sudo umount /dev/sda4	

Lưu ý: một số điểm cần lưu ý khi mount:</br>
- Các thiết bị không có mặt trong file /etc/fstab thì chỉ có root mới có thể mount được</br>
- Người dùng bình thường chỉ có thể mount được những thiết bị có trong file /etc/fstab thôi


Lệnh `df -Th` sẽ hiển thị thông tin về các hệ thống tập tin được gắn bao gồm các thống kê kiểu và cách sử dụng về không gian hiện đang sử dụng và sẵn có.</br>
```sh
Filesystem     Type      Size  Used Avail Use% Mounted on
udev           devtmpfs  3,9G     0  3,9G   0% /dev
tmpfs          tmpfs     795M  1,9M  793M   1% /run
/dev/sdb2      ext4      457G   19G  416G   5% /
tmpfs          tmpfs     3,9G   15M  3,9G   1% /dev/shm
tmpfs          tmpfs     5,0M  4,0K  5,0M   1% /run/lock
tmpfs          tmpfs     3,9G     0  3,9G   0% /sys/fs/cgroup
/dev/sdb1      vfat      511M  6,1M  505M   2% /boot/efi
tmpfs          tmpfs     795M   16K  795M   1% /run/user/121
tmpfs          tmpfs     795M   40K  795M   1% /run/user/1000
```
# Thư mục HOME

Trong bất kỳ hệ thống UNIX nào, mỗi người dùng đều có thư mục chính của riêng mình, thường được đặt trong `/home`. Thư mục `/root` trên các hệ thống Linux hiện đại không nhiều hơn thư mục gốc của người dùng root. Thư mục `/home` thường được gắn kết như là một hệ thống tập tin riêng biệt trên phân vùng riêng của nó, hoặc thậm chí được xuất khẩu từ xa trên một mạng thông qua NFS.

# The device directory

Thư mục `/dev` gồm các device node, một kiểu của pseudo-file được sử dụng bới hầu hết các hardware và software device, ngoại trừ các network devices.Thư mục này trống trên phân vùng đĩa khi nó chưa được `mount` nhưng nó chứa các mục được tạo bởi hệ thống `udev`, tạo và quản lý các nút thiết bị trên Linux, tạo chúng một cách tự động khi tìm thấy thiết bị. Thư mục `/dev` chứa các mục như:

	/dev/sda1
	/dev/lp1
	/dev/dvd1

### The variable directory

Thư mục `/var` gồm các file có thể thay đổi size và nội dung khi hệ thống đang chạy, một số thư mục sau:

* System log files: /var/log
* Packages files: /var/lib
* Print queues: /var/spool
* Temp files: /var/tmp
* FTP home directory: /var/ftp
* Web Server directory: /var/www

`/var` có thể được đặt trên một patition riêng vì vậy khi không gian lưu trữ hoặc kích thước file tăng có thể không ảnh hưởng đến hệ thống.

# The System configuration Directory

Thư mục `/etc` là trang chủ cho các tệp cấu hình hệ thống. Nó không chứa các chương trình nhị phân, mặc dù có một số tập lệnh thực thi. VD: `resolv.conf` cho hệ thống biết nới đi trên mạng để lấy tên được ánh xạ qua địa chỉ IP. Các File như passwdm shadow và group để quản lý các user accounts được tìm thấy trong thư mục `/etc`. VD: `/etc/rc2.d` chứa các liên kết tới scrips cho vào và thoát khỏi mức chạy level 2. Một số bản phân phối Linux mở rộng nội dung của `/etc`. VD: RedHat thêm thư mục con `/etc/sysconfig` chứa nhiều file cấu hình hơn. 

### File System Table

File `etc/fstab` là file dạng văn bản (plain text) gồm:
* Đường dẫn đến file đại diện cho các thiết bị
* Mount point: cho biết các thiết bị được mount vào thư mục nào
* Các tùy chọn: chỉ ra các thiết bị được mount như thế nào...

Nội dung file `cat /etc/fstab`

```sh
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
# / was on /dev/sda2 during installation
UUID=f34a764c-43cb-4e89-871e-b1451cd943f4 /               ext4    errors=remount-ro 0       1
# /boot/efi was on /dev/sda1 during installation
UUID=8CCC-EE5C  /boot/efi       vfat    umask=0077      0       1
/swapfile                                 none            swap    sw              0       0

```

* Cột 1: loại thiết bị phân vùng, cho biết đường dẫn tới file đại diện cho device đó (/dev/fd0)
* Cột 2: đường dẫn của mount point (/media/floppy0)
* Cột 3: là kiểu filesystem. `auto` có nghĩa là không phải là một loại filesystem, hệ thống sẽ tự động nhận diện khi thiết bị được mount.
* Cột 4: là các tùy chọn mount

| Optition |Meaning |
|----------|--------|
|auto | tự động mount thiết bị khi máy tính khởi động.|
|noauto | không tự động mount, nếu muốn sử dụng thiết bị thì sau khi khởi động vào hệ thống bạn cần chạy lệnh mount.|
|user | cho phép người dùng thông thường được quyền mount. |
|nouser | chỉ có người dùng root mới có quyền mount.|
|exec | cho phép chạy các file nhị phân (binary) trên thiết bị.|
|noexec | không cho phép chạy các file binary trên thiết bị.|
|ro (read-only) | chỉ cho phép quyền đọc trên thiết bị.|
|rw (read-write) | cho phép quyền đọc/ghi trên thiết bị.|
|sync | thao tác nhập xuất (I/O) trên filesystem được đồng bộ hóa.|
|async | thao tác nhập xuất (I/O) trên filesystem diễn ra không đồng bộ.|
|defaults | tương đương với tập các tùy chọn rw, suid, dev, exec, auto, nouser, async|

* Cột 5 là tùy chọn sao lưu cho chương trình dump, công cụ sao lưu filesystem. `0` là không sao lưu, `1` là thực hiện sao lưu.
* Cột 6: tùy chọn cho chương trình fsck, công cụ dò lỗi trên filesystem. Điền `0` là không kiểm tra, `1` là thực hiện kiểm tra.


Có thể sử dụng lệnh: `$ blkid` để tìm **UUID** hoặc **vol_id --uuid**

# The boot directory

`/lib` chứa các thư viện(mã chung được chia sẻ bởi các ứng dụng và cần thiết cho chúng chạy) cho các chương trình cần thiết trong thư mục `/bin` và `/sbin`. Hầu hết trong số này là những gì được gọi là các thư viện được nạp động(còn được gọi là các thư viện chia sẻ hoặc các đối tượng được chia sẻ (Shared Objects). Trên một số bản phân phối Linux tồn tại thư mục `/lib64` chứa thư viện 64 bit, trong khi `/lib` chứa các phiên bản 32 bit. Các mô-đun Kernel (mã Kernel, thường là các trình điều khiển thiết bị, có thể được nạp và tải mà không cần khởi động lại hệ thống) được đặt trong `/lib /modules/`.

# Additional directories

|Directory|Usage|
|---------|-----|
|/opt|Các gói phần mềm ứng dụng tùy chọn|
|/sys|Hệ thống tệp ảo cung cấp thông tin về hệ thống và phần cứng. Có thể được sử dụng để thay đổi các tham số hệ thống và cho các mục đích gỡ lỗi.|
|/srv|Dữ liệu trang web cụ thể được hệ thống phân phối. Ít khi sử dụng.|
|/tmp|Tập tin tạm thời, trên một số bản phân phối các tệp này bị xóa trên một lần khởi động lại|
|/media|Nó thường được đặt ở nơi các thiết bị di động, chẳng hạn như đĩa CD, DVD và ổ USB được lắp. Trừ khi cấu hình cấm nó, Linux tự động gắn kết phương tiện lưu động trong thư mục này khi chúng được phát hiện.|
|/usr|Ứng dụng, tiện ích và dữ liệu đa người dùng|
|/usr/include|Các tệp tiêu đề được sử dụng để biên dịch ứng dụng|
|/usr/lib|Thư viện cho các chương trình nhị phân|
|/usr/lib64|Thư viện 64 bit cho các chương trình nhị phân|
|/usr/share|Dữ liệu được chia sẻ được các ứng dụng sử dụng, thường độc lập về kiến trúc|
|/usr/src|Mã nguồn, thường cho Linux kernel|
|/usr/local|Dữ liệu và chương trình cụ thể cho máy cục bộ.|
