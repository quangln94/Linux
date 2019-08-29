<img src=https://i.imgur.com/W7cdVft.png>
<img src=https://i.imgur.com/3inYLes.png>
<img src=https://i.imgur.com/yZkV1NR.png>

- Kiểm tra thông số hiển thị thông qua việc giám sát bandwidth trên cổng eth0.
Sử dụng lệnh iperf thực hiện đầy băng thông cổng eht0 lên 3.21Gbits/s 
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
Vì sao lại thế thì [tham khảo tại đây](# http://xahoithongtin.vnmedia.vn/trai-nghiem/download/201403/tai-sao-o-cung-hien-thi-sai-dung-luong-trong-windows-487440/)



# http://xahoithongtin.vnmedia.vn/trai-nghiem/download/201403/tai-sao-o-cung-hien-thi-sai-dung-luong-trong-windows-487440/
