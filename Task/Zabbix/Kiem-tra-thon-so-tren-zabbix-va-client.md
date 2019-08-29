# Để kiểm tra xem các thông số hiển thị trên Zabbix web có giống với trên host không. Ta làm 1 số ví dụ sau:

## 1. Check free disk bằng việc tạo ra 1 file 2.1G bằng lệnh dd như sau:
- Đầu tiên ta kiểm tra disk đang free là 17.27G
<img src=https://i.imgur.com/W7cdVft.png>

Sau đó ta tạo 1 file ung lượng 2.1G bằng lệnh `dd` nhu sau:
<img src=https://i.imgur.com/3inYLes.png>

-Kiêm tra sự thay đổi trên zabbix-web
<img src=https://i.imgur.com/yZkV1NR.png>

Ta thấy disk free tụt khoảng 2.1G => Vậy thông số hiển thị khá chính xác.

## 2. Kiểm tra băng thông trên cổng `eth0`
- Đầu tiên ta sử dụng 1 item để tính toán băng thông trên cổng `eth0` bằng cách cộng lưu lượng vào ra trên cồng `eth0` sử dụng item caculated.
- Kiểm tra thông số hiển thị thông qua việc giám sát bandwidth trên cổng eth0.
- Sử dụng lệnh iperf thực hiện đầy băng thông cổng eht0 lên 3.21Gbits/s 
```sh
iperf -c 10.10.10.221 -t 300s
```
<img src=https://i.imgur.com/sKR7M2C.png>

Kiểm tra trên zabbix web

<img src=https://i.imgur.com/cQdGYKt.png>

Giá trị hiển thị là 2.98Gbits/s.

Vì sao lại là 2.98 mà không phải 3.21. Là vì cách tính khác nhau như sau:
```sh
3.21*(1000*1000*1000)/(1024*1024*1024)=2.98
```
Vì sao lại thế thì [tham khảo tại đây](http://xahoithongtin.vnmedia.vn/trai-nghiem/download/201403/tai-sao-o-cung-hien-thi-sai-dung-luong-trong-windows-487440/)

# Tài liệu tham khảo 
- http://xahoithongtin.vnmedia.vn/trai-nghiem/download/201403/tai-sao-o-cung-hien-thi-sai-dung-luong-trong-windows-487440/
