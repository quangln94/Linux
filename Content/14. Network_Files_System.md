# Network File System</br>
NFS (Network File System) là một giao thức được dùng cho việc chia sẻ data qua physical systems. Người quản trị gắn các thư mục của người dùng từ xa trên một máy chủ để cho phép họ truy cập vào cùng một tệp và cấu hình.</br>
Hoạt động theo cơ chế client-server</br>
Hiện tại NFS có 4 phiên bản. NFSv4 là phiên bản đang được sử dụng nhiều nhất và hỗ trợ phát huy tối đa của giao thức NFS.</br>
Một số vấn đề với NFS:
* Không bảo mật, mã hóa dữ liệu
* Hiệu suất hoạt động trung bình ở mức khá, nhưng không ổn định
* Dữ liệu phân tán có thể bị phá vỡ nếu có nhiều phiên sử dụng đồng thời
Ta cần xác định những thư mục ta muốn chia sẻ vơí Client. Sau đó ta phải export thư mục đó để cho phía client có thể truy cập vào.
Để export trên server ta vào file `/etc/exports`
Ta thêm vào file đó với cú pháp sau:
`thư_mục_chia_sẻ IP_client(Các_quyền_truy_cập_từ_Client)`

File `/etc/export` chứa các đường dẫn thư mục và quyền hạn mà một host muốn chia sẻ dữ liệu với host khác qua NFS.</br>
Các máy chủ có quyền hạn sau:
* `rw`: Đọc và ghi
* `ro`: Chỉ được đọc
* `noacess`: Cấm truy cập vào các thư mục con của thư mục đc chia sẻ

Ví dụ bạn muốn chia sẻ thư mục `/share` cho các máy có địa chỉ trong 192.168.1.1/28 có quyền đọc ghi thì thêm vào nội dung file dòng sau:

	/Share 192.168.1.1/28(rw)

Lưu ý về các dấu cách trong dòng trên

## Cài đặt trên CentOS</br>
- Server: IP: 172.16.1.1

Trước tiên ta cần cài `NFS` lên máy. Dùng lệnh:
```sh
yum install nfs-utils nfs-utils-lib
```
Ta cần xác định những thư mục ta muốn chia sẻ vơí Client. Sau đó ta phải export thư mục đó để cho phía client có thể truy cập vào.</br>
Để export trên server ta vào file `/etc/exports`
```sh
vi /etc/exports
```
Ta thêm vào file đó với cú pháp sau:`thư_mục_chia_sẻ IP_client(Các_quyền_truy_cập_từ_Client)`</br>
Ở đây tôi sẽ thực hiện chia sẻ thư mục `share` cho các máy Client. `IP_client` có thể là địa chỉ của cả một mạng có thể chỉ là địa chỉ của máy cụ thể. Ở ví dụ này tôi chỉ chia sẻ với máy cụ thể có địa chỉ là `172.16.1.0/24`.
`Các_quyền_truy _cập_từ_Client` có các quyền phổ biến sau:
 * `rw` cho phép client đọc ghi với thư mục
 * `ro` quyền chỉ đọc với thư mục
 * `sync` đồng bộ hóa thư mục dùng chung
 * `root_squash` ngăn remote root users
 * `no_root_squash` cho phép remote root users
 
Cần chú ý rằng quyền trên thư mục và quyền bạn cấp ở chỗ export sẽ giao nahu để ra quyền cuối cùng cho client(Tức là nếu trên thư mục bạn cấp cho nhóm người dùng là `other` chỉ có quyền `r` mà ở phần export bạn cấp cho nó là `rw` thì quyền cuối cùng của client chỉ là `r`).</br>
Mỗi lần sửa file này xong ta cần dùng lệnh `exportfs -a` thì thay đổi mới được cập nhật.</br>
Có lưu ý rằng khi khai báo quyền truy cập của client ta cần viết liền.Ví dụ trên nếu khai báo `192.168.169.129(rw)` sẽ khác với khai báo `192.168.169.129 (rw)` với cách thứ nhất thì option sẽ áp dụng với địa chỉ khai báo ở trước đó. Còn với cách thứ 2 thì các quyền của địa chỉ khai báo trước sẽ được chỉ định là mặc định(chỉ có quyền đọc) còn option sẽ áp dụng với những địa chỉ không được khai báo.</br>
Để dịch vụ NFS có thể gửi và nhận yêu cầu từ phía Client và Server ta cần khởi động dịch vụ `NFS`. Ta sử dụng câu lệnh
```sh
service nfs start
```
Mỗi khi reboot máy ta cần chạy lại lệnh này.,/br>
Ta cũng cần kiểm tra trạng thái firewall và tắt nó đi để cho máy client có thể truy cập vào. Ta dùng lệnh:</br>
`systemctl status firewalld` để kiểm tra trạng thái</br>
`systemctl stop firewalld` để tắt nó</br>
Với 2 lệnh trên ta cũng phải chạy lại khi reboot.</br>
Ta đã thiết lập xong trên server</br>
- Client: IP: 172.16.1.2

Máy client của tôi là máy có địa chỉ IP 192.168.169.129/24 như tôi đã khai báo bên trên.
Ta cũng dùng lệnh `yum install nfs-utils nfs-utils-lib` để cài đặt dịch vụ NFS.</br>
Dùng lệnh `showmount -e IP_server` để kiểm tra những thư mục server đã export cho những máy nào.</br>
Bây giờ ta thực hiện lệnh `mount` để mount nó vào 1 thư mục nào đó trên máý của mình và dùng. Nó giống với ta mount ổ đĩa bình thường.</br>
Cú pháp `mount IP_server:/Thư_mục_chia_sẻ_trên_server Thư_mục_trên_máy_mình`</br>
Ở đây tôi thực hiện mount thư mục `/root/data` trên server có địa chỉ `192.168.169.137` vào thư mục `Data_nfs` trên máy của mình.</br>
Khi không dùng ta có thể umount thư mục đó. Mỗi lần reboot mà muốn sử dụng lại ta phải mount lại. Nếu muốn tự động mount khi hệ thống khởi động ta vào file `/etc/fstab` để thêm thông tin giống với disk.</br>
Lúc này ta coi thư `Data` trên máy server như disk trên máy của mình.</br>

## Cài đặt trên Ubuntu 
### Requirements
Server:

	Ubuntu 16.04
	ip: 192.168.60.134

Client:

	Ubuntu 16.04
	ip: 192.168.60.130

### Installation

- Cài đặt nfs trên server:
```sh
sudo apt-get install nfs-kernel-server
```
- Trên client sẽ cài một gói `nfs-common` cung cấp chức năng `nfs` mà không bao gồm các thành phần server không cần thiết.
```sh
sudo apt-get install nfs-common
```
- Khởi động nfs trên server và client:
```sh
service nfs-kernel-server start
```
Trên máy chủ, tôi sẽ tạo ra một thư mục để share các tệp tin và thay đôi quyền sở hữu tệp tin thành không sở hưu bởi ai cả:
```sh
sudo mkdir /var/nfs/general -p
sudo chown nobody:nogroup /var/nfs/general
```
Sửa nội dung file `/etc/exports` để share cả thư mục vừa tạo và thư mục `/home` 

```sh
$ sudo vim /etc/exports
/var/nfs/general 192.168.60.130(rw,sync,no_subtree_check)
/home 192.168.60.130(rw,sync,no_root_squash,no_subtree_check,no_all_squash) 
```
Trong đó: 
* `rw`: Tùy chọn này cho phép máy tính client truy cập cả đọc và viết vào bộ đĩa (volume).
* `sync`: Tùy chọn này bắt buộc NFS phải ghi các thay đổi vào đĩa trước khi trả lời. Điều này dẫn đến một môi trường ổn định và phù hợp hơn kể từ khi trả lời phản ánh tình trạng thực tế của bộ đĩa (volume) từ xa. Tuy nhiên, nó cũng làm giảm tốc độ của hoạt động tập tin.
* `no_subtree_check`: tùy chọn này ngăn cản việc kiểm tra cây con, đó là một quá trình mà host phải kiểm tra xem các tập tin thực sự vẫn có sẵn trong cây xuất cho mỗi yêu cầu.
* `no_root_squash`: Theo mặc định, NFS chuyển yêu cầu từ người dùng root từ xa vào một người dùng không có đặc quyền trên máy chủ. Điều này đã được dự định như là tính năng bảo mật để ngăn chặn một tài khoản root trên máy khách (client) sử dụng hệ thống tập tin của máy chủ như là root.
* `no_all_squash` enables the user’s authority

Sau đó khởi động lại server:
```sh
sudo systemctl restart nfs-kernel-server
```
Nếu firewall trên server đang bật (check status) thì cần điều chỉnh lại để mở cổng 2049, dùng lệnh sau để thêm rule:
```sh
sudo ufw allow from 192.168.60.130 to any port nfs
sudo ufw status
```
- Trên client:
```sh
	sudo mkdir -p /nfs/general
	sudo mkdir -p /nfs/home 
```
mount các thư mục vào client:
```sh
	sudo mount 192.168.60.134:/var/nfs/general /nfs/general
	sudo mount 192.168.60.134:/home /nfs/home	
```
Kiểm tra xem đã mount được chưa bằng lệnh `df -h`. Giờ hãy thử tạo một file mới trong thư mục `general` trong client hoặc server ta sẽ thấy nó trên máy còn lại.

Gắn thư mục NFS trên client lúc khởi động bằng cách thêm chúng vào tệp tin `/etc/fstab` dòng sau: 
```sh
192.168.60.134:/var/nfs/general /nfs/general nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
192.168.60.134:/home /nfs/home nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
```
Nếu không dùng nữa thì trên client `unmount` thư mục share đó đi.
