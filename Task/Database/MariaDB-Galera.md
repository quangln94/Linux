# Giới thiệu về MariaDB Galery Cluster
MariaDB Galera Cluster hỗ trợ đồng bộ dữ liệu MariaDB trên nhiều máy chủ trong cùng một cụm. Giữ cho các máy chủ lưu trữ dữ liệu MariaDB trên tất cả các máy chủ đồng bộ với nhau, trong đó tất cả các máy chủ đều là master, nên có thể đọc ghi như nhau trên tất cả các máy chủ trong mạng lưới. Và quan trọng hơn nó là một phần mềm miễn phí.

Hạn chế của MariaDB Galera Cluster là chỉ có thể sử dụng với kiểu lưu trữ InnoDB.
## Cấu hình MariaDB Galery Cluster
MariaDB Galery Cluster đã được tích hợp sẵn trong các phiên bản của MariaDB Server (mình cài đặt với phiên bản 10.3.13 các bản trước các bạn tham khảo thêm trên website của MariaDB). Sau khi cài đặt chúng ta cần cấu hình để đồng bộ các server với nhau. Để cài đặt MariaDB các bạn có thể tham khảo bài viết Cài đặt MariaDB 10.x trên CentOS 7
