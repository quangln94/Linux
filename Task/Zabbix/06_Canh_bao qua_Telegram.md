# Cấu hình gửi cảnh báo ZABBIX qua Telegram
Để gửi cảnh báp qua telegram bạn cần có  `bot telegram`.
## 1. Tạo bot telegram
Để tạo bot bạn click https://telegram.me/BotFather. Tiếp theo click vào `SEND MESSAGE`.
<img src=https://i.imgur.com/47l8F4W.png>

Sau đó tiến hành chat với bot telegram này
Để tạo bot

```sh
/newbot
```
Đặt tên cho bot telegram. Lưu ý tên phải là chữ thường và phải được kết thúc bằng `bot`

```sh
namebot
```
Đặt username cho bot

```sh
namebot
```
Sau khi tạo xong kết quả sẽ trả về một chuỗi các ký tự. Nó là token của bot. Ví dụ dãy token sẽ là 
```sh
877870930:XXXX-snEJ9cXXXXXXXXXXX9c2qsXRsD4HOg
```
Lưu lại chuỗi token này để khi báo khi gửi cảnh báo
## 2. Cấu hình alert scripts telegram
### 2.1 Download scripts alert telegram
Vào thưc mục để chứa scripts và download scripts về.
```
cd /usr/lib/zabbix/alertscripts
wget https://raw.githubusercontent.com/domanhduy/zabbix-monitor/master/Alert/TelegramV1/zabbix-telegram.sh
chmod +x zabbix-telegram.sh
```
## 2.2 Set user nhận alert qua Tetegram
Mỗi user muốn nhận cảnh báo zabbix gửi về telegram ta phải lấy được `CHAT ID` Telegram của người dùng đó.
https://api.telegram.org/bot${TOKEN}/getUpdates
Với `${TOKEN}` là cả chuỗi token API mà khi tạo `bot telegram` trả về ở trên.
Chat trên Telegram ở kênh của mình vừa tạo và F5 trình duyệt sẽ thấy thông tin vừa chat, sẽ lấy được CHAT ID.

## 3. Cấu hình cảnh báo telegram trên Web Zabbix
Truy cập vào zabbix server trên trình duyệt web
Vào `Administration` -> `Media types` -> `Create media type`
![](https://github.com/niemdinhtrong/thuctapsinh/blob/master/NiemDT/Ghichep-zabbix/images/telegram/3.png)
Trong đó: 
 * Name: bạn đặt tên tùy ý
 * Type: chọn kiểu Script
 * Script name: tên của script (ở đây là tên của script down về ở bước trên)
 * Script parameters: bạn thêm vào 3 thông số sau
    * {ALERT.SENDTO}
    * {ALERT.SUBJECT}
    * {ALERT.MESSAGE}

Sau đó click add

Để có thể nhận được cảnh báo về telegram của bạn thì bạn cần phải có ID telegram của bạn. Để lấy được ID bạn vào **chat** bất kỳ thông tin gì vào bot telegram của bạn sau đó bạn truy cập bào địa chỉ 

https://api.telegram.org/bot`TOKEN`/getUpdates

Trong đó TOKEN là token của bạn. Nó sẽ trả về ID.

Thiết lập user nhận cảnh báo

Click `Administration` -> `User` sau đó click vào user nhận cảnh báo

![](https://github.com/niemdinhtrong/thuctapsinh/blob/master/NiemDT/Ghichep-zabbix/images/telegram/4.png)

ở đây tôi sẽ nhận cảnh báo ở user Admin. Tôi click vào user `Admin` -> `Media` -> `Add`

![](https://github.com/niemdinhtrong/thuctapsinh/blob/master/NiemDT/Ghichep-zabbix/images/telegram/5.1.png)

Trong đó

 * Type: bạn chọn media type bạn tạo bên trên
 * Send to: điền id telegram của bạn
 * When active: khoảng thời gian gửi cảnh báo
 * Use if severity: Những loại cảnh báo muốn gửi

Tích vào `Enabled` và sau đó click `Add`

Click `Update`

![](https://github.com/niemdinhtrong/thuctapsinh/blob/master/NiemDT/Ghichep-zabbix/images/telegram/6.png)

Vào `Configuration`-> `Action` -> `Create action`

Điền tên của action

![](https://github.com/niemdinhtrong/thuctapsinh/blob/master/NiemDT/Ghichep-zabbix/images/telegram/7.png)

Chọn `Operations` để cấu hình gửi cảnh báo khi có vấn đề

![](https://github.com/niemdinhtrong/thuctapsinh/blob/master/NiemDT/Ghichep-zabbix/images/telegram/8.png)

Thêm user bạn muốn gửi cảnh báo (user đã thiết lập lúc trước). Sau đó click `add`. Bạn có thể thay đổi nội dung, và tiêu đề gửi cảnh báo ở mục `Default subject` và `Default message` ở đây tôi đển mặc định.

Sau đó click vào `Recovery operations` để cấu hình gửi thông báo khi vấn đề được giải quyết. Bên đây ta cũng cấu hình tương tự như ơt `Operations`

![](https://github.com/niemdinhtrong/thuctapsinh/blob/master/NiemDT/Ghichep-zabbix/images/telegram/9.1.png)

Sau đó click `Add` ở dưới để hoàn thành

Bạn sẽ thấy action vừa tạo

![](https://github.com/niemdinhtrong/thuctapsinh/blob/master/NiemDT/Ghichep-zabbix/images/telegram/10.png)

**Kiểm tra gửi cảnh báo**

Tôi tạo 1 trigger để test việc gửi cảnh báo

![](https://github.com/niemdinhtrong/thuctapsinh/blob/master/NiemDT/Ghichep-zabbix/images/telegram/11.png)

Dùng lệnh `zabbix_sender` để gửi giá trị vượt quá ngưỡng để zabbix server gửi cảnh báo tôi sẽ thấy trong telegram 

# Reference
- https://blogcloud365vn.github.io/monitor/zabbix4-thiet-lap-canh-bao-qua-telegram/
- https://github.com/niemdinhtrong/thuctapsinh/blob/master/NiemDT/Ghichep-zabbix/labs/gui-canh-bao-telegram.md
