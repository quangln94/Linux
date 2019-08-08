# Tạo trigger và Action trong Zabbix.
## 1. Tạo trigger
**Có thể tạo trigger trực tiếp cho mỗi `host` hoặc add vào `Template` tùy vào nhu cầu của mình.**
- ***Vào `Template` chọn `Template` muốn add `trigger` chọn `trigger` sau đó chọn `Create Trigger`***
<img src=https://i.imgur.com/0pjxKEf.png>
**Trong đó:**
`Name`: Tên trigger
`Severity`: Mức độ cảnh báo
`Expression:` Điều kiện xuất hiện cảnh báo
Tại `Expression` chọn Add
<img src=https://i.imgur.com/fQVRk9m.png>
**Trong đó:**
`Item`: Chọn `Item` mà `trigger` sẽ được add vào
`Functiont`: Điều kiện để `trigger` xảy ra
`Last of (T)`: 
Với tham số là `Count`: Số lần thực hiện `Function` trong khoảng thời gian là `Time shift`
Với tham số là `Time`: Số lần thực hiện `Time shift`
`Time shift`: Khoảng thời gian giữa các lần thực hiện `Funtion`
`Result`: Điều kiện để `trigger` thực hiện cảnh báo.
- ***Chọn `add`.***
