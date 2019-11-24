# Cài đặt Zabbix-agent trên Window 10

Bản chất việc cài cũng tương tự trên Linux gổm 2 bước:
- Cài gói zabbix-agent
- Trỏ IP về zabbix-server

## Các bước thực hiện

- Download Zabbix-agent [tại đây](https://www.zabbix.com/download_agents#tab:40LTS). Lưu ý chọn bản phù hợp với OS của mình.
- Sau khi tải xong, thực hiện giải nén và copy vào ổ C: 
- Vào File cấu hình `zabbix_agentd.conf` sửa dòng `Server=127.0.0.1` thành IP của zabbix server và các dòng khác tương tự trên CentOS7sau đó lưu lại
<img src=https://i.imgur.com/iXZQZen.png>

- Mở `Command Promt` dưới quyền Administrator để chạy setup file `zabbix-agent.exe`
<img src=https://i.imgur.com/wdxiYxI.png>

Thực hiện các lệnh sau:
```sh
cd..
cd..
cd /zabbix_agents-4.0.11-win-amd64-openssl/bin
zabbix_agentd.exe -c c:\zabbix_agents-4.0.11-win-amd64-openssl\conf\zabbix_agentd.conf --install
```
<img src=https://i.imgur.com/Jw71aZE.png>

Trong đó:
- Thực hiện `cd` 2 lần để quay về thư mục gốc `C:\`
- `cd /zabbix_agents-4.0.11-win-amd64-openssl/bin`: Truy cập vào thư mục `bin` chứa file `zabbix_agentd.exe` để chạy
- `zabbix_agentd.exe -c c:\zabbix_agents-4.0.11-win-amd64-openssl\conf\zabbix_agentd.conf --install`: Lệnh thực hiện Setup
- Vậy là đã thực hiện tài thành công zabbix-agent trên WinOS

- Sau đó vào Zabbix server thực hiện add host
