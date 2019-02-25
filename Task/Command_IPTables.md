# Config IPTables
## Cách dùng:
### 1. Liệt kê các rule trong danh sách đang được kích hoạt:
```sh
iptables –L
```
 
###2. Xóa tất cả các rule trong danh sách đã được cấu hình.
```
iptables –F
```
### 3. Lưu các rules trong danh sách
```sh
service iptables save
```
### 4. Chặn tất cả các truy cập từ một IP bất kỳ:
Giả sử sau khi đọc log truy cập, bạn phát hiện các dấu hiệu tấn công DoS từ kẻ tấn công có địa chỉ IP là: 113.171.18.109 (Lưu ý: Đây không phải là IP tấn công thực tế, mà chỉ là tình huống giả định) . Nếu muốn chặn các request từ IP này, gõ:
```sh
-A INPUT -s IP-ADDRESS -j DROP
```
### 5. Chặn truy cập từ tất cả các port lạ
Iptables hoạt động theo thứ tự từ trên xuống dưới của danh sách (hay rules chain). Do vậy, ta sẽ cấu hình để iptables chấp nhận những port ta cần sử dụng như 22 (ssh), 80 (http), 443 (https), và sau đó “khóa” tất cả các port còn lại.
- Cấu hình chấp nhận established sessions:
```sh
-A INPUT -m conntrack –ctstate ESTABLISHED,RELATED -j ACCEPT
```
Với cấu hình trên, iptables sẽ chấp nhận những giao thức để người dùng thiết lập bắt tay ba bước…
- Cấu hình chấp nhận port ssh:
```sh
-A INPUT -p tcp --dport 22 -j ACCEPT
```
Giải thích một chút: với dòng lệnh trên trên, iptables thêm vào cuối INPUT chain một rule với nội dung: kiểm tra giao thức, nếu là tcp, tiến hành kiểm tra port, nếu là port 22 => đồng ý để gói tin đi qua và không kiểm tra những rule phía dưới nữa.
- Cấu hình chấp nhận port 80:
```sh
-A INPUT -p tcp --dport 80 -j ACCEPT
```
- Cấu hình chấp nhận port 443:
```
-A INPUT -p tcp --dport 443 -j ACCEPT
```
- Kiểm tra INPUT chain hiện tại:
Gõ lệnh:
```sh
iptables -L
```
Kết quả:
```sh
[B]Chain INPUT (policy ACCEPT)[/B]
[B]target     prot opt source               destination[/B]
[B]ACCEPT     all  --  anywhere             anywhere            state RELATED,ESTABLISHED[/B]
[B]ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:ssh[/B]
[B]ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:www[/B]
```
- Dễ thấy, bất kỳ một gói tin nào lọt qua được INPUT chain phía trên cũng có thể coi là “port” lạ, thuộc diện khả nghi. Đến bây giờ, ta chỉ việc thêm vào cuối INPUT chain một rule để block tất cả các gói tin khả nghi này.
```sh
-A INPUT -j DROP
```
- Nếu làm theo hướng dẫn bên trên, INPUT chain sẽ có nội dung tương tự như sau:
Gõ lệnh:
```sh
iptables -L
```
Kết quả:
```sh
[B]Chain INPUT (policy ACCEPT)[/B]
[B]target     prot opt source               destination[/B]
[B]ACCEPT     all  --  anywhere             anywhere            state RELATED,ESTABLISHED[/B]
[B]ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:ssh[/B]
[B]ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:www[/B]
[B]DROP       all  --  anywhere             anywhere[/B]
```
### 6. Trong ví dụ dưới đây, chúng ta sẽ sử dụng iptables để chống một mẫu DDoS đơn giản:
- Cùng phân tích đoạn lệnh dưới đây:
```sh
-I INPUT 1 -p tcp --dport 80 -m limit --limit 20/minute --limit-burst 70 -j ACCEPT[/B]
```
Đoạn lệnh này sẽ thêm vào đầu của INPUT chain một rule có nội dung:
Kiểm tra khi một IP cố tình tạo ra đủ 70 kết nối vào cổng 80 (http) tới server thì bắt đầu hạn chế IP đó, chỉ cho phép 20 kết nối trong 1 phút. Những kết nối khác sẽ bị gián đoạn.

Sử dụng iptables để chống lại DOS
-A : Append
-p : Protocol
--dport : For ports
-m limit : To limit iptables extension
--limit 25/minute : Defines maximum of 25 connection per minute.
--limit-burst 100 : The limit/minute will be enforced only after the total number of connection have reached the limit-burst level, ie 100 here.
-j : Target
IPTable rule:

iptables -A INPUT -p tcp --dport 80 -m limit --limit 25/minute --limit-burst 100 -j ACCEPT
Lệnh trên nghĩa là khi IP silent đạt tới 100 kết nối tới Server thì bắt đầu hạn chế cho phép 25 kết nối trong 1 phút. Nếu kết nối nhiều hơn sẽ bị block.

ví dụ:

root@test [~]# iptables -L -n
Chain INPUT (policy ACCEPT)
target     prot opt source               destination
acctboth   all  --  0.0.0.0/0            0.0.0.0/0
ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           tcp dpt:80 limit: avg 25/min burst 100
Bảo vệ Server/VPS bằng CSF
Ta edit file csf.conf trong etc/csf.conf . ta có thể dùng trình soạn thảo vi hoặc dùng winscp hay filezilla vào trực tiếp chỉnh sửa csf.conf

vi /etc/csf/csf.conf
ta sẽ chỉnh giá trị CT_LIMIT

# To disable this feature, set this to 0

CT_LIMIT = "50"
50 là giá trị tối đa mà một IP có thể kết nối tới server. bạn cũng cần chỉnh cả các cổng cho CSF theo dõi

# Leave this option empty to count all ports against CT_LIMIT
CT_PORTS = "80,53,22"
Khởi động lại CSF

csf -r
Tham khảo một số giá trị CT trong CSF mà ta có thể chỉnh sửa:
# Connection Tracking interval. Set this to the the number of seconds between
# connection tracking scans
CT_INTERVAL = "30"

# Send an email alert if an IP address is blocked due to connection tracking
CT_EMAIL_ALERT = "1"

# If you want to make IP blocks permanent then set this to 1, otherwise blocks
# will be temporary and will be cleared after CT_BLOCK_TIME seconds
CT_PERMANENT = "0"

# If you opt for temporary IP blocks for CT, then the following is the interval
# in seconds that the IP will remained blocked for (e.g. 1800 = 30 mins)
CT_BLOCK_TIME = "1800"

# If you don't want to count the TIME_WAIT state against the connection count
# then set the following to "1"
CT_SKIP_TIME_WAIT = "0"

# If you only want to count specific states (e.g. SYN_RECV) then add the states
# to the following as a comma separated list. E.g. "SYN_RECV,TIME_WAIT"
#
# Leave this option empty to count all states against CT_LIMIT
CT_STATES = ""


# Reference
https://vpssim.vn/1635-bao-ve-vpsserver-chong-lai-ddos-bang-iptables-hoac-csf.html
https://whitehat.vn/threads/phong-chong-tan-cong-su-dung-iptables.4933/
https://thachpham.com/linux-webserver/iptables-linux-toan-tap.html
