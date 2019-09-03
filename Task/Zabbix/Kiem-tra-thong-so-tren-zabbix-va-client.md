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

Vì sao lại là 2.98 mà không phải 3.21. Là vì cách tính khác nhau như sau ***(Cái này do suy đoán cá nhân và cần phải kiểm chứng lại :D )***:
```sh
3.21*(1000*1000*1000)/(1024*1024*1024)=2.98
```
Vì sao lại thế thì [tham khảo tại đây](http://xahoithongtin.vnmedia.vn/trai-nghiem/download/201403/tai-sao-o-cung-hien-thi-sai-dung-luong-trong-windows-487440/)

## 3. Kiểm tra CPU trên host

Sử dụng lênh `stress` thực hiện đẩy tải như sau:
```sh
stress -c 1
```
<img src=https://i.imgur.com/gySCJSH.png>

Process có PID=8761 đang sử dụng 100% CPU, `%CPU(s)=49.9 us` bằng với giá trị hiển thị trên zabbix web
<img src=https://i.imgur.com/qPWHWLI.png>

## 4. Kiểm tra RAM trên host
Trước khi đẩy tải thực hiện kiểm tra trên host và zabbix-web
<img src=https://i.imgur.com/L9rtZw0.png>
<img src=https://i.imgur.com/HvO8uHy.png>

Thực hiện đẩy RAM bằng lệnh sau: 
```sh
stress -m 1 --vm-bytes 500M
```
<img src=https://i.imgur.com/z3qYSN3.png>
Kiểm tra giá trị thấy trên host gần bằng trên zabbix-web
<img src=https://i.imgur.com/2cFtIQD.png>

Tuy nhiên thực hiện trên lab với lượng RAM thấp (2GB) thì độ chênh lệch giữa zabbix-server và client khá nhỏ. Nên tôi không dám chắc là phần chênh nhau do cách tính Available khác nhau hay không.

Để kiểm chứng điều này, đổi với hệ thống lớn phần Available Memory giữa client và zabbix-web, các bạn hãy thử kiểm tra thêm phần Available Memory trên Zabbix-web = Cached + Available trên host. [Tham khảo thêm tại đây](https://www.zabbix.com/documentation/4.0/manual/appendix/items/vm.memory.size_params)


## Kết luật

Zabbix là phần mềm giám sát cung cấp thông số khá là chính xác. Bạn có thể yên tâm khi sử dụng.

Tuy nhiên vẫn có sự chênh lệch thông số giữa Zabbix-web và trên host thực tế do 1 vài lí do sau:
- Cách tính toán thông số thông qua item có thể khác với trên host. VÌ thế bạn phải kiểm tra xem item đó lấy giá trị từ đâu hay lấy như thế nào.
- 1 thông số trong item đó là `Update interval`. Việc bạn lấy thông số 1 cách liên tục hay sau 1 khoảng thời gian dài cũng có thể dẫn đến tình trạng thông số khác nhau giữa host và zabbix-web. Ví dụ: Bạn set 1 item với `Update interval=5m`. Tại thời điểm `5m` giá trị là `a` nhưng tại thời điểm `5.2m` trên zabbix-web vẫn hiển thị là `a` nhưng trên host giá trị đó lại là `b`.


# Tài liệu tham khảo 
- http://xahoithongtin.vnmedia.vn/trai-nghiem/download/201403/tai-sao-o-cung-hien-thi-sai-dung-luong-trong-windows-487440/
- https://www.zabbix.com/documentation/4.0/manual/config/items/itemtypes/zabbix_agent
- https://zabbix.com/documentation/4.0/manual/appendix/items/vm.memory.size_params
