Cách sử dụng Macro và Parameter
# Monitor nhiều disk sử dụng Macro và Parameter
## Trên Zabbix-agent
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
   Cấp quyền thực thi cho file
   ```
   chmod +x /usr/local/bin/discover_disk.py
   ```
   Vào file cấu hình zabbix-agent thêm vào dòng sau:
   ```sh
  vim /etc/zabbix/zabbix_agent.conf
  UserParameter=custom.disks.discovery_python,/usr/local/bin/discover_disk.py
  ```
  Trong đó: 
  - ***custom.disks.discovery_python:*** là Key item được dùng để cấu hình Item cho host
  - ***/usr/local/bin/discover_disk.py:*** là câu lệnh thực thi file python

Restart zabbix-agent
```sh
systemctl restart zabbix-agent
```  
   # Tài liệu tham khảo
   - https://github.com/MinhKMA/mdt-ghichep-zabbix/blob/master/docs/discovery_disk.md
   - https://blog.cloud365.vn/monitor/monitor-multi-disk-zabbix/
