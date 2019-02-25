# IP Tables
## I. Giới thiệu về IP Tables
Iptables là Firewall được cấu hình và hoạt động trên nền Console rất nhỏ và tiện dụng, Iptables do Netfilter Organiztion viết ra để tăng tính năng bảo mật trên hệ thống Linux. Iptables cung cấp các tính năng sau:
- Tích hợp tốt với kernel của Linux.
- Có khả năng phân tích package hiệu quả.
- Lọc package dựa vào MAC và một số cờ hiệu trong TCP Header.
- Cung cấp chi tiết các tùy chọn để ghi nhận sự kiện hệ thống.
- Cung cấp kỹ thuật NAT.
- Có khả năng ngăn chặn một số cơ chế tấn công theo kiểu DoS.
## II. Install Iptables
### 1. Install
Iptables thường được cài đặt mặc định trong hệ thống. Nếu chưa được cài đặt:</br>
Cài đặt trên ubuntu: `$ apt-get install iptables`</br>
Cài đặt trên Redhat/CentOS: `$ yum install iptables`</br>
CentOS 7 sử dụng FirewallD làm tường lửa mặc định thay vì Iptables. Nếu bạn muốn sử dụng Iptables thực hiện:</br>
```sh
# systemctl mask firewalld
# systemctl enable iptables
# systemctl enable ip6tables
# systemctl stop firewalld
# systemctl start iptables
# systemctl start ip6tables
```
Kiểm tra Iptables đã được cài đặt trong hệ thống:
Trên CentOS:
```sh
# rpm -q iptables
iptables-1.4.7-16.el6.x86_64
# iptables --version
iptables v1.4.7
```
Trên Ubuntu:
```
# iptables --version
iptables v1.6.0
```
Lưu ý: Trước khi cài đặt trên Ubuntu, bạn cần vô hiệu ufw để tránh xung đột do ufw và iptables đều là tường lửa mặc định.
```sh
# ufw disable
```
– Check tình trạng của Iptables, cũng như cách bật tắt services trên CentOS
```sh
# service iptables status
# service iptables start
# service iptables stop
# service iptables restart
```
– Khởi động Iptables cùng hệ thống
```sh
# chkconfig iptables on
```
Trên Ubuntu, Iptables là chuỗi lệnh không phải là 1 services nên bạn không thể start, stop hay restart. Một cách đơn giản để vô hiệu hóa là bạn xóa hết toàn bộ các quy tắc đã thiết lập bằng lệnh flush:
```sh
# iptables -F
```
### 2. Các nguyên tắc áp dụng trong Iptables
Để bắt đầu, bạn cần xác định các services muốn đóng/mở và các port tương ứng.</br>
Ví dụ, với một website và mail server thông thường:</br>
- Để truy cập VPS bằng SSH, bạn cần mở port SSH – 22.
- Để truy cập website, bạn cần mở port HTTP – 80 và HTTPS – 443.
- Để gửi mail, bạn sẽ cần mở port SMTP – 22 và SMTPS – 465/587
- Để người dùng nhận được email, bạn cần mở port POP3 – 110, POP3s – 995, IMAP – 143 và IMAPs – 993

Sau khi đã xác định được các port cần mở, bạn cần thiết lập các quy tắc tường lửa tương ứng để cho phép.

Bạn có thể xóa toàn bộ các quy tắc firewall mặc định để bắt đầu từ đầu: # iptables -F

Mình sẽ hướng dẫn các bạn xem và hiểu các quy tắc của iptables. Liệt kê các quy tắc hiện tại:

# iptables -L
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
ACCEPT     all  --  anywhere             anywhere            state RELATED,ESTABLISHED
ACCEPT     icmp --  anywhere             anywhere
ACCEPT     all  --  anywhere             anywhere
ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:ssh
REJECT     all  --  anywhere             anywhere            reject-with icmp-host-prohibited
ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:http
ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:https
ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:smtp
ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:urd
ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:pop3
ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:pop3s
ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:imap
ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:imaps
Chain FORWARD (policy ACCEPT)
target     prot opt source               destination
REJECT     all  --  anywhere             anywhere            reject-with icmp-host-prohibited

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
Cột 1: TARGET hành động sẽ được áp dụng cho mỗi quy tắc

Accept: gói dữ liệu được chuyển tiếp để xử lý tại ứng dụng cuối hoặc hệ điều hành
Drop: gói dữ liệu bị chặn, loại bỏ
Reject: gói dữ liệu bị chặn, loại bỏ đồng thời gửi một thông báo lỗi tới người gửi
Cột 2: PROT (protocol – giao thức) quy định các giao thức sẽ được áp dụng để thực thi quy tắc, bao gồm all, TCP hay UDP. Các ứng dụng SSH, FTP, sFTP… đều sử dụng giao thức TCP.

Cột 4, 5: SOURCE và DESTINATION địa chỉ của lượt truy cập được phép áp dụng quy tắc.

3. Cách sử dụng Iptables để mở port VPS
Để mở port trong Iptables, bạn cần chèn chuỗi ACCEPT PORT. Cấu trúc lệnh để mở port xxx như sau:

# iptables -A INPUT -p tcp -m tcp --dport xxx -j ACCEPT
A tức Append – chèn vào chuỗi INPUT (chèn xuống cuối)
hoặc

# iptables -I INPUT -p tcp -m tcp --dport xxx -j ACCEPT
I tức Insert- chèn vào chuỗi INPUT (chèn vào dòng chỉ định rulenum)
Để tránh xung đột với rule gốc, các bạn nên chèn rule vào đầu, sử dụng -I

3.1. Mở port SSH
Để truy cập VPS qua SSH, bạn cần mở port SSH 22. Bạn có thể cho phép kết nối SSH ở bất cứ thiết bị nào, bởi bất cứ ai và bất cứ dâu.

# iptables -I INPUT -p tcp -m tcp --dport 22 -j ACCEPT
Mặc định sẽ hiển thị ssh cho cổng 22, nếu bạn đổi ssh thành cổng khác thì iptables sẽ hiển thị số cổng

ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:ssh
Bạn có thể chỉ cho phép kết nối VPS qua SSH duy nhất từ 1 địa chỉ IP nhất định (xác định dễ dàng bằng cách truy cập các website check ip hoặc lệnh # w)

# iptables -I INPUT -p tcp -s xxx.xxx.xxx.xxx -m tcp --dport 22 -j ACCEPT
Khi đó, trong iptables sẽ thêm rule

ACCEPT     tcp  --  xxx.xxx.xxx.xxx       anywhere            tcp dpt:ssh
3.2. Mở port Web Server
Để cho phép truy cập vào webserver qua port mặc định 80 và 443:

# iptables -I INPUT -p tcp -m tcp --dport 80 -j ACCEPT
# iptables -I INPUT -p tcp -m tcp --dport 443 -j ACCEPT
Mặc định Iptables sẽ hiển thị HTTP và HTTPS

ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:http
ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:https
3.3. Mở port Mail
– Để cho phép user sử dụng SMTP servers qua port mặc định 25 và 465:

# iptables -I INPUT -p tcp -m tcp --dport 25 -j ACCEPT
# iptables -I INPUT -p tcp -m tcp --dport 465 -j ACCEPT
Mặc định Iptables sẽ hiển thị SMTP và URD

ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:smtp
ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:urd
– Để user đọc email trên server, bạn cần mở port POP3 (port mặc định 110 và 995)

# iptables -A INPUT -p tcp -m tcp --dport 110 -j ACCEPT
# iptables -A INPUT -p tcp -m tcp --dport 995 -j ACCEPT
Mặc định Iptables sẽ hiển thị POP3 và POP3S

ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:pop3
ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:pop3s
Bên cạnh đó, bạn cũng cần cho phép giao thức IMAP mail protocol (port mặc định 143 và 993)

# iptables -A INPUT -p tcp -m tcp --dport 143 -j ACCEPT
# iptables -A INPUT -p tcp -m tcp --dport 993 -j ACCEPT
Mặc định Iptables sẽ hiển thị IMAP và IMAPS

ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:imap
ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:imaps
3.4. Chặn 1 IP truy cập
# iptables -A INPUT -s IP_ADDRESS -j DROP
– Chặn 1 IP truy cập 1 port cụ thể:

#iptables -A INPUT -p tcp -s IP_ADDRESS –dport PORT -j DROP
Sau khi đã thiết lập đầy đủ, bao gồm mở các port cần thiết hay hạn chế các kết nối, bạn cần block toàn bộ các kết nối còn lại và cho phép toàn bộ các kết nối ra ngoài từ VPS

# iptables -P OUTPUT ACCEPT
# iptables -P INPUT DROP
Sau khi đã thiết lập xong, bạn có thể kiểm tra lại các quy tắc

# service iptables status
Hoặc

# iptables -L –n
-n nghĩa là chúng ta chỉ quan tâm mỗi địa chỉ IP . Ví dụ, nếu chặn kết nối từ hocvps.com thì iptables sẽ hiển thị là xxx.xxx.xxx.xxx với tham số -n
Cuối cùng, bạn cần lưu lại các thiết lập tường lửa Iptables nếu không các thiết lập sẽ mất khi bạn reboot hệ thống. Tại CentOS, cấu hình được lưu tại /etc/sysconfig/iptables.

# iptables-save | sudo tee /etc/sysconfig/iptables
Hoặc

# service iptables save
iptables: Saving firewall rules to /etc/sysconfig/iptables:[ OK ]


# Reference
https://hocvps.com/iptables/
