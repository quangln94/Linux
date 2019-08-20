# Add host sử dụng Discovery và Action trên Zabbix
## 1. Tạo Rule Discovery
- Vào `Configuretion` -> `Discovery` -> `Host` -> `Create discovery rule`
<img src=https://i.imgur.com/98yLVFx.png>

- Tiếp theo điển các thông số trong `Discovery rules`
<img src=https://i.imgur.com/rIw7zQ2.png>
- Ở đây chọn `agent check` là để check host nào đã cài `zabbix-agent` 
Trong đó:
- ***Name:*** Tên Rule
- ***Discovery by proxy:*** Chọn Proxy thực hiện `Rules`. Nếu không cần hoặc không có chọn `No proxy`
- ***IP rang:*** Thực hiện `discovery` nếu ***Host*** nằm trong dải ***IP*** này
- ***Update interval:*** Khoảng thời gian thực hiện ***discovery***
- ***Checks:*** điền thông tin dùng để ***check***
- ***Device uniqueness criteria:***


## 2. Tạo Action add host
