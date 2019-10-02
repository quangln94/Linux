# Docker notary
## Notary là gì
Notary là một công cụ để xuất bản và quản lý các nội dung đáng tin cậy. Các nhà xuất bản có thể ký điện tử các bộ sưu tập và người dùng có thể xác minh tính toàn vẹn và nguồn gốc của nội dung. Tính năng này được xây dựng trên giao diện ký và quản lý khóa đơn giản để tạo các bộ sưu tập đã ký và cấu hình các nhà xuất bản đáng tin cậy.

Với Notary, bất cứ ai cũng có thể cung cấp sự tin tưởng đối với các bộ sưu tập dữ liệu tùy ý. Sử dụng The Update Framework (TUF) làm khung bảo mật cơ bản, Notary đảm nhiệm các hoạt động cần thiết để tạo, quản lý và phân phối metadata cần thiết để đảm bảo tính toàn vẹn và mới mẻ của nội dung của bạn.

## Understand Notary naming

Notary sử dụng Globally Unique Names (GUN) để xác định các bộ sưu tập tin cậy. Để cho phép Notary chạy theo kiểu nhiều người thuê, bạn phải sử dụng định dạng này khi tương tác với Docker Hub thông qua Notary-client. Khi chỉ định tên Docker-image cho Notary-client, định dạng GUN như sau:
- Đối với official images, tên image được hiển thị trên Docker Hub, có tiền tố là `docker.io/library/`. Ví dụ: nếu bạn dùng `docker pull ubuntu`, bạn phải nhập `notary {cmd} docker.io/library/ubuntu`.
- Đối với tất cả các image khác, tên image được hiển thị trên Docker Hub, có tiền tố là `docker.io`.




## Tài liệu tham khảo
- https://docs.docker.com/notary/getting_started/
