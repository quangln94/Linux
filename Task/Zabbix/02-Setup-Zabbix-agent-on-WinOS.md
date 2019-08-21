# Cài đặt Zabbix-agent trên Window 10
- Download Zabbix-agent [tại đây](https://www.zabbix.com/download_agents#tab:40LTS). Lưu ý chọn bản phù hợp với OS của mình.
- Sau khi tải xong, thực hiện giải nén và copy vào ổ C:
- Vào File cấu hình `` sửa dòng Server=127.0.0.1 thành IP của zabbix server sau đó lưu lại
```sh
Server=10.10.10.220
```
- Mở `Command Promt` dưới quyền Administrator để chạy setup file `zabbix-agent.exe`
Thực hiện các lệnh sau:
```sh
cd..
cd..
cd /zabbix/bin
zabbix.exe -c c:
```
- Sau đó vào Zabbix server thực hiện add host
