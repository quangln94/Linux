Tìm hiểu Bash Shell in Linux
BashLinuxShell
Bash Shell là gì?
GNU Bourne-Again SHell (BASH) kết hợp các tính năng từ C Shell (csh) và Korn Shell (ksh) và tuân thủ các thông số kỹ thuật shell POSTIX 2. Nó cung cấp một giao diện dòng lệnh (CLI) để làm việc trên các hệ thống * nix và là shell phổ biến nhất được sử dụng trên các hệ thống Linux.

Bash's Configuration Files
Trong thư mục home có 3 file có ý nghĩa đặc biệt với bash, cho phép bạn tự động set up môi trường khi bạn log in và gọi tới Bash shell khác, và cho bạn thực thi câu lệnh khi bạn log out. Bash mặc định /etc/profile.

.bash_profile : Đọc và thực hiện các lệnh trong nó mỗi khi đăng nhập hệ thống
.bashrc : Đọc mà thực hiện mỗi lần khi bắt đầu một subshell
.bash_logout : Đọc và thực hiện mỗi lần thoát khỏi shell
Bash cho phép có thể tồn tại 2 file khác tương tự như .bash_profile là : .bash_login và .profile. Mỗi khi login thì chỉ có 1 file được đọc. Nếu không có file .bash_profile thì nó sẽ tìm file .bash_login. Nếu file .bash_login cũng không có thì nó mới tìm tới file .profile. Trong trường hợp bạn muốn thực thi lệnh nào đó bất kể bạn đăng nhập hay không đăng nhập thì bạn có thể thêm nó vào file .bashrc. Ví dụ đối với những bạn coder thì thao tác thường duyên như pull code, push code, tạo nhánh, check out. Những công việc mà lặp đi lặp lại hằng ngày, mà chúng ta muốn tiết kiệm thời gian thì có thể set alias theo cách của chúng ta trong những file cấu hình này. Nó sẽ tiết kiệm được kha khá thời gian của chúng ta.

Khi sửa đổi 1 file cấu hình chúng ta có thể dùng lệnh

source file 
hoặc
source .file
để đọc các lệnh trong file chúng ta mới thay đổi.

Interactive shells
1.What is an interactive shell?

Là bất kì quá trình nào bạn sử dụng để nhập lệnh và lấy kết quả đầu ra từ các lệnh đó. Do đó log in shell là interactive. Ngược lại, khi bạn chạy một kịch bản, một non-interactive được bắt đầu cái mà sẽ chạy những lệnh trong kịch bản đó và sau đó thoát nó khi đã xong.

Ta có thể test với kí tự đặc biết "-", nó bao gồm "i" khi shell là interactive.

FRAMGIA\nguyen.thai.son@framgia0157-pc:~$ echo $-
result: himBH
2.Interactive shell behavior

Một số sự khác biệt trong interactive mode:

Với mỗi loại thì chúng sẽ đọc tệp startup file là khác nhau (/etc/profile, /etc/bashrc, ~/.bash_profile, ~/.bashrc, ...)
Job controll được bật mặc định.
Lệnh được mặc định đọc từ command line sử dụng readline.
Alias expansion được bật.
Command history mặc định được bật. Lịch sử được lưu trong tệp trỏ tới bơi HISTFILE khi thoát shell. Mặc định HISTFILE trỏ tới ~/.bash_history.
Bash kiểm tra mail định kì.,
Bash có thể được cấu hình để thoát khỏi nó khi gặp các biến không được tham chiếu. Ở chế độ interative thì cái này bị tắt.
Tự động thoát sau một khaongr thời gian được chỉ định trong biến TMOUT.
Aliases
Một alias có thể hiểu nôm na là một chuỗi được thay thế có một dòng lệnh hoặc một cụm các dòng lệnh. ví dụ:

alias gpod="git pull origin develop"
thay vì việc phải gõ

git pull origin develop
thì ta có thể gõ.

gpod
Hoặc ta có thể lồng alias vào trong 1 alias khác.

 alias gcod="git checkout develop"
 alias gpfd="git pull framgia develop"
 alias gco="git checkout"
 alias grd="git rebase develop"
 
 #get latest pull and run bundle install, migrate
 alias gud="gcod;gpfd;gco task;grd;bundle install;rake db:migrate"
ở trên là một tập hợp các lệnh, Lệnh cuối cùng bao gồm nhiều alias ở trên, Thay vì phải gõ 5 6 lệnh thì chúng ta có thể gõ đúng 1 lệnh duy nhất có 3 từ

gud
Việc này giúp chúng ta cũng tiết kiệm thời gian và tay đỡ to hơn một tí 😄.

Conclusion
Trên đây là một chút tìm hiểu của mình về bash shell. Mình nghĩ nó sẽ giúp ích rất nhiều trong công việc lập trình hằng ngày của những coder như mình. Hi vọng gặp lại các bạn ở những bài sau. Cảm ơn vì đã đọc bài. (bow)

tham khảo: http://www.tldp.org/LDP/Bash-Beginners-Guide/html.

http://www.hypexr.org/bash_tutorial.php
https://viblo.asia/p/tim-hieu-bash-shell-in-linux-bJzKmXvP59N
