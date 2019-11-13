# Add host sử dụng Discovery và Action trên Zabbix
## 1. Tạo Rule Discovery
- Vào `Configuration` -> `Discovery` -> `Host` -> `Create discovery rule`
<img src=https://i.imgur.com/98yLVFx.png>

- Tiếp theo điển các thông số trong `Discovery rules`
<img src=https://i.imgur.com/rIw7zQ2.png>

- Ở đây chọn `agent check` sử dụng `key` là `system.uname` là check host nào đã cài `zabbix-agent` 
- Chọn `Add` tại mục `check` -> ***Add***

Trong đó:

- ***Name:*** Tên Rule
- ***Discovery by proxy:*** Chọn Proxy thực hiện `Rules`. Nếu không cần hoặc không có chọn `No proxy`
- ***IP rang:*** Thực hiện `discovery` nếu ***Host*** nằm trong dải ***IP*** này
- ***Update interval:*** Khoảng thời gian thực hiện ***discovery***
- ***Checks:*** điền thông tin dùng để ***check***
- ***Device uniqueness criteria:***

## 2. Tạo Action add host
- Vào `Configuration` -> `Action` -> Event source chọn ` Discovery` -> `Create action`
<img src=https://i.imgur.com/Ar1P0ku.png>

Trong đó:

- ***Name:*** Tên Action
- ***Type of calculation:*** Cách thực hiện điều kiện trong `Conditions`. Tham khảo thêm [tại đây](https://www.zabbix.com/documentation/4.2/manual/config/notifications/action/conditions)
<img src=https://i.imgur.com/fABBFwB.png>

- ***Conditions:*** Điều kiện
- Chọn `Add`
- Tại mục `Operations`
<img src=https://i.imgur.com/C2DJ11H.png>

Điền như sau: 
- ***Default subject:*** 
```sh
Discovery: {DISCOVERY.DEVICE.STATUS} {DISCOVERY.DEVICE.IPADDRESS}
```
- ***Default message:*** 
```sh
Discovery rule: {DISCOVERY.RULE.NAME}

Device IP: {DISCOVERY.DEVICE.IPADDRESS}
Device DNS: {DISCOVERY.DEVICE.DNS}
Device status: {DISCOVERY.DEVICE.STATUS}
Device uptime: {DISCOVERY.DEVICE.UPTIME}

Device service port: {DISCOVERY.SERVICE.PORT}
Device service status: {DISCOVERY.SERVICE.STATUS}
Device service uptime: {DISCOVERY.SERVICE.UPTIME}

Device service name: {DISCOVERY.SERVICE.NAME}
```
-Tại `Operations` Thực hiện add host vào `Group` và `Template` hoặc túy chỉnh theo ý của mình

- Chọn ***Add*** và xem kết quả: 

Tìm thấy được 3 `host` thỏa mãn điều kiện

<img src=https://i.imgur.com/PqplwQV.png>

***host*** 10.10.10.222 được đặt tên, add vào group và template như `Rules` đã tạo

<img src=https://i.imgur.com/2Xz891d.png>
