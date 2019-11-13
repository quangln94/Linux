# Cài đặt Variables cho Grafana cơ bản
## 1. Tạo Dardbroad
- Chọn `+` sau đó chọn `Dashbroad settings`
<img src=https://i.imgur.com/xlz72bp.png>
- Đặt tên cho `Dashbroad` tại trường `Name`
<img src=https://i.imgur.com/MHI2xqi.png>
- Chọn xuống mục `Variables` chọn `Creater Variables`
<img src=https://i.imgur.com/SlvyDcI.png>
- Nhập các thông số cho mục này
<img src=https://i.imgur.com/oy40S4V.png>

**Trong đó:**</br>
***Ở mục `General`***</br>
`Name`: tên biến</br>
`Label:` tên hiển thị của biến</br>
`Type:` Query</br>
***Ở mục `Query Option`***: Nơi các `query` sẽ trỏ đến.</br>
`Data source:` chọn Zabbix do đây đang là thiết lập cho Zabbix. </br>
`Query:` Chọn `*` nếu muốn lấy tất cả các giá trị cần `query`</br>
`Regex:`</br>
- Chọn `Add`</br>
- Sau khi tạo xong ta sẽ có 1 `Variables` như sau:</br>
<img src=https://i.imgur.com/tMPXRX0.png>
- Tiếp tục làm  tương tự với biến tiếp theo. 
<img src=https://i.imgur.com/zm93PSa.png>

***Chú ý:*** Ở mục `Query Option`. Trường `Query` trỏ đến biến `group` vừa tạo ở trên để lấy `query.
- Sau khi tạo xong biến tiếp theo ta có thể thấy các biến được liệt kê như dưới đây. Dầu mũi tên ngoài cùng bên phải chỉ mối quán hệ giữa các biến. 
<img src=https://i.imgur.com/Nl4ixik.png>
- Thứ tự từ trên xuống dưới của biến cũng được sắp xếp như trong `Dashbroad`
<img src=https://i.imgur.com/oqdVeUX.png>
