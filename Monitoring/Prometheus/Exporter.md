Có 1 số thư viện hoặc server giúp export các metrics tồn tại từ third-party systems như Prometheus metrics. Nó hữu ích cho các trường hợp không khả thi để thực hiện lấy metric trực tiếp (ví dụ: HAProxy hoặc Linux system stats).


Theo mặc định, Prometheus chỉ thu thập những số liệu về chính nó (ví dụ số yêu cầu nhận, lượng bộ nhớ tiêu thụ,...). Để có thể mở rộng thu thập từ các nguồn khác, sử dụng Exporter và các công cụ khác để tạo các metric.

Exporters - được phát triển bởi Prometheus và cộng đồng - cung cấp mọi thứ thông tin về cơ sở hạ tầng, cơ sở dữ liệu, web server, hệ thống tin nhắn, API, ...

Một vài Exporter tiêu biểu:
- `node_exporter`: tạo ra các số liệu về hạ tầng, bao gồm CPU, memory, disk usage cũng như số liêu I/O, network.
- `blackbox_exporter`: tạo ra các số liệu từ các đầu dò như HTTP, HTTPs để xác định tính khả dụng của các endpoint, thời gian phản hồi,...
- `mysqld_exporter`: tập hợp các số liệu liên quan tới mysql server
- `rabbitmq_exporter`: output của exporter này liên quan tới RabbitMQ, bao gồm số lượng message được publish, số message sẵn sàng để gửi, kích cỡ các gói tin trong hàng đợi.
- `nginx-vts-exporter`: cung cấp các số liệu về nginx server sử dụng module VTS bao gồm số lượng kết nối mở, số lượng phản hồi được gửi và tổng kích thước của các gói tin gửi và nhận

Các exporter xem thêm tại: https://prometheus.io/docs/instrumenting/exporters/

## Tài liệu tham khảo
- https://github.com/hocchudong/ghichep-prometheus-v2/blob/master/docs/Exporter.md
