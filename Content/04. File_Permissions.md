# File Permissons

Trong Linux và Unix, mỗi file đều có một user sở hữu gọi là owner. Mỗi file cũng sẽ có một group sở hữu, những người trong group này có các quyền nhất định: read, write và execute.

|Command|Result|
|-------|------|
|chown|Thay đổi người sở hữu file và thư mục|
|chgrp|Thay đổi group sở hữu|
|chmod|Thay đổi quyền trên file hoặc thư mục|

Files có 3 kiểu permission: read(r), write(w), execute(x). Chúng thường được biểu diễn theo thứ tự rwx. Các quyền này ảnh hưởng tới các nhóm của người sở hữu: user(u), group(g), và others(o). Kết quả là bạn có 3 nhóm như sau:

|rwx:|rwx:|rwx|
|----|----|---|
|u:|g:|o|

Lệnh `chmod`</br>
`chmod [option] [permission] [name file/directory]`

Phần permision có 3 kiểu:

Kiểu ký tự: `rw-rw-r--`
Kiểu ugo: Phân quyền cho từng đối tượng (u+x: user thêm quyền thực thi)
Kiểu số: `rwxrw-r` = `764`
Một số quy ước cho kiểu ugo

|Operator||	
|--------|-|
|+|Thêm quyền|
|-|Bỏ quyền|
|=|Gán quyền|

|Owner||
|-----|-|
|a|u+g+o|
|u|user owner|
|g|group owner|
|o|other user|

Một ví dụ:</br>
`chmod a=-,u+rwx,g+rwsx,u-w`</br>
Phân tích lệnh trên: đầu tiên bỏ toàn bộ quyền cho cả 3 nhóm(u, g, o), sau đó thêm quyền `rwx` cho user sở hữu, thêm quyền `rwsx` cho group sở hữu, sau đó lại bỏ quyền `w`cho user

Có một số cách khác nhau để sử dụng lệnh `chmod`. Ví dụ: để cho phép chủ sở hữu quyền thực thi

```sh
$ ls -l test1
-rw-rw-r-- 1 joy caldera 1601 Mar 9 15:04 test1
$ chmod u+x test1
$ ls -l test1
-rwxrw-r-- 1 joy caldera 1601 Mar 9 15:04 test1
```

Loại cú pháp này có thể khó gõ và ghi nhớ, vì vậy, người ta thường sử dụng một cách viết tắt cho phép bạn thiết lập tất cả các quyền trong một bước. Điều này được thực hiện với một thuật toán đơn giản, và một chữ số duy nhất đủ để xác định tất cả ba bit quyền cho mỗi thực thể. Chữ số này là tổng của
- 4 nếu muốn quyền đọc.
- 2 nếu muốn quyền viết.
- 1 nếu muốn quyền thực thi.

Như vậy 7 có nghĩa là đọc + ghi + thực thi, 6 có nghĩa là đọc + ghi, và 5 có nghĩa là đọc + thực thi.</br>
Khi bạn áp dụng điều này cho lệnh `chmod`, bạn phải cung cấp ba chữ số cho mỗi mức độ tự do, chẳng hạn như trong
```sh
$ chmod 755 test1
$ ls -l test1
-rwxr-xr-x 1 joy caldera 1601 Mar 9 15:04 test1
```

Quyền sở hữu nhóm được thay đổi bằng cách sử dụng lệnh `chgrp`
```sh
# ll /home/mina/myfile.txt
-rw-rw-r--. 1 mina caldera 679 Feb 19 16:51 /home/mina/myfile.txt
# chgrp root /home/mina/myfile.txt
# ll /home/mina/myfile.txt
-rw-rw-r--. 1 mina root 679 Feb 19 16:51 /home/mina/myfile.txt
```

Kiểu dùng ký tự để phân quyền

|Permission|Name|Note|
|----------|----|----|
|r|read|owner có quyền đọc file|
|x|execute|owner có quyền thực thi đối với file, với thư mục thì được phép sử dụng lệnh cd để truy cập|
|s|setuid hoặc setgid|Tất cả các file và thư mục con sẽ được kế thừa group owner|
|t|sticky bit|Chỉ có owners mới có thể rename và xóa file trong tất cả các file của directory|
|-|Không set quyền|	

Với quyền `execute(x)`

||Không có suid|Có suid|
|-|--------------|-------|
|Không có execute|-|S|
|Có execute|x|s|

Ví dụ: `o+rws` cho phép user sở hữu có full quyền đồng thời set suid

Quy ước kiểu số:

|Permision|Binary|Number|
|---------|------|------|
|---|000|0|
|--x|001|1|
|-w-|010|2|
|-wx|011|3|
|r--|100|4|
|r-x|101|5|
|rw-|110|6|
|rwx|111|7|

Ngoài ra người ta sử dụng thêm một bit thứ 4 để biểu diễn `suid`, `sgid` và `sticky bit`

|Permision|Number|
|---------|------|
|suid|4000|
|sgid|2000|
|sticky|1000|

Mặc định thì khi set permision cho thư mục thì sẽ có tính kế thư cho các file và các thư mục con

Default Permisions</br>
umask

Group sudo</br>
File cấu hình sudo nằm ở:
```sh
/etc/sudoes
/etc/sudoes.d/
```

Dòng `%sudo ALL=(ALL:ALL) ALL` có nghĩa là `group sudo` có quyền thực thi tất cả các lệnh. Muốn `user` có quyền của `group sudo` thì thêm vào nhóm này. Ví dụ thêm `group uet` để các thành viên đều có quyền thực thi tất cả các lệnh thì thêm dòng `%uet ALL=(ALL:ALL) ALL`

Lệnh tạo 1 group: `groupadd uet` sau đó thêm user abc vào group này: `usermod -G uet abc`

Kiểm tra lại xem mình đã trong group đó chưa: `groups abc`
