# Chức năng cơ bản của các `TAB` trong Zabbix
## 1. Monitoring
Giám sát chung
### 1.1. Dashbroad
Màn hình hiển thị tổng quan giám sát. Tại đây bạn có thể tùy chỉnh: Sửa, xóa, show thông tin mà bạn cần giám sát
### 1.2. Problem
Hiện thị các cảnh báo dựa trên các `trigger` được tạo sẵn hoặc do bạn tạo. Có các tùy chọn lọc để show cảnh báo
### 1.3. Overview
Tương tư: Hiển thị tổng quan về cảnh báo, data,....
### 1.4. Web
### 1.5. Lastest data
Hiện thị thông tin về các thông số thu thập được của từng item của từng host. Có tùy chọn lọc để lọc data
### 1.6 Graph
Tạo biểu đồ hiền thị các thông số thu thập được dựa trên từ các item trên mỗi host
### 1.7 Screen
Tạo Screen hiển thị tổng quan về các mục giám sát. Có thể chỉnh sửa biểu đồ phù hợp nhu cầu
### 1.8 Map
Thể hiện các device được giám sat dựa trên hình ảnh mình họa cụ thể. 
### 1.9. Discovery
Các device được tìm thấy dựa trên các rule
### 1.10 Service
Trong nhiều trường hợp, khi không cần quan tâm đến các thông số về phần cứng như RAM, CPU, DISK...sở hạ tầng CNTT hiện có và các thông tin khác ở cấp độ cao hơn. Khi đó Chức năng giám sát dịch vụ trên cơ sở hạ tầng thường được sử dụng.

Tham khảo cài đặt cơ bản [tại đây]()

## 2. Inventory
Dùng cho việc quản lý tài sản gồm các thông số như: Serial, CPU, RAM, OS, Application, Date Invoice,....
## 3.
## 4. Configuration
### 4.1 Host group
Tạo `Host group`. Mỗi `Host` được thêm vào sẽ thuộc 1 hoặc nhiều group khác nhau
### 4.2 Templates
Cung cấp các Templates sẵn có hoặc tự tạo tùy nhu cầu. Ví dụ: tạo 1 Templates chứa các item giám sát các thông số như RAM, CPU, DISK...Tất cả các host có như cầu giám sát các thông số này đều có thể sử dụng Template này. Rút ngắn thời gian cấu hình thủ công cho từng host. Có thể add thêm các thuộc tính như: Applications,	Items,	Triggers,	Graphs,	Screens,	Discovery,	Web,	Linked templates,	Linked to.
### 4.3 Host
Dùng để add host hoặc chỉnh sửa host....
### 4.4 Maintenance
### 4.5 Actions
Tạo các action khi thỏa mãn 1 điều kiện nào đó như: gửi cảnh báo, add host dựa vào rule...
### 4.6 Event correlation
### 4.7 Discovery
Cấu hình khám phá device theo rule
### 4.8 Service
## 5. Administration
