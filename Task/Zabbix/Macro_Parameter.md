Tim hiều về cách sử dụng Macro và Parameter trong Zabbix
# Monitor nhiều disk sử dụng Macro và Parameter
Để tìm hiểu về `macro` và `parameter` trong zabbix ta làm 1 ví dụ về việc monitor nhiều disk trên 1 host
Để có thể monitor nhiều disk trên host, ta khai báo 1 biến $DISK để liệt kệ số lượng disk trên host và giám sát nó.
Mục tiêu của nó sẽ đươc thực hiện như sau:
## 1. Trên Zabbix-agent
Sử dụng một script python để list ra tên disk. 
```sh
vi /usr/local/bin/discover_disk.py
```
Thêm vào các dòng sau: 
```sh
#!/usr/bin/python
import os
import json

if __name__ == "__main__":
    # Iterate over all block devices, but ignore them if they are in the
    # skippable set
    skippable = ("sr", "loop", "ram")
    devices = (device for device in os.listdir("/sys/class/block")
               if not any(ignore in device for ignore in skippable))
    data = [{"{#DISK}": device} for device in devices]
    print(json.dumps({"data": data}, indent=4))
   ```
- Cấp quyền thực thi cho file
```sh
chmod +x /usr/local/bin/discover_disk.py
```
- Vào file cấu hình zabbix-agent thêm vào dòng sau:
```sh
vim /etc/zabbix/zabbix_agent.conf
UserParameter=custom.disks.discovery_python,/usr/local/bin/discover_disk.py
```
Trong đó: 
  - ***custom.disks.discovery_python:*** là Key item được dùng để cấu hình Item cho host
  - ***/usr/local/bin/discover_disk.py:*** là câu lệnh thực thi file python

- Sau đó lưu lại và Restart zabbix-agent
```sh
systemctl restart zabbix-agent
```  
## Trên Dashbroad Zabbix
- Vào `Administration` -> `General` -> `Macro` -> Add `macro` Tạo 1 biến $DISK
|Macro|Value|
|-----|-----
|{$DISK}|all|
- Chọn`Add` -> `Update`
- Tạo `discovery rule` trên host để liệt kê các disk tìm được 
- Vào `Configuration` -> chọn `Host` -> Discovery - `Create discovery rule`

<img src=>

Trong đó: 
- ***Name:*** là tên của discovery rule
- ***Key:*** Đặt theo parameter mà ta khai báo trong file config của zabbix agent

- Sau đó chuyển sang tab `Filters` để lọc ra những disk mà ta muốn giám sát

- ***^vd(a-z)$***: Lọc ra tất cả các disk từ vda->vdz: vda, vdb, vdc,...vdz.
- Sau đó click `Add`. Ta sẽ thấy discovery rule đã được tạo để list disk trên host
- Để giám sát một thông số nào đó trên những disk được tìm thấy ta phải tạo các item cho nó. Để tạo item trên discovery rule ta click vào Item prototypes
- Click vào Create item prototype
- Thực hiện tạo item như bình thường. Ở những vị trí thay vì phải khai báo tên disk bạn thay vào đó là tham số macros đã khai báo từ trước để nó nhận giá trị mà discovery rule tìm thấy
- Như trong ví dụ tôi tạo item giám sát tốc độ đọc trên disk.
- Sau khi tạo xong bạn sẽ thấy item đã được tạo
- Bây giờ bạn có thể thấy metric đẩy về. Lúc này trên máy của tôi có 2 disk.

   # Tài liệu tham khảo
   - https://github.com/MinhKMA/mdt-ghichep-zabbix/blob/master/docs/discovery_disk.md
   - https://blog.cloud365.vn/monitor/monitor-multi-disk-zabbix/
