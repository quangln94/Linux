# Service Monitoring

Trong nhiều trường hợp, khi không cần quan tâm đến các thông số về phần cứng  như RAM, CPU, DISK...sở hạ tầng CNTT hiện có và các thông tin khác ở cấp độ cao hơn. Khi đó Chức năng giám sát dịch vụ trên cơ sở hạ tầng thường được sử dụng

## 1. Cấu hình cơ bản
- Vào `Configuration` -> `Service` -> `Add chill` tại mục `root
<img src=https://i.imgur.com/jAI4CmS.png>

- Cấu hình ví dụ như dưới đây: 
<img src=https://i.imgur.com/WW6l1m5.png>

Trong đó:

- ***Name:*** Đặt tên
- ***Parent service:*** dịch vụ cha
- ***Status calculation algorithm:*** Thuật toán tính toán trạng thái
- ***Calculate SLA, acceptable SLA (in %):*** Phần trăm SLA đánh giá, ví du: trên 99.9% thì OK
- ***Trigger:*** Chọn Trigger đánh giá, ví dụ: Đánh giá Processor load của Zabbix server. Kích vào `Select` để lựa chọn.
- ***Sort order (0->999):***

- Chọn `Time`: Mặc định là dịch vụ sẽ chạy 24x7x265, nếu cần ngoại lệ thì thêm tại đây.
<img src=https://i.imgur.com/pykMt0c.png>

- Chọn `Add`
-Vào mục `Monitoring` -> `Sercive` để view
<img src=https://i.imgur.com/h4Ubz7o.png>

# Tài liệu tham khảo
- https://www.zabbix.com/documentation/4.0/manual/web_interface/frontend_sections/monitoring/it_services
- https://www.zabbix.com/documentation/4.0/manual/it_services
