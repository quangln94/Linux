# Docker image
Docker images được tạo thành từ một loạt các layers. Mỗi layers sẽ đại diện cho một chỉ thị trong Dockerfile

Docker file bên trên bao gồm các commands và mỗi command sẽ tạo ra một layer. Mỗi một layer chỉ là một phần khác biệt so với layer phía trước nó. Mỗi layer sẽ được xếp lên trên layer trước nó. Điều quan trong ở đây là khi tạo một container mới thì một `writeable layer on top of the underlying layers` - một layer có thể ghi được đặt trên cùng so với những layer thuộc images mà container này được tạo ra. 

<img src=https://i.imgur.com/U11x7Iw.png>

Điểm khác biệt lớn giữa một container và image đó chính là `writeable layer` ở trên cùng này. Tất cả những thay đổi thực hiện bên trong container sẽ được lưu lại vào layer có thể ghi này. Khi container bị xóa chúng cũng bị xóa theo và quay trở lại trạng thái unchanged (chính là bản mới sau khi vừa được build ra từ image). Nhiều container có thể truy cập vào cùng một image nếu chúng được tạo ra từ image này và mỗi container sẽ có một layer để lưu trạng thái của riêng nó.

## Tài liệu tham khảo
- https://neo4j.com/blog/neo4j-containers-docker-azure/
