# Data Backup

## Rsync ( Remote Sync)

[I. Overview](#overview)</br>
[II. Install](#install)</br>
[III. Config](#config)</br>

<a name="overview"></a>
## I. Overview</br>
Rsync là một công cụ cho phép truyền và đồng bộ file, thư mục từ xa giữa các máy tính một cách dễ dàng.</br>
Hoạt động trên Windowns, Mac OS và GNU/Linux.</br>
Lệnh `rsync` được sử dụng để đồng bộ hóa toàn bộ cây thư mục. Về cơ bản, nó sao chép tập tin như lệnh `cp`. Ngoài ra, `rsync` sẽ kiểm tra xem tệp đã được sao chép đã tồn tại chưa. Nếu tệp tồn tại và không có thay đổi về kích thước hoặc thời gian sửa đổi, `rsync` sẽ tránh một bản sao không cần thiết và tiết kiệm thời gian. Hơn nữa, với thuật toán delta-copy, `rsync` chỉ copy những phần thay đổi, làm giảm được dữ liệu qua mạng, và nó có thể kiểm soát được băng thông cần thiết cho việc truyền tin nên nó có thể rất nhanh.</br>
`rsync` là rất hiệu quả khi đệ quy sao chép một cây thư mục thông qua mạng, bởi vì chỉ có sự khác biệt được truyền đi. Người ta thường đồng bộ hóa cây thư mục đích với gốc, sử dụng tùy chọn `rsync -r` để đệ quy đi xuống cây thư mục sao chép tất cả các tệp và thư mục bên dưới thư mục được liệt kê dưới dạng nguồn.
```sh
# rsync -ravzh TH TH1/data/backups
sending incremental file list
TH/
TH/file1.txt
TH/file2.txt
TH/file4.txt -> file1.txt

sent 245 bytes  received 61 bytes  612.00 bytes/sec
total size is 17  speedup is 0.06
```
### 1. Một số các đặc điểm</br>
Mặc định `rsync` copy theo dạng block (nhưng vẫn có tùy chọn copy theo dạng file) nên tốc độ đồng bộ được cải thiện nhiều khi làm việc với file và thư mục có kích thước lớn.
`rsync` cho phép nén dữ liệu để giảm thiểu việc sử dụng băng thông. Nhưng nó cũng tốn thêm một khoảng thời gian cho việc nén và giải nén dữ liệu.</br>
Mặc định sử dụng `ssh` trên hầu hết các hệ thống để mã hóa dữ liệu và bảo mật.
Đặc biệt là `rsync` copy và giữ nguyên các thông số về file và folder như: `Symbolic links`, `Permissions`, `TimeStamp`, `Owner` và `Group`.</br>
Không yêu cầu quyền super-user

### 2. Các chế độ</br>
`rsync` có hai mode, một là `remote-shell` dùng lệnh copy bình thường (ssh, rsh), 2 là chạy `daemon` qua TCP.</br>
Mode `daemon` mặc định bind đến cổng 873, ở chế độ này, `rsync` hoạt động giống như một `ftp server` và cho phép download file public

### 3. Cơ chế hoạt động</br>
`rsync` tìm kiếm files cần được transfer, sử dụng `lqquick checkrq algorithm` (mặc định) để tìm các file có thay đổi về kích thước hoặc lần sử đổi cuối cùng (last-modified time). Bất kỳ một sự thay đổi nào về các thuộc tính thì sẽ được thực hiện trực tiếp luôn trên tệp đích khi kiểm tra sự thay đổi của dữ liệu file mà không cần phải update

<a name="install"></a>
## II. Install Rsync on Linux

### 1. Cài đặt

#### Với Ubuntu/Debian:
```sh
apt-get install rsync
```
#### Với Red Hat/CentOS
```sh
yum install rsync
```
### 2. Sử dụng

Cấu trúc câu lệnh cơ bản
```sh
rsync [options] source destination
```
Trong đó:</br>
* Source(src): Đường dẫn tới dữ liệu nguồn 
* Destination(dest): Đường dẫn tới đích 
* Options: một số tùy chọn khác

#### Local:
```sh
rsync rsync [options] source [destination]
```
#### Access via remote shell:
```sh
Pull: rsync [option] [user@]host:src [dest]
Push: rsync [option] src [user@]host:dest
```
#### Access via rsync daemon:
```sh
Pull:   rsync [option] [user@]host::src [dest]
	rsync [option] rsync://[user@]host[:port]/src. [dest]
Push:   rsync [option] src [user@]host::dest
        rsync [option] src rsync://[user@]host[:port]/dest
```
#### Các Option:
`-v` mặc định `rsync` làm việc rất im lặng, với `-v` sẽ cho bạn thông tin về file đang được truyền và kết quả cuối cùng.</br>
`-c --checksum` Tạo `checksum` trước khi gửi và kiểm tra sau khi nhận.</br>
`-a --archive` Copy dữ liệu `recursively` và giữ nguyên được tất cả các thông số của file và thư mục.</br>
`-r` Cũng là copy dữ liệu `recursively` nhưng không đảm bảo về các thông số trên.</br>
`-z` nén dữ liệu trước khi truyền đi.</br>
`--delete`: Xóa dữ liệu không liên quan ở Dest nếu Source không tồn tại dữ liệu đó.</br>
`-u`: không ghi đè dữ liệu ở thư mục đích.</br>
`--exclude`: trừ những dữ liệu không muốn truyền đi.</br>
#### Ví dụ
- Copy file và thư mục trên local
```sh
rsync -zvh backup.tar /tmp/backups/
```
- Copy file và thư mục giữa các server

Đẩy từ local lên server</li>
```sh
rsync -avz data/ root@192.168.1.10:/home/
```
Download từ server về local
```sh
rsync -avzh root@192.168.1.10:/home/data /backups/data
```
- Rsync qua ssh

Download file từ Remote Server về Local Server
```sh
rsync -avzhe ssh root@192.168.1.10:/root/install.log /backups/
```
Đẩy file lên Server
```sh
rsync -avzhe ssh backup.tar root@192.168.1.10:/backups/
```
- Sử dụng tùy chọn --include --exclude</br>
```sh
rsync -avze ssh --include 'R*' --exclude '*' root@192.168.0.101:/var/lib/rpm/ /root/rpm
```
Tùy chọn `-include` cho phép chúng ta thêm 1 file hoặc thư mục trong quá trình đồng bộ dữ liệu</br>
VD: muốn `backup` thư mục `/root/backup` trên server 192.168.1.10 nhưng muốn bỏ qua những file và thư mục có tên bắt đầu file lên thư mục `backup4` trên máy của mình ta thực hiện:
```sh
rsync -vah --exclude 'file*' root@192.168.1.5:/root/backup backup4
```
Tương tự với lệnh `--include`</br>
Với tùy chọn `--delete` sẽ cho phép ta xóa dữ liệu ở đich nếu nguồn không tồn tại dữ liệu đó.</br>
```sh
rsync -vah --delete root@192.168.1.5:/root/backup backup4
```
- Giới hạn dung lượng tối đa của file được đồng bộ.</br>
Sử dụng tùy chọn `--max-size`
```sh
rsync -vah --max-size='200k' root@192.168.1.5:/root/backup backup4
```
- Tự động xóa dữ liệu nguồn khi đồng bộ dữ liệu thành công</br>
Ta thêm option `--remove-source-files` vào dòng lệnh
```sh
rsync --remove-source-files -zvh backup.tar /tmp/backups/
```

<a name="config"></a>
## III. Config</br>
### Cấu hình đồng bộ giữa hai máy client và server

Client
```sh
ip: 192.168.60.134
OS: Ubuntu 16.04
```
Server
```sh
ip: 192.168.60.130
OS: Ubuntu 16.04
```
### Các bước cấu hình:

- Cài đặt rsync trên cả client và server</br>
- apt-get install xinetd rsync</br>
- Cài đặt và cấu hình ban đầu</br>
#### Trên server

- Sửa file `sudo vi /etc/default/rsync`, sử dùng như dòng dưới đây từ `false` thành `true`
```sh
RSYNC_ENABLE=true
/etc/init.d/rsync start
```
- Tạo file `/etc/rsync.conf` với nội dung như sau
```sh
lock file = /var/run/rsync.lock log file = /var/log/rsyncd.log pid file = /var/run/rsyncd.pid
[data] path = /data uid = root gid = root read only = no hosts allow = 192.168.60.134/255.255.255.0
```
- Lưu dữ liệu được đồng bộ từ client lên tại `/data`</br>
- Chạy `Rsync /etc/init.d/rsync start`

#### Trên client

- Test thử xem kết nối được tới server được chưa. Chạy lệnh với một số các tùy chọn sau:
```s
rsync -avz --progress /home/trang/test/ rsync://root@192.168.60.130/data
root@ubuntu:/home/trang/test# rsync -avz --progress /home/trang/test/ rsync://root@192.168.60.130/data
sending incremental file list
./
file2.txt
    	      0 100%    0.00kB/s    0:00:00 (xfr#1, to-chk=3/5)
file3.txt
    	      0 100%    0.00kB/s    0:00:00 (xfr#2, to-chk=2/5)
file/
file/file4.txt
    	      0 100%    0.00kB/s    0:00:00 (xfr#3, to-chk=0/5)

sent 270 bytes  received 88 bytes  716.00 bytes/sec
total size is 0  speedup is 0.00
```
files và floder sẽ được đồng bộ trong /data của server</br>
### Sử dụng incrond để check và đồng bộ real time

#### Trên client

- Cài incron

RHEL/Fedora/CentOS
```sh
$ sudo yum install incron
```
Debian/Ubuntu
```sh
$ sudo apt-get install incron
```
- Sửa file `/etc/incron.allow` thêm user root hoặc một user khác được phép sử dung incrond

root trangnth

- incrontab -e thêm dòng sau
```sh
/home/trang/test/ IN_CLOSE_WRITE,IN_CREATE,IN_DELETE rsync -avz --progress /home/trang/test/ rsync://root@192.168.60.130/data
```
*Mỗi khi có sự thay đổi như thêm, xóa file, sửa file trong /home/trang/test sẽ được đồng bộ với server*

Xem log `vim /var/log/system`
<img src="https://github.com/trangnth/Report_Intern/blob/master/Rsync/1.png?raw=true">

# Compress data

Dữ liệu tệp thường được nén để tiết kiệm dung lượng đĩa và giảm thời gian cần để truyền tệp qua mạng. Linux sử dụng một số phương pháp để thực hiện nén này.

|Command|Usage|
|-------|-----|
|gzip|Sử dụng thường xuyên trong Linux|
|bzip2|Tạo ra các tệp nhỏ hơn nhiều so với các tệp được tạo bởi gzip|
|xz|Tiện ích nén hiệu quả nhất về không gian được sử dụng trong Linux. Nó hiện đang được sử dụng bởi kernel.org để lưu trữ lưu trữ của Linux kernel.|
|zip|Thường được yêu cầu để kiểm tra và giải nén lưu trữ từ các hệ điều hành khác|

Những kỹ thuật này khác nhau về hiệu quả nén (không gian được lưu trữ) và thời gian nén; nói chung các kỹ thuật hiệu quả hơn mất nhiều thời gian hơn. Thời gian giải nén không thay đổi nhiều so với các phương thức khác nhau.</br>
# Lưu trữ dữ liệu</br>
Lệnh `tar` cho phép bạn tạo hoặc giải nén các tệp từ một tệp lưu trữ, thường được gọi là `tarball`. Đồng thời, bạn có thể tùy chọn nén trong khi tạo lưu trữ và giải nén trong khi trích xuất nội dung của nó.</br>
Dưới đây là một số ví dụ về việc sử dụng `tar`:

|Command|Usage|
|-------|-----|
|tar xvf mydir.tar|Giải nén tất cả các tệp trong mydir.tar vào thư mục mydir|
|tar zcvf mydir.tar.gz mydir|Tạo lưu trữ và nén bằng `gzip`|
|tar jcvf mydir.tar.bz2 mydir|Tạo lưu trữ và nén với `bz2`|
|tar xvf mydir.tar.gz|Giải nén tất cả các tệp trong mydir.tar.gz vào thư mục mydir|
|tar cvf mydir.tar|Hiển thị nội dung trong thư mục mydir|

# Copying disks</br>
## 1. Dùng để dùng để sao lưu dữ liệu, copy, chuyển đổi dữ liệu với những option tương ứng. Có thể sử dụng với những trường hợp cơ bản sau:</br>
- Sao lưu hoặc phục hồi dữ liệu ổ cứng hoặc một phân vùng xác định trước.</br>
- Sao lưu lại MBR trong máy. MBR là file rất quan trọng, nó chứa các lệnh để GRUB hoặc LILO nạp hệ điều hành.</br>
- Chuyển chữ hoa sang chữ thường và ngược lại.</br>
- Tạo file có kích thước cố định.</br>
- Tạo file ISO.</br>

## 2. Cú pháp</br>
```sh
dd if=src of=dst option
```
- src ở đây là ổ đĩa, thư mục, file ta muốn sao lưu</br>
- dst ở đây là ổ đĩa, thư mục, file ta muốn lưu data vào đó.</br>

option cơ bản:

- bs=byte quá trình đọc ghi bao nhiêu bytes 1 lần</br>
- cbs=bytes chuyển đổi bao nhiêu bytes 1 lần</br>
- count=x thực hiện x block trong quá trình thực hiện lệnh</br>
- ibs/obs: chỉ ra số byte một lần đọc ghi</br>
- skip=x bỏ qua x block đầu vào</br>
- conv=option. Option có thể là các option sau:</br>

	- ucase/lcase: Chuyển chữ thường thành chữ hoa và ngược lại.</br>
	- noerror : Tiếp tục sao chép dữ liệu khi đầu vào bị lỗi.</br>
	
-rsync: Đồng bộ dữ liệu với ổ đang sao chép sang.</br>
*Lưu ý: Đơn vị mặc định mỗi lần đọc được tính theo kb. Chúng ta có thể sử dụng một số tùy chọn sau để thay đổi định dạng:*</br>
- c=1
- w=2
- b=512
- kB=1000
- K=1024
- MB=1000*1000
- M=1024*1024
- GB=1000 * 1000 * 1000
- G=1024 * 1024 * 1024

## 3. Ví dụ
```sh
dd if=/dev/sda of=/dev/sdb conv=noerror, sync
```
Sao chép từ sda sang sdb, tiếp tục khi báo lỗi và đồng bộ dữ liệu sao chép.
```sh
dd if=/dev/sda1 of=/root/sda1.img
```
Tạo một file image cho ổ sda1
```sh
dd if=/root/sda1.img of=/dev/sda1
```
Phục hồi dữ liệu.
```sh
dd if=/dev/sda1 of=/root/mbr.txt bs=512 count=1
```
Sao chép MBR
```sh
dd if=/root/mbr.txt of=/dev/sda1
```
Phục hồi MBR.
```sh
dd if=/dev/zero of=/root/file1 bs=100M count=1
```
Tạo 1 file kích thước 100M.
```sh
dd if=/root/test.doc of=/root/test1.doc conv=ucase
```
Chuyển nội dung file test.doc sang chữ hoa.

Lệnh `dd` rất hữu ích để tạo bản sao của không gian đĩa thô.</br>
Ví dụ: để sao lưu Master Boot Record(MBR) (512 byte sector đầu tiên trên đĩa có chứa một bảng mô tả các phân vùng trên đĩa đó), sử dụng:</br>
```sh
# dd if=/dev/sda of=sda.mbr bs=512 count=1
```
Để sử dụng `dd` để sao chép một đĩa vào một đĩa khác, xóa mọi thứ đã tồn tại trên đĩa thứ hai, hãy sử dụng:
```sh
# dd if=/dev/sda of=/dev/sdb
```
Bản sao chính xác của thiết bị đĩa đầu tiên được tạo trên thiết bị đĩa thứ hai.</br>
Lệnh `dd` có ích khi sao chép đĩa bootable như một thẻ Compact Flash, thẻ Micro SD hoặc khóa USB có thể khởi động. Chèn thẻ CF được sao chép vào hệ thống và tạo một bản sao</br>
```sh
# dd if=/dev/sdb of=./backup.img
```
Remove thẻ CF, chèn thẻ mới và tạo bản sao mới</br>
```sh
# dd if=./backup.img of=/dev/sdc
```
