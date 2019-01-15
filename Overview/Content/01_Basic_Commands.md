# Basic commands
## Locating Applications
Dựa trên các bản phân phối, chương trình, các gói phần mềm riêng được cài đặt trong các thư mục khác nhau. Nhìn chung các chương trình thực thi nên ở các thư mục sau:
```sh
/bin
/usr/bin
/sbin
/usr/sbin
/opt
```
Một cách khác là sử dụng tiện ích `which`. Vi dụ: Để tìm chính xác vị trí của chương trình `python` trong file system
```sh
$ which python

```
Nếu vẫn không tìm thấy thì ta có thể sử dụng `whereis pyhon`, bởi vì nó tìm kiếm trong phạm vi rộng hơn các thư mục hệ thống
```sh
$ whereis python
python: /usr/bin/python3.6 /usr/bin/python3.6m /usr/lib/python3.7 /usr/lib/python2.7 /usr/lib/python3.6 /etc/python2.7 /etc/python3.6 /usr/local/lib/python3.6 /usr/include/python3.6m /usr/share/python
```
## Truy cập thư mục
Các command hữu ích cho việc điều hướng thư mục

|Command|Result|
|-------|------|
|cd|Chuyển về thư mục `home` của bạn|
|cd..|Chuyển về thư mục cha|
|cd-|Chuyển về thư mục trước|
|cd /|Chuyển về thư mục `root(/)`|

## Tìm hiểu Filesystem
Lệnh `tree` là 1 lệnh hữu ích để có thể nhìn tổng quan về cây thư mục của hệ thống. Một số `command` hữu ích cho việc khám phá Filesystem</br>
Muốn sử dụng lệnh `tree` trước hết ta phải sử dụng command để cài đặt gói nếu không có sẵn:</br>
`sudo apt-get install tree -y`

|Command|Result|
|-------|------|
|ls|Liệt kê nội dung của thư mục đang làm viêc|
|ls -a|Liệt kê ra tất cả File bao gồm File ẩn và thư mục|
|ls -la|Hiển thị thêm các thông tin chi tiết của File và Thư mục|
|tree|Hiển thị cây của Filesystem|
|tree -d|Chỉ liệt kê thư mục và bỏ qua danh sách File|

## Hard link và Symbolic link

### Một số sự khác biệt cơ bản của hard link và soft link</br>
- Hard link: Khi tạo ra một file mới hard link đến file cũ thì hai file này sẽ cùng tham chiếu tới 1 vùng nhớ chứa địa chỉ của data, nên khi thay đổi nội dung từ 1 file thì file kia cũng thay đổi theo và khi xóa file cũ đi thì file mới đó không ảnh hưởng.</br>
- Soft link: Khi tạo 2 file soft link tới nhau thì file mới sẽ trỏ tới vùng địa chỉ của file mới, nên khi xóa file cũ đi, file mới sẽ không thể truy cập đến dữ liệu được nữa.

Command `ln` có thể sử dụng để tạo `hard link` hoặc `soft link`, cũng như `symbolic link` hoặc `symlink`. Hai loại này rất phổ biến trên các hệ điều hành dựa trên UNIX-based.

### Giả sử có file1.txt và tạo hard link là file2.txt
	
	cat >file1.txt

	$ ln file1.txt file2.txt
### Kiểm tra sự tồn tại của hai file này.

	$ ls -l file*
	-rw-r--r-- 2 ngocquang ngocquang 4 Thg 1 26 22:52 file1.txt
	-rw-r--r-- 2 ngocquang ngocquang 4 Thg 1 26 22:52 file2.txt

### Thêm `option -i` ta sẽ thấy được ở cột đầu tiên là số `i-node`, và hai số này giống hệt nhau tức là đang cùng trỏ tới một vùng nhớ

	$ ls -li file*
	26088401 -rw-r--r-- 2 ngocquang ngocquang 4 Thg 1 26 22:52 file1.txt
	26088401 -rw-r--r-- 2 ngocquang ngocquang 4 Thg 1 26 22:52 file2.txt

### `Symbolic` or `Soft links` được tạo với `option -s` như sau:

	$ ln -s file1.txt file4.txt
	$ ls -li file*
	26088401 -rw-r--r-- 2 ngocquang ngocquang 4 Thg 1 26 22:52 file1.txt
	26088401 -rw-r--r-- 2 ngocquang ngocquang 4 Thg 1 26 22:52 file2.txt
	26088412 lrwxrwxrwx 1 ngocquang ngocquang 9 Thg 1 26 22:54 file4.txt -> file1.txt
  
Ở đây `file4.txt` không còn xuất hiện như tệp thông thường nữa, nó là một điểm trỏ tới `file1.txt` và cũng có số `inode` khác nhau (cột đầu tiên), quyền sẽ luôn là `lrwxrwxrwx`. Chúng cực kỳ tiện lợi khi có thể dễ dàng sửa đổi để trỏ tới các điểm khác. Một cách dễ dàng tạo shortcut từ thư mục home của bạn cho một đường dẫn dài là tạo một symbolic link.

Không giống như `hard link`, `soft link` có thể trỏ đến các đối tượng ngày trên các filesystem khác nhau (hoặc các partitions), cái mà có thể có hoặc không có sẵn thậm chí không tồn tại. Trong trường hợp link không trỏ tới các đối tượng tồn tại hoặc có sẵn, thì đường link đó sẽ bị treo, lơ lửng.

`Hardlink` cũng rất hữu ích, chúng tiết kiệm băng thông, nhưng phải cẩn thận với việc sử dụng nó.
