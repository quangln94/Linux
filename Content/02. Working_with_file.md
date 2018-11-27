# WORKING WITH FILE

## The File Stream

Khi các dòng lệnh được thực thi, mặc định sẽ có 3 luồng file chuẩn:</br>
- standard input or **stdin**
- standard output or **stdout**
- standard error or **stderr**

Thông thường, **stdin** là những gì bạn nhập từ bàn phím, **stdout** và **stderr** sẽ được in ra *terminal*; thường **stderr** sẽ được chuyển hướng tới file log ghi lỗi. **stdin** thường được cung cấp từ các điểu khiển đầu vào hoặc *output* của lệnh trước đó thông qua đường ống. **stdout** cũng thường được chuyển hướng vào file. Từ khi **stderr** là nơi mà các *error messages* được viết thì thường không có gì ở đó.

Trong Linux, tất cả các tệp mở bên trong được gọi là mô tả tệp. Đơn giản chỉ cần đặt đại diện bởi các số bắt đầu từ số 0: **stdin** là 0, **stdout** là 1, và **stderr** là 2. Thông thường, nếu các tập tin khác mở ra ngoài ba loại trên được mở theo mặc định, chúng sẽ bắt đầu bằng 3 và tăng dần.

Chúng ta có thể chuyển hướng 3 standard filestreams nên có thể lấy input từ một file hoặc một command khác thay vì từ bàn phím, và chúng ta cũng có thể viết output và error ra file hoặc gửi chúng như một input của lệnh tiếp theo. Ví dụ, có một chương trình được gọi là `do_something` có thể đọc **stdin** và viết **stdout**, **stderr**, chúng ta sẽ thay đổi **input source**:</br>
`do_something < input-file`</br>

Nếu bạn muốn gửi output tới file:</br>
`do_something > output-file`</br>

Bạn có thể pipe output của một command hoặc program khác như một input</br>
`command1 | command2 | command3`

## Search for file

Tiện ích `locate` thực hiện tìm kiếm thông qua cơ sở dữ liệu của file và thư mục được xây dựng trước đó trên hệ thống của bạn, matching với tất cả các mục có chưa chuỗi ký tự được chỉ định. `locate` sử dụng database được tạo bởi một chương trình khác là updatedb. Hầu hết các hệ thống linux đều chạy tự động mỗi ngày một lần. Tuy nhiên, bạn có thể update bất cứ lúc nào bằng việc chạy updatedb với user root

```sh
sudo apt-get install -y mlocate
sudo updatedb
sudo locate zip
```
Một ví dụ muốn tìm tất cả các file có đường dẫn chứa từ zip và trong danh sách output từ lệnh trên, hiển thị tất cả các dòng có chứ từ bin để rút ngắn danh sách đó, ta sẽ đưa vào pipe như sau:

```sh
locate zip | grep bin
/bin/bunzip2
/bin/bzip2
/bin/bzip2recover
/bin/gunzip
/bin/gzip
/lib/firmware/qed/qed_init_values_zipped-8.10.10.0.bin
/lib/firmware/qed/qed_init_values_zipped-8.10.5.0.bin
/lib/firmware/qed/qed_init_values_zipped-8.15.3.0.bin
/lib/firmware/qed/qed_init_values_zipped-8.20.0.0.bin
/lib/firmware/qed/qed_init_values_zipped-8.33.1.0.bin
/lib/firmware/qed/qed_init_values_zipped-8.4.2.0.bin
/lib/firmware/qed/qed_init_values_zipped-8.7.3.0.bin
/snap/core/4917/bin/bunzip2
/snap/core/4917/bin/bzip2
/snap/core/4917/bin/bzip2recover
/snap/core/4917/bin/gunzip
/snap/core/4917/bin/gzip
/snap/core/4917/usr/bin/gpg-zip
/snap/core/4917/usr/lib/klibc/bin/gunzip
/snap/core/4917/usr/lib/klibc/bin/gzip
/snap/core/5742/bin/bunzip2
/snap/core/5742/bin/bzip2
/snap/core/5742/bin/bzip2recover
/snap/core/5742/bin/gunzip
/snap/core/5742/bin/gzip
/snap/core/5742/usr/bin/gpg-zip
/snap/core/5742/usr/lib/klibc/bin/gunzip
/snap/core/5742/usr/lib/klibc/bin/gzip
/snap/gnome-3-26-1604/70/usr/bin/preunzip
/snap/gnome-3-26-1604/70/usr/bin/prezip
/snap/gnome-3-26-1604/70/usr/bin/prezip-bin
/snap/gnome-3-26-1604/70/usr/share/man/man1/prezip-bin.1.gz
/snap/gnome-3-26-1604/74/usr/bin/preunzip
/snap/gnome-3-26-1604/74/usr/bin/prezip
/snap/gnome-3-26-1604/74/usr/bin/prezip-bin
/snap/gnome-3-26-1604/74/usr/share/man/man1/prezip-bin.1.gz
/usr/bin/funzip
/usr/bin/gpg-zip
/usr/bin/mzip
/usr/bin/preunzip
/usr/bin/prezip
/usr/bin/prezip-bin
/usr/bin/unzip
/usr/bin/unzipsfx
/usr/bin/zip
/usr/bin/zipcloak
/usr/bin/zipdetails
/usr/bin/zipgrep
/usr/bin/zipinfo
/usr/bin/zipnote
/usr/bin/zipsplit
/usr/lib/klibc/bin/gunzip
/usr/lib/klibc/bin/gzip
/usr/share/man/man1/prezip-bin.1.gz
```

wildcards được sử dụng để search cho các filename bao gồm các ký tự đặc biệt

|Wildcards|Result|
|---------|------|
|?|Matches bất kỳ một ký tự đơn nào|
|* |Matches bất kỳ một chuỗi ký tự nào|
|[set]|Khớp với bất kỳ ký tự nào nằm trong tập ký tự [set]|
|[!set]|Khớp với bất kỳ ký tự nào không nằm trong tập [set]|

Ví dụ liệt kê tất cả các file bắt đầu bằng bất ký chuỗi nào nhưng có kết thúc sau dấu `.` có 3 ký tự bất kỳ

```sh
ls *.???
file1.txt  file2.txt  file4.txt
```

Liệt kê tất cả các file chứ ít nhất một ký tự trong khoảng từ 0-9

```sh
ls *[0-9]*
file1.txt  file2.txt  file4.txt
```

Liệt kê tất cả các file không bắt đầu bằng ký tự f

`ls [!f]*`

`find` cực kỳ hữu dụng và thường được sử dụng trong cuộc sống hằng ngày của quản Linux system admnistrator. Muốn tìm tất cả các file có phần mở rộng là `.log` trong thư mục `/var` sử dụng lệnh sau:

`find /var -name *.log`

Khi không có đối số, `find` sẽ list tất cả các file trong thư mục hiện tại và trong tất cả các các thư mục con của nó.

Tìm kiếm các file hoặc thư mục tên là abv

`find /home/ngocquang -name abc`

Thêm tùy chọn `-type d` để chỉ tìm các thư mục hoặc `-type f` để chỉ tìm các file và `-type l` là symbolic links có tên `acb`

`find /home/ngocquang -type d -name abc`

Để tìm kiếm và xóa tất cả các file kết thúc là .swp:

```sh
find -name "*.swp" -exec rm {} ’;’
find -name "*.swp" -ok rm {} \;
```

Nếu muốn sắp xếp kết quả tìm kiếm theo các thuộc tính như ngày được tạo, lần sử dụng cuối cùng,... hoặc dựa trên kích thước

- Tìm kiếm dựa trên thời gian. Tìm tất cả các file có trạng thái thay đổi lần cuối trong 3 ngày trước

`find / -ctime 3`

- Tìm kiếm dựa trên kích thước file, tìm kiếm các file có kích thước lớn hơn 10MB

`find / -size +10M`

## Manage files

|Command|Usage|
|-------|-----|
|cat|Sử dụng để xem các file không quá dài|
|tac|Sử dụng để xem các file từ cuối lên, bắt đầu là dòng cuối cùng|
|less|Sử dụng để xem các chương trình lớn hơn vì nó cho phép phân trang|
|tail|Mặc định sẽ show ra 10 dòng, nếu muốn xem nhiều hơn thêm tùy chọn n 15|
|head|Ngược lại với tail, show ra 10 dòng đầu tiên của file|

`touch`ngoài việc tạo ra một file mới, thì `touch` còn dùng để set hoặc update các thời gian access, change và modify của files.

Set thời gian cho file với time stamp 4 p.m, March 20th (03 20 1600)

`touch -t 03201600 <filename>`

`mkdir` tạo một thư mục, `rmdir` xóa một thư mục, nếu thư mục không rỗng sử dụng lệnh `rm -rf <thư muc>`. Cận thận khi dùng lệnh này với thư mục `root(/)`

## Compare file

Sử dụng `diff` để so sánh nội dung các file và thư mục

## Tiện ích tập tin

Trong Linux, phần mở rộng của một tập tin. Người ta không thể giả định rằng một tập tin có tên `file1.txt` là một tập tin văn bản và không phải là một chương trình thực thi. Trong Linux, tên tệp thường có ý nghĩa hơn đối với người dùng hệ thống; trên thực thế hầu hết các ứng dụng trực tiếp kiểm tra nội dung của một file để xem loại đối tượng nào thay vì dựa vào phần mở rộng. Bản chất của một file có thể được xác định chắc chắn bằng cách sử dụng tiện ích file. Đối với tên tệp được đặt làm đối số, nó kiểm tra nội dung và các đặc điểm nhất định để xác định xem các file là văn bản, thư viện chia sẻ, chương trình thực thi, tệp lệnh hay cái gì khác.

```sh
$ file /etc/resolv.conf
/etc/resolv.conf: ASCII text
```
