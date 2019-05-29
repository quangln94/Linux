# Sử dụng lệnh TOP để theo dõi hiệu năng máy chủ Linux

Lệnh top là một lệnh hết sức đơn giản, tuy nhiên lại cực kỳ hiệu quả trong việc quản lý tài nguyên như: CPU, RAM, I/O.

Để sử dụng, trước hết ta cần SSH vào Server hoặc VPS.

Sau khi đã truy cập được vào hệ thống, ta tiến hành gõ lệnh sau:
```sh
top 
```
Màn hình sẽ hiện thị ra thông số của Máy chủ hiện tại như sau:
<img src=https://i.imgur.com/VFrOxte.png>

Lệnh `top` sẽ hiện thị ra rất nhiều thống số của server như: uptime, load average v.v. tại phần đầu tiên của thông báo


– Dòng đầu tiên sẽ thể hiện thời gian của server:

Thời gian hoạt động hiện tại: 08:05:45
Thời gian uptime: 23 ngày
Số lượng user đang login: 2 user
Load average của server trong 1/5/15 phút: 0.00 0.00 0.00
Thông thường với một máy chủ có 1 Core CPU, không sử dụng Hyper Threading thì ngưỡng hoạt động trong 1 phút của hệ thống sẽ là khoảng 0.7, Nếu Load average của vượt quá ngưỡng trên cần kiểm tra lại xem process nào đang overload hoặc có phương hướng nâng cấp tài nguyên của hệ thống lên thêm nữa.
– Tại dòng 2 Task: Thông tin các tiến trình đang hoạt động trên hệ thống.

– Tại dòng 3 Phần trăm CPU: Bao gồm các thông số sau.

%us: %CPU được dùng cho từng tiến trình của User.
%sy: %CPU được dùng cho từng tiến trình của hệ thống.
%ni: %CPU dành cho low-priority processes.
%id: %CPU ở trạng thái nghỉ.
%wa: %CPU đang trong thời gian chờ I/O.
%hi: %CPU được dành cho phần cứng khi bị gián đoạn.
%si: %CPU được dành cho phần mềm khi bị gián đoạn.
%st: %CPU ảo chờ đợi CPU thực xử lý các process.
– Tại dòng 4 là thông tin về RAM.

– Tại dòng 5 là thông tin về SWAP.

* Tại phần tiếp theo, Lệnh top sẽ hiển thị ra thông số của một số tiến trình đang hoạt động:

TOP-03

PID: Process ID
User: User thực hiện Process trên.
PR: Độ ưu tiên của Process.
NI: Giá trị nice value của tiến trình, giá trị âm tăng độ ưu tiên của Process, giá trị dương giảm độ ưu tiên của Process.
VIRT: Dung lượng RAM ảo cho việc thực hiện Process.
RES: Dung lượng RAM thực chạy Process.
SHR: Dung lượng RAM share cho Process.
S : Trạng thái Process đang hoạt động.
%CPU: %CPU được sử dụng cho Process.
%RAM: %RAM được dùng cho Process.
TIME+: Tổng thời gian thực hiện 1 Process.
COMMAND: Tên của Process.

# Tài liệu tham khảo
https://tailieu.123host.vn/kb/vps/huong-dan-su-dung-lenh-top-de-theo-doi-hieu-nang-may-chu-linux.html
