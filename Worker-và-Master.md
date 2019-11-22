
WSO2 Carbon version 4.0.0 hô trợ mô hình triển khải gồm node worker và manager. Node worker phục vụ các requests nhận được từ clients, trong khi Node manager triển khai và cấu hình (web applications, services, proxy services...). 

Việc phân chia worker và manager để phân tách các thành phần UI của WSO2 product, management console, và chức năng liên quan với internal framework. Thông thường Node manager ở chế độ read-write và ủy quyền để thay đổi cấu hình. Node worker ở chế độ read-only và ủy quyền chỉ deploy artifacts và đọc cấu hình.

## Tài liệu tham khảo
- https://docs.wso2.com/display/ADMIN44x/Clustering+Overview
