# IP Tables
## I. Tổng quan về 
### 1.1 Giới thiệu về IPTables
Iptables là Firewall được cấu hình và hoạt động trên nền Console rất nhỏ và tiện dụng, Iptables do Netfilter Organiztion viết ra để tăng tính năng bảo mật trên hệ thống Linux. Iptables cung cấp các tính năng sau:
- Tích hợp tốt với kernel của Linux.
- Có khả năng phân tích package hiệu quả.
- Lọc package dựa vào MAC và một số cờ hiệu trong TCP Header.
- Cung cấp chi tiết các tùy chọn để ghi nhận sự kiện hệ thống.
- Cung cấp kỹ thuật NAT.
- Có khả năng ngăn chặn một số cơ chế tấn công theo kiểu DoS.

### 1.2 Các bảng trong Iptables

IPtable gồm có 5 bảng với với mục đích và thứ tự xử lý khác nhau. Thứ tự xử lý các gói tin được mô tả cơ bản trong bảng sau:

#### Filter Table

Filter là bảng được dùng nhiều nhất trong IPtables. Bảng này dùng để quyết định xem có nên cho một gói tin tiếp tục đi tới đích hoặc chặn gói tin này lại (lọc gói tin). Đây là chức năng chính của IPtables.

#### NAT Table

Bảng NAT được dùng để NAT địa chỉ IP, khi các gói tin đi vào bảng này, gói tin sẽ được kiểm tra xem có cần thay đổi và sẽ thay đổi địa chỉ nguồn, đích của gói tin như thế nào.

Bảng này được sử dụng khi có một gói tin từ một kết nối mới gửi đến hệ thống, các gói tin tiếp theo của kết nối này sẽ được áp rule và xử lý tương tự như gói tin đầu tiên mà không cần phải đi qua bảng NAT nữa.

#### Mangle Table

Bảng mangle dùng để điều chỉnh một số trường trong IP header như TTL (Time to Live), TOS (Type of Serivce) dùng để quản lý chât lượng dịch vụ (Quality of Serivce)... hoặc dùng để đánh dấu các gói tin để xử lý thêm trong các bảng khác.

#### Raw Table

Theo mặc định, iptables sẽ lưu lại trạng thái kết nối của các gói tin, tính năng này cho phép iptables xem các gói tin rời rạc là một kết nối, một session chung để dễ dàng quản lý. Tính năng theo dõi này được sử dụng ngay từ khi gói tin được gởi tới hệ thống trong bảng raw.

Với bảng raw, ta có thể bật/tắt tính năng theo dõi này đối với một số gói tin nhất định, các gói tin được đánh dấu NOTRACK sẽ không được ghi lại trong bảng connection tracking nữa.

#### Security Table

Bảng security dùng để đánh dấu policy của SELinux lên các gói tin, các dấu này sẽ ảnh hưởng đến cách thức xử lý của SELinux hoặc của các máy khác trong hệ thống có áp dụng SELinux. Bảng này có thể đánh dấu theo từng gói tin hoặc theo từng kết nối.

### 1.3 Các chain trong tables

Mỗi một table đều có một số chain của riêng mình, sau đây là bảng cho biết các chain thuộc mỗi table

|Tables/Chain|PREROUTING|INPUT|FORWARD|OUTPUT|POSTROUTING|
|------------|----------|-----|-------|------|-----------|
|RAW|x|||x||
|MANGLE|x|x|x|x|x|
|DNAT|x|||x||
|FILTER||x|x|x||
|SECURITY||x|x|x||
|SNAT||x|||x|

- **INPUT** – Chain này dùng để kiểm soát hành vi của những các kết nối tới máy chủ. Ví dụ một user cần kết nối SSH và máy chủ, iptables sẽ xét xem IP và port của user này có phù hợp với một rule trong chain INPUT hay ko.
- **FORWARD** – Chain này được dùng cho các kết nối chuyển tiếp sang một máy chủ khác (tương tự như router, thông tin gởi tới router sẽ được forward đi nơi khác). Ta chỉ cần định tuyến hoặc NAT một vài kết nối (cần phải forward dữ liệu) thì ta mới cần tới chain này.
- **OUTPUT** – Chain này sẽ xử lý các kết nối đi ra ngoài. Ví dụ như khi ta truy cập google.com, chain này sẽ kiểm tra xem có rules nào liên quan tới http, https và google.com hay không trước khi quyết định cho phép hoặc chặn kết nối.
- **PREROUTING** –Header của gói tin sẽ được chỉnh sửa tại đây trước khi việc routing được diễn ra.
- **POSTROUTING** – Header của gói tin sẽ được chỉnh sửa tại đây sau khi việc routing được diễn ra.

### 1.4 Các RULE trong CHAIN 

Các rule là tập điều kiện và hành động tương ứng để xử lý gói tin (ví dụ ta sẽ tạo một rule chặn giao thức FTP, drop toàn bộ các gói tin FTP được gởi đến máy chủ). Mỗi chain sẽ chứa rất nhiều rule, gói tin được xử lý trong một chain sẽ được so với lần lượt từng rule trong chain này.

Cơ chế kiểm tra gói tin dựa trên rule vô cùng linh hoạt và có thể dễ dàng mở rộng thêm nhờ các extension của IPtables có sẵn trên hệ thống. Rule có thể dựa trên protocol, địa chỉ nguồn/đích, port nguồn/đích, card mạng, header gói tin, trạng thái kết nối... Dựa trên những điều kiện này, ta có thể tạo ra một tập rule phức tạp để kiểm soát luồng dữ liệu ra vào hệ thống.

Mỗi rule sẽ đươc gắn một hành động để xử lý gói tin, hành động này có thể là:

- **ACCEPT:** gói tin sẽ được chuyển tiếp sang bảng kế tiếp.
- **DROP:** gói tin/kết nối sẽ bị hủy, hệ thống sẽ không thực thi bất kỳ lệnh nào khác.
- **REJECT:** gói tin sẽ bị hủy, hệ thống sẽ gởi lại 1 gói tin báo lỗi ICMP – Destination port unreachable
- **LOG:** gói tin khớp với rule sẽ được ghi log lại.
- **REDIRECT:** chuyển hướng gói tin sang một proxy khác.
- **MIRROR:** hoán đổi địa chỉ IP nguồn, đích của gói tin trước khi gởi gói tin này đi.
- **QUEUE:** chuyển gói tin tới chương trình của người dùng qua một module của kernel.

### 1.5. Các trạng thái của kết nối

Đây là những trạng thái mà hệ thống connection tracking (module conntrack của IPtables) theo dõi trạng thái của các kết nối:

***NEW:*** Khi có một gói tin mới được gởi tới và không nằm trong bất kỳ connection nào hiện có, hệ thống sẽ khởi tạo một kết nối mới và gắn nhãn NEW cho kết nối này. Nhãn này dùng cho cả TCP và UDP.

***ESTABLISHED:*** Kết nối được chuyển từ trạng thái NEW sang ESTABLISHED khi máy chủ nhận được phản hồi từ bên kia.
RELATED: Gói tin được gởi tới không thuộc về một kết nối hiện có nhưng có liên quan đến một kết nối đang có trên hệ thống. Đây có thể là một kết nối phụ hỗ trợ cho kết nối chính, ví dụ như giao thức FTP có kết nối chính dùng để chuyển lệnh và kết nối phụ dùng để truyền dữ liệu.

***INVALID:*** Gói tin được đánh dấu INVALID khi gói tin này không có bất cứ quan hệ gì với các kết nối đang có sẵn, không thích hợp để khởi tạo một kết nối mới hoặc đơn giản là không thể xác định được gói tin này, không tìm được kết quả trong bảng định tuyến.

***UNTRACKED:*** Gói tin có thể được gắn hãn UNTRACKED nếu gói tin này đi qua bảng raw và được xác định là không cần theo dõi gói này trong bảng connection tracking.

***SNAT:*** Trạng thái này được gán cho các gói tin mà địa chỉ nguồn đã bị NAT, được dùng bởi hệ thống connection tracking để biết khi nào cần thay đổi lại địa chỉ cho các gói tin trả về.

***DNAT:*** Trạng thái này được gán cho các gói tin mà địa chỉ đích đã bị NAT, được dùng bởi hệ thống connection tracking để biết khi nào cần thay đổi lại địa chỉ cho các gói tin gởi đi.

Các trạng thái này giúp người quản trị tạo ra những rule cụ thể và an toàn hơn cho hệ thống.

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

Sau khi đã xác định được các port cần mở, bạn cần thiết lập các quy tắc tường lửa tương ứng để cho phép.</br>
Bạn có thể xóa toàn bộ các quy tắc firewall mặc định để bắt đầu từ đầu: `# iptables -F`</br>
Xem và hiểu các quy tắc của iptables. Liệt kê các quy tắc hiện tại:</br>

```sh
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
```
Cột 1: TARGET hành động sẽ được áp dụng cho mỗi quy tắc
- Accept: gói dữ liệu được chuyển tiếp để xử lý tại ứng dụng cuối hoặc hệ điều hành
- Drop: gói dữ liệu bị chặn, loại bỏ
- Reject: gói dữ liệu bị chặn, loại bỏ đồng thời gửi một thông báo lỗi tới người gửi

Cột 2: PROT (protocol – giao thức) quy định các giao thức sẽ được áp dụng để thực thi quy tắc, bao gồm all, TCP hay UDP. Các ứng dụng SSH, FTP, sFTP… đều sử dụng giao thức TCP.</br>
Cột 4, 5: SOURCE và DESTINATION địa chỉ của lượt truy cập được phép áp dụng quy tắc.</br>
### 3. Cách sử dụng Iptables để mở port VPS
```sh
iptables -A  -i <interface> -p <protocol (tcp/udp)> -s <source> --dport <port no.>  -j <target>
``` 
Trong đó: 
-A: thêm chain rules
-i <interface> là giao diện mạng bạn cần thực hiện lọc các gói tin
-p <protocol> là giao thức mạng thực hiện lọc (tcp/udp)
–dport <port no.> là cổng mà bạn muốn đặt bộ lọc

Để mở port trong Iptables, bạn cần chèn chuỗi ACCEPT PORT. Cấu trúc lệnh để mở port xxx như sau:</br>
**# iptables -A INPUT -p tcp -m tcp --dport xxx -j ACCEPT**
- `A` tức Append – chèn vào chuỗi INPUT (chèn xuống cuối)

hoặc</br>
**# iptables -I INPUT -p tcp -m tcp --dport xxx -j ACCEPT**
- `I` tức Insert - chèn vào chuỗi INPUT (chèn vào dòng chỉ định rulenum)

Để tránh xung đột với rule gốc, các bạn nên chèn rule vào đầu, sử dụng -I
#### 3.1. Mở port SSH
Để truy cập VPS qua SSH, bạn cần mở port SSH 22. Bạn có thể cho phép kết nối SSH ở bất cứ thiết bị nào, bởi bất cứ ai và bất cứ dâu.</br>
**# iptables -I INPUT -p tcp -m tcp --dport 22 -j ACCEPT**</br>
Mặc định sẽ hiển thị ssh cho cổng 22, nếu bạn đổi ssh thành cổng khác thì iptables sẽ hiển thị số cổng
```sh
ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:ssh
```
Bạn có thể chỉ cho phép kết nối VPS qua SSH duy nhất từ 1 địa chỉ IP nhất định (xác định dễ dàng bằng cách truy cập các website check ip hoặc lệnh `# w`)</br>
**# iptables -I INPUT -p tcp -s xxx.xxx.xxx.xxx -m tcp --dport 22 -j ACCEPT**</br>
Khi đó, trong iptables sẽ thêm rule</br>
```sh
ACCEPT     tcp  --  xxx.xxx.xxx.xxx       anywhere            tcp dpt:ssh
```
#### 3.2. Mở port Web Server
Để cho phép truy cập vào webserver qua port mặc định 80 và 443:</br>
**# iptables -I INPUT -p tcp -m tcp --dport 80 -j ACCEPT**</br>
**# iptables -I INPUT -p tcp -m tcp --dport 443 -j ACCEPT**</br>
Mặc định Iptables sẽ hiển thị HTTP và HTTPS
```sh
ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:http
ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:https
```
#### $3.3. Mở port Mail
– Để cho phép user sử dụng SMTP servers qua port mặc định 25 và 465:

**# iptables -I INPUT -p tcp -m tcp --dport 25 -j ACCEPT**</br>
**# iptables -I INPUT -p tcp -m tcp --dport 465 -j ACCEPT**</br>
Mặc định Iptables sẽ hiển thị SMTP và URD
```sh
ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:smtp
ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:urd
```
– Để user đọc email trên server, bạn cần mở port POP3 (port mặc định 110 và 995)

**# iptables -A INPUT -p tcp -m tcp --dport 110 -j ACCEPT**</br>
**# iptables -A INPUT -p tcp -m tcp --dport 995 -j ACCEPT**</br>
Mặc định Iptables sẽ hiển thị POP3 và POP3S
```sh
ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:pop3
ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:pop3s
```
Bên cạnh đó, bạn cũng cần cho phép giao thức IMAP mail protocol (port mặc định 143 và 993)</br>
**# iptables -A INPUT -p tcp -m tcp --dport 143 -j ACCEPT**</br>
**# iptables -A INPUT -p tcp -m tcp --dport 993 -j ACCEPT**</br>
Mặc định Iptables sẽ hiển thị IMAP và IMAPS
```sh
ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:imap
ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:imaps
```
#### 3.4. Chặn 1 IP truy cập
**# iptables -A INPUT -s IP_ADDRESS -j DROP**
– Chặn 1 IP truy cập 1 port cụ thể:
```sh
#iptables -A INPUT -p tcp -s IP_ADDRESS –dport PORT -j DROP
```
Sau khi đã thiết lập đầy đủ, bao gồm mở các port cần thiết hay hạn chế các kết nối, bạn cần block toàn bộ các kết nối còn lại và cho phép toàn bộ các kết nối ra ngoài từ VPS</br>
**# iptables -P OUTPUT ACCEPT**</br>
**# iptables -P INPUT DROP**</br>
Sau khi đã thiết lập xong, bạn có thể kiểm tra lại các quy tắc
```sh
# service iptables status
```
Hoặc
```sh
# iptables -L –n
```
`-n` nghĩa là chúng ta chỉ quan tâm mỗi địa chỉ IP. Ví dụ, nếu chặn kết nối từ hocvps.com thì iptables sẽ hiển thị là xxx.xxx.xxx.xxx với tham số `-n`</br>
Cuối cùng, bạn cần lưu lại các thiết lập tường lửa Iptables nếu không các thiết lập sẽ mất khi bạn reboot hệ thống. Tại CentOS, cấu hình được lưu tại `/etc/sysconfig/iptables`.
```sh
**# iptables-save | sudo tee /etc/sysconfig/iptables**
```
Hoặc
```sh
# service iptables save
iptables: Saving firewall rules to /etc/sysconfig/iptables:[ OK ]
```
# Reference
- https://hocvps.com/iptables/
- https://cloudcraft.info/gioi-thieu-ve-iptables/
- https://tech.bizflycloud.vn/tim-hieu-ve-iptables-phan-1-660.htm
- https://tech.bizflycloud.vn/iptables-phan-2-691.htm
