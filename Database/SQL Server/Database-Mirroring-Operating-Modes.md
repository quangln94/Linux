# Database Mirroring Operating Modes

## 1. High-performance mode

Trong chế độ này ngay khi Principal server gửi 1 log transaction đến Mirror server, Principal server gửi 1 xác nhận đến client mà không chờ đợi phản hổi từ Mirror server. Transactions sẽ được commit mà không chờ Mirror server ghi log xuống disk. Hoạt động bất đồng bộ cho phép Principal server hoạt động với đỗ trễ thấp (minimum transaction latency). Tuy nhiên có thể gây mất dữ liệu khi databases chưa kịp đồng bộ

Chế độ này có thể hữu ích trong kịch bản Disaster-Recovery, trong đó Principal và Mirror servers có khoảng cách đáng kể và không muốn hoạt động của Mirror server ảnh hướng đến Principal server.

## 2. High-safety mode

Database mirror hoạt động đồng bộ và có tùy chọn sử dụng witness cho cả Principal server và Mirror server.

Mirror server phải đồng bộ với Principal database. Khi 1 phiên bắt đầu, Principal server gửi active log của nó đế Mirror server. Mirror server ghi tất cả incoming log records vào disk nhanh nhất có thể. Ngay khi received log records được ghi vào disk, databases được đồng bộ, Principal server nhận được thông báo từ Mirror server rằng việc ghi xuống disk đã hoàn thành. Việc chờ thông báo từ Mirror server đến Principal server có thể gây ra trễ.

## Tài liệu tham khảo
- https://docs.microsoft.com/en-us/sql/database-engine/database-mirroring/database-mirroring-operating-modes?view=sql-server-ver15
