Giới thiệu:
Iptables là một ứng dụng firewall, được cài đặt mặc định trên hầu hết các phiên bản của các distro lõi Linux (ví dụ: Ubuntu, Kubuntu, Xubuntu, CentOS…) . Sau khi iptables được cài đặt mà chưa cấu hình, nó cũng mặc định cho phép tất cả các gói tin qua lại bình thường mà không cản trở gì cả. Thông thường, iptables được cài đặt ở usr/sbin/iptables, tuy nhiên, người dùng có thể gọi iptables lên bằng lệnh iptables. Iptables yêu cầu quyền root để có thể thực thi.
Có rất nhiều tài liệu về iptables, nhưng về cơ bản thì có thể hiểu như vậy.
Cách dùng:
Bài viết sẽ hướng dẫn cách cấu hình iptables qua các ví dụ, câu lệnh và case study cụ thể, dễ hiểu và có thể thực hành luôn.
1. Liệt kê các rule trong danh sách đang được kích hoạt:
Mã:
[B]sudo iptables –L[/B]

Như đã phân tích phía trên, để thực thi được iptables cần cần root, đó là lý do có lệnh sudo ở đầu.
Nếu mới cài đặt server, chưa cấu hình gì cả thì kết quả sẽ tương tự như sau:
Mã:
[B]Chain INPUT (policy ACCEPT)[/B]
[B]target     prot opt source               destination[/B]
 
[B]Chain FORWARD (policy ACCEPT)[/B]
[B]target     prot opt source               destination[/B]
 
[B]Chain OUTPUT (policy ACCEPT)[/B]
[B]target     prot opt source               destination[/B]

 
2. Xóa tất cả các rule trong danh sách đã được cấu hình.
Mã:
[B]sudo iptables –F[/B]

3. Lưu các rules trong danh sách
Mã:
[B]sudo service iptables save[/B]

4. Chặn tất cả các truy cập từ một IP bất kỳ:
Giả sử sau khi đọc log truy cập, bạn phát hiện các dấu hiệu tấn công DoS từ kẻ tấn công có địa chỉ IP là: 113.171.18.109 (Lưu ý: Đây không phải là IP tấn công thực tế, mà chỉ là tình huống giả định) . Nếu muốn chặn các request từ IP này, gõ:
Mã:
[B]sudo iptables -A INPUT -s 113.171.18.109 -j DROP[/B]

5. Chặn truy cập từ tất cả các port “lạ”
Iptables hoạt động theo thứ tự từ trên xuống dưới của danh sách (hay rules chain). Do vậy, ta sẽ cấu hình để iptables chấp nhận những port ta cần sử dụng như 22 (ssh), 80 (http), 443 (https), và sau đó “khóa” tất cả các port còn lại.
- Cấu hình chấp nhận established sessions:
Mã:
[B]sudo iptables -A INPUT -m conntrack –ctstate ESTABLISHED,RELATED -j ACCEPT[/B]

Với cấu hình trên, iptables sẽ chấp nhận những giao thức để người dùng thiết lập bắt tay ba bước…
- Cấu hình chấp nhận port ssh:
Mã:
[B]sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT[/B]

Giải thích một chút: với dòng lệnh trên trên, iptables thêm vào cuối INPUT chain một rule với nội dung: kiểm tra giao thức, nếu là tcp, tiến hành kiểm tra port, nếu là port 22 => đồng ý để gói tin đi qua và không kiểm tra những rule phía dưới nữa.
- Cấu hình chấp nhận port 80:
Mã:
[B]sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT[/B]

- Cấu hình chấp nhận port 443:
Mã:
[B]sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT[/B]

- Kiểm tra INPUT chain hiện tại:
Gõ lệnh:
Mã:
[B]sudo iptables -L[/B]

Kết quả:
Mã:
[B]Chain INPUT (policy ACCEPT)[/B]
[B]target     prot opt source               destination[/B]
[B]ACCEPT     all  --  anywhere             anywhere            state RELATED,ESTABLISHED[/B]
[B]ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:ssh[/B]
[B]ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:www[/B]

 
- Dễ thấy, bất kỳ một gói tin nào lọt qua được INPUT chain phía trên cũng có thể coi là “port” lạ, thuộc diện khả nghi. Đến bây giờ, ta chỉ việc thêm vào cuối INPUT chain một rule để block tất cả các gói tin khả nghi này.
Mã:
[B]sudo iptables -A INPUT -j DROP[/B]

- Nếu làm theo hướng dẫn bên trên, INPUT chain sẽ có nội dung tương tự như sau:
Gõ lệnh:
Mã:
[B]sudo iptables -L[/B]

Kết quả:
Mã:
[B]Chain INPUT (policy ACCEPT)[/B]
[B]target     prot opt source               destination[/B]
[B]ACCEPT     all  --  anywhere             anywhere            state RELATED,ESTABLISHED[/B]
[B]ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:ssh[/B]
[B]ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:www[/B]
[B]DROP       all  --  anywhere             anywhere[/B]

6. Trong ví dụ dưới đây, chúng ta sẽ sử dụng iptables để chống một mẫu DDoS đơn giản:
- Cùng phân tích đoạn lệnh dưới đây:
Mã:
[B]iptables -I INPUT 1 -p tcp --dport 80 -m limit --limit 20/minute --limit-burst 70 -j ACCEPT[/B]

Đoạn lệnh này sẽ thêm vào đầu của INPUT chain một rule có nội dung:
Kiểm tra khi một IP cố tình tạo ra đủ 70 kết nối vào cổng 80 (http) tới server thì bắt đầu hạn chế IP đó, chỉ cho phép 20 kết nối trong 1 phút. Những kết nối khác sẽ bị gián đoạn.




# Reference
https://vpssim.vn/1635-bao-ve-vpsserver-chong-lai-ddos-bang-iptables-hoac-csf.html
https://whitehat.vn/threads/phong-chong-tan-cong-su-dung-iptables.4933/
