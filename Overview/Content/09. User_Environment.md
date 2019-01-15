# User Environment</br>
## User and Groups</br>
Linux là một hệ điều hành đa người dùng, nơi nhiều người dùng có thể đăng nhập cùng một lúc. Lệnh `who` liệt kê những người dùng hiện đang đăng nhập. Để xác định người dùng hiện tại, hãy sử dụng lệnh `whoami`
```sh
# who -a
           system boot  2015-02-17 13:28
LOGIN      tty1         2015-02-17 13:28               761 id=tty1
root     + pts/0        2015-02-17 13:29   .         12379 (10.10.10.246)
           run-level 3  2015-02-17 13:29
root     + pts/1        2015-02-17 17:37   .         18762 (10.10.10.246)
```
Linux sử dụng **groups** để tổ chức **user**. Groups là tập hợp các tài khoản có quyền được chia sẻ nhất định. Thành viên của groups được quản lý thông qua tệp `/etc/group`, hiển thị danh sách các nhóm và thành viên của nhóm. Theo mặc định, mọi người dùng đều thuộc về **default groups** hoặc **primary groups**. Khi user đăng nhập, user sẽ được thiết lập làm thành viên của group chính của họ và tất cả các thành viên đều có các quyền hạn giống nhau. Permission trên các file và thư mục có thể được sửa đổi theo cấp group.</br>
Tất cả User Linux được chỉ định một **User ID** duy nhất, **uid**, là một số nguyên, cũng như một hoặc nhiều Groups ID, gid, bao gồm một ID mặc định giống với User ID. Trong lịch sử, RedHat dựa trên distro bắt đầu uid bắt đầu từ 500. Bản phân phối khác bắt đầu từ 1000. Những con số này được kết hợp với tên thông qua tập tin `/etc/passwd` và `/etc/group`. Các nhóm được sử dụng để thiết lập một nhóm người dùng có chung mục đích, quyền truy cập và bảo mật. Quyền truy cập vào tệp và thiết bị được cấp trên cơ sở người dùng và nhóm mà họ thuộc về.</br>
Chỉ `user root` mới có thể thêm và xóa người dùng và nhóm. Việc thêm một user mới được thực hiện bằng lệnh `useradd` và loại bỏ một user hiện có được thực hiện bằng lệnh `userdel`. Ở dạng đơn giản nhất, một tài khoản cho user mới sẽ được thực hiện như sau:</br>
```sh
# useradd user1
# cat /etc/passwd | grep user1
adriano:x:1000:1000::/home/adriano:/bin/bash
# ls -lrta /home/adriano/
total 16
-rw-r--r--. 1 adriano adriano 231 Sep 26 03:53 .bashrc
-rw-r--r--. 1 adriano adriano 193 Sep 26 03:53 .bash_profile
-rw-r--r--. 1 adriano adriano  18 Sep 26 03:53 .bash_logout
drwxr-xr-x. 3 root    root     20 Feb 17 17:48 ..
-rw-------. 1 adriano adriano   9 Feb 17 17:49 .bash_history
drwx------. 2 adriano adriano  79 Feb 17 17:49 .
```
Mặc định thiết lập thư mục chính của User là `/home/user1`, điền nó với một số tệp cơ bản và đặt default shell thành `/bin/bash`.</br>
Xóa tài khoản người dùng bằng cách nhập:
```sh
# userdel adriano
# cat /etc/passwd | grep adriano
# ls -lrta /home/adriano/
total 16
-rw-r--r--. 1 1000 1000 231 Sep 26 03:53 .bashrc
-rw-r--r--. 1 1000 1000 193 Sep 26 03:53 .bash_profile
-rw-r--r--. 1 1000 1000  18 Sep 26 03:53 .bash_logout
drwxr-xr-x. 3 root root  20 Feb 17 17:48 ..
-rw-------. 1 1000 1000   9 Feb 17 17:49 .bash_history
drwx------. 2 1000 1000  79 Feb 17 17:49 .
```
Tuy nhiên, điều này sẽ để nguyên thư mục gốc. Điều này có thể hữu ích nếu nó là tạm thời không hoạt động. Để xóa thư mục chính trong khi xóa tài khoản, bạn cần sử dụng tùy chọn liên quan.
```sh
# userdel -r adriano
# cat /etc/passwd | grep adriano
# ls -lrta /home/adriano/
ls: cannot access /home/adriano/: No such file or directory
```
Lệnh `id` không có đối số cung cấp thông tin về người dùng hiện tại. Nếu đặt tên của một user khác làm đối số, id sẽ báo cáo thông tin về người dùng khác đó.
```sh
# id
uid=0(root) gid=0(root) groups=0(root)
# id adriano
uid=1000(adriano) gid=1000(adriano) groups=1000(adriano)
```
Sử dụng lệnh `passwd` để thay đổi mật khẩu cho user
```sh
# passwd adriano
Changing password for user adriano.
New password:
Retype new password:
passwd: all authentication tokens updated successfully.
```
Thêm một nhóm mới được thực hiện với lệnh `groupadd` và được gỡ bỏ bằng lệnh `groupdel`.
```sh
# groupadd newgroup
# groupdel newgroup
```
Thêm một user vào một group đã tồn tại được thực hiện với lệnh `usermod`. Việc xóa một user khỏi group sẽ phức tạp hơn.
```sh
# groupadd newgroup
# usermod -G newgroup adriano
# groups adriano
adriano : adriano newgroup
# usermod -g newgroup adriano
# groups adriano
adriano : newgroup
```
Tất cả các lệnh này cập nhật `/etc/group` nếu cần. Lệnh `groupmod` có thể được sử dụng để thay đổi các thuộc tính nhóm như `Group ID` hoặc tên
```sh
# groupmod newgroup -n newgoupname
# groups adriano
adriano : newgoupname
```
## User root</br>
User root có toàn quyền truy cập vào hệ thống. Các hệ điều hành khác thường gọi đây là tài khoản quản trị viên; trong Linux, nó thường được gọi là tài khoản superuser. Bạn phải cực kỳ thận trọng trước khi cấp user root cho người dùng. Các cuộc tấn công bên ngoài thường bao gồm các thủ thuật được sử dụng để nâng cấp lên uaaer root. Tuy nhiên, bạn có thể sử dụng tính năng sudo để gán nhiều quyền giới hạn hơn cho tài khoản người dùng thông thường:</br>
- chỉ trên cơ sở tạm thời.</br>
- chỉ cho một tập con cụ thể của các lệnh.

Khi gán quyền nâng cao, bạn có thể sử dụng lệnh su (switch user) để khởi động một shell mới đang chạy như một user khác (bạn phải nhập mật khẩu của user mà bạn dùng). Thông thường người dùng này là root, và shell mới cho phép sử dụng các đặc quyền nâng cao cho đến khi nó được thoát. Nó gần như không tốt(nguy hiểm cho cả an toàn và sự ổn định) thực hành sử dụng su để trở thành root. Lỗi kết quả có thể bao gồm xóa các tệp quan trọng khỏi hệ thống và vi phạm an ninh.</br>
## Startup Files</br>
Trong Linux, lệnh chương trình shell, thông thường `bash` sử dụng một hoặc nhiều tệp khởi động để cấu hình môi trường. Các tệp trong thư mục `/etc` xác định cài đặt chung cho tất cả user trong khi tệp khởi tạo trong thư mục home của user có thể bao gồm và hoặc ghi đè cài đặt chung. Các tệp khởi động có thể làm bất cứ điều gì người dùng muốn thực hiện trong mọi trình lệnh shell, chẳng hạn như:
- Tùy chỉnh lời nhắc của người dùng</br>
- Xác định các phím tắt dòng lệnh và aliases</br> 
- Đặt trình soạn thảo văn bản mặc định</br>
- Đặt đường dẫn cho nơi để tìm chương trình thực thi</br>

Khi bạn lần đầu đăng nhập vào Linux, tệp `/etc/profile` được đọc và đánh giá, sau đó các tệp sau được tìm kiếm theo thứ tự được liệt kê:

           1 ~/.bash_profile
           2 ~/.bash_login
           3 ~/.profile

Shell đăng nhập Linux đánh giá bất kỳ tệp khởi động nào mà nó xuất hiện trước và bỏ qua phần còn lại. Điều này có nghĩa là nếu nó tìm thấy ~ / .bash_profile, nó bỏ qua phần còn lại. Các bản phân phối khác nhau có thể sử dụng các tệp khởi động khác nhau. Tuy nhiên, mỗi khi bạn tạo một trình bao mới, hoặc cửa sổ đầu cuối, vv, bạn không thực hiện đăng nhập hệ thống đầy đủ; chỉ tập tin ~ / .bashrc được đọc và đánh giá. Mặc dù tệp này không được đọc và đánh giá cùng với shell đăng nhập, hầu hết các bản phân phối và/hoặc user đều chứa tệp ~ / .bashrc từ bên trong một trong ba tệp khởi động do người dùng sở hữu. Trong bản phát hành Ubuntu, openSuse và CentOS, người dùng phải thực hiện các thay đổi thích hợp trong tệp ~ / .bash_profile để bao gồm tệp ~ / .bashrc. ~ / .Bash_profile sẽ có một số dòng bổ sung, do đó sẽ thu thập các thông số tùy chỉnh bắt buộc từ ~ / .bashrc.</br>
# Environment variables</br>
Các biến môi trường được đặt tên đơn giản với số lượng có giá trị cụ thể và được hiểu bởi lệnh shell, chẳng hạn như bash. Một số trong số này được thiết lập trước bởi hệ thống, và một số khác được thiết lập bởi người dùng hoặc ở dòng lệnh hoặc trong khi khởi động và các kịch bản lệnh khác. Biến môi trường thực sự không quá một chuỗi ký tự chứa thông tin được sử dụng bởi một hoặc nhiều ứng dụng. Có một số cách để xem các giá trị của các biến môi trường được thiết lập hiện tại. Tất cả các lệnh set, env, hoặc export hiển thị các biến môi trường.</br>
Theo mặc định, các biến được tạo trong một tập lệnh chỉ có sẵn cho lệnh shell hiện tại. Tất cả các tiến trình con (sub-shell) sẽ không có quyền truy cập vào các giá trị đã được thiết lập hoặc sửa đổi. Cho phép các tiến trình con xem các giá trị, yêu cầu sử dụng lệnh xuất.</br>

|Task|Command|
|----|-------|
|Hiển thị giá trị của một biến cụ thể|echo $SHELL|
|Xuất một giá trị biến mới|export VAR=value|
|Thêm biến vĩnh viễn|Add the line export VAR=value to ~/.bashrc|

HOME là một biến môi trường đại diện cho thư mục home hoặc đăng nhập của user. Lệnh cd không có đối số sẽ thay đổi thư mục làm việc hiện tại thành giá trị HOME. Lưu ý ký tự dấu ngã (~) thường được sử dụng làm chữ viết tắt cho $ HOME.</br>
Biến môi trường PATH là một danh sách có thứ tự các thư mục được quét khi một lệnh được đưa ra để tìm chương trình hoặc tập lệnh thích hợp để chạy. Mỗi thư mục trong đường dẫn được phân tách bằng dấu hai chấm. Tên thư mục trống cho biết thư mục hiện tại tại bất kỳ thời điểm nào.
```sh
$ export PATH=$HOME/bin:$PATH
$ echo $PATH
/home/me/bin:/usr/local/bin:/usr/bin:/bin/usr
```
Biến môi trường PS (Câu lệnh Prompt) được sử dụng để tùy chỉnh chuỗi nhắc của bạn trong các cửa sổ đầu cuối để hiển thị thông tin bạn muốn. PS1 là biến nhắc chính mà kiểm soát lời nhắc dòng lệnh của bạn. Các ký tự đặc biệt sau đây có thể được bao gồm trong PS1:

Character	Usage
\u	User name
\h	Host name
\w	Current working directory
!	History number of this command
\d	Date
Chúng phải được bao quanh trong dấu nháy đơn khi chúng được sử dụng
```sh
# export PS1='\u@\h:\w$ '
root@caldera01:~$
root@caldera01:~$ export PS1='\d-\u@\h:\w$ '
Wed Feb 18-root@caldera01:~$
```
Command history
Các bash theo dõi các lệnh và câu lệnh đã nhập trước đó trong history buffer; bạn có thể gọi lại các lệnh đã sử dụng trước đó chỉ bằng cách sử dụng các phím con trỏ Lên và Xuống. Để xem danh sách các lệnh đã thực hiện trước đó, bạn có thể sử dụng lịch sử tại dòng lệnh. Danh sách các lệnh được hiển thị với lệnh gần đây nhất xuất hiện cuối cùng trong danh sách. Thông tin này được lưu trữ trong tập tin ~ / .bash_history. Một số biến môi trường có liên quan có thể được sử dụng để lấy thông tin về tệp lịch sử.
Variable	Usage
HISTFILE	stores the location of the history file
HISTFILESIZE	stores the maximum number of lines in the history file
HISTSIZE	stores the maximum number of lines in the history file for the current session
Bảng dưới đây cho thấy cú pháp được sử dụng để thực hiện các lệnh đã sử dụng trước đó
Syntax	Usage
!!	Execute the previous command
!	Start a history substitution
!$	Refer to the last argument in a line
!n	Refer to the n-th command line
!string	Refer to the most recent command starting with string
Creating Aliases
Các lệnh tùy chỉnh có thể được tạo ra để thay đổi hành vi của những cái đã tồn tại bằng cách tạo bí danh. Thông thường, các bí danh này được đặt trong tệp ~ / .bashrc của bạn để chúng có sẵn cho bất kỳ trình bao lệnh nào bạn tạo. Lệnh bí danh không có đối số sẽ liệt kê các bí danh hiện đang được xác định.
```s
$ alias
alias cp='cp -i'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias l.='ls -d .* --color=auto'
alias ll='ls -l --color=auto'
alias ls='ls --color=auto'
alias mv='mv -i'
alias rm='rm -i'
```
