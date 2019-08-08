# Tạo trigger và Action trong Zabbix.
## 1. Tạo trigger
**Có thể tạo trigger trực tiếp cho mỗi `host` hoặc add vào `Template` tùy vào nhu cầu của mình.**
- ***Vào `Template` chọn `Template` muốn add `trigger` chọn `trigger` sau đó chọn `Create Trigger`***
<img src=https://i.imgur.com/0pjxKEf.png>

**Trong đó:**</br>
`Name`: Tên trigger</br>
`Severity`: Mức độ cảnh báo</br>
`Expression:` Điều kiện xuất hiện cảnh báo</br>
- ***Tại `Expression` chọn Add***
<img src=https://i.imgur.com/fQVRk9m.png>

**Trong đó:**</br>
`Item`: Chọn `Item` mà `trigger` sẽ được add vào</br>
`Functiont`: Điều kiện để `trigger` xảy ra</br>
`Last of (T)`:</br>
    - Với tham số là `Count`: Số lần thực hiện `Function` trong khoảng thời gian là `Time shift`</br>
    - Với tham số là `Time`: Số lần thực hiện `Time shift`</br>
`Time shift`: Khoảng thời gian giữa các lần thực hiện `Funtion`</br>
`Result`: Điều kiện để `trigger` thực hiện cảnh báo.</br>

- ***Chọn `Insert` sau đó chọn `add` để add `trigger`.***
## 2. Tạo Action
- ***Vào `Configure` chọn `Action` chọn `Create Action`***
<img src=https://i.imgur.com/hFBJZYi.png>

***Trong `Action`***
`Name`: Tên `Action`
***Trong `Operations`:
`Default operation step duration`: Khoảng thời gian giữa các `step`
- ***Chọn `Add` hoặc chọn `New` tại `Operatios` để thực hiện "Cảnh báo leo thang" trong `Operation details`***
vd: 
<img src=https://i.imgur.com/uAn0L2k.png>

Step 1: Gửi cảnh báo tới user guest bằng tất cả các media ngay lập tức</br>
Step 2: Sau 60s (Default time) thực hiện step 2 3 4, mỗi step 60s</br>
Step 3: Sau 60s của step 2 thực hiện step 5.</br>
