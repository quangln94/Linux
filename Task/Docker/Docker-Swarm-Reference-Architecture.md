# Docker Swarm Reference Architecture: Exploring Scalable, Portable Docker Container Networks

## What You Will Learn

Docker container bao bọc một phần mềm trong một filesystem hoàn chỉnh chứa mọi thứ cần thiết để chạy: code, runtime, system tools, system libraries - bất cứ thứ gì có thể được cài đặt trên server. Điều này đảm bảo rằng phần mềm sẽ luôn chạy như nhau, bất kể môi trường của nó. Theo mặc định, containers cô lập các ứng dụng với nhau và cơ sở hạ tầng bên dưới, đồng thời cung cấp lớp bảo vệ bổ sung cho ứng dụng.

Điều gì xảy ra nếu các ứng dụng cần liên lạc với nhau, với host hay mạng bên ngoài? Làm thế nào để thiết kế một mạng để cho phép kết nối phù hợp trong khi duy trì tính di động của ứng dụng- application portability, service discovery, load balancing, security, performance, and scalability ? Tài liệu này là tổng quan về các khái niệm kiến trúc và thiết kế để xây dựng và mở rộng Docker container networks cho cả Linux và Microsoft servers.

## Challenges of Networking Containers and Microservices

Các thực tiễn của microservice đã cải thiện khả năng scale của các ứng dụng, điều này thậm chí còn quan trọng hơn đối với các phương thức kết nối và cách ly được cung cấp cho các ứng dụng. Triết lý Docker networking là hướng ứng dụng. Nó nhằm mục đích cung cấp các tùy chọn và tính linh hoạt cho các nhà khai thác mạng cũng như mức độ trừu tượng phù hợp cho các nhà phát triển ứng dụng.

Giống như bất kỳ thiết kế nào, network design là một hành động cân bằng. Docker Enterpirse và Docker ecosystem cung cấp nhiều công cụ cho network engineers để đạt được sự cân bằng tốt nhất cho các ứng dụng và môi trường của họ. Mỗi lựa chọn cung cấp lợi ích và sự đánh đổi khác nhau. Phần còn lại của hướng dẫn này nêu chi tiết từng lựa chọn này để các network engineers có thể hiểu điều gì có thể là tốt nhất cho môi trường của họ.

Docker đã phát triển một cách mới để cung cấp các ứng dụng và cùng với đó, các container cũng đã thay đổi một số khía cạnh về cách tiếp cận mạng. Các chủ đề sau đây là các chủ đề thiết kế phổ biến cho các ứng dụng được đóng gói:

- Portability (Tính di động): Làm cách nào để đảm bảo tính di động tối đa trên các môi trường mạng khác nhau trong khi tận dụng các đặc điểm mạng duy nhất?
- Service Discovery: Làm thế nào để biết nơi các dịch vụ đang sống khi chúng được scaled up and down ?
- Load Balancing: Làm cách nào để cân bằng tải trên các dịch vụ khi bản thân các dịch vụ được brought up and scaled?
- Security: Làm cách nào để phân đoạn để ngăn các container truy cập lẫn nhau?
Làm cách nào để đảm bảo rằng một container có lưu lượng kiểm soát ứng dụng và cụm là an toàn?
- Performance: Làm cách nào để cung cấp dvanced network services trong khi giảm thiểu độ trễ và tối đa hóa băng thông?
- Scalability: Làm cách nào để đảm bảo rằng không có đặc điểm nào trong số những đặc điểm này bị mất khi nhân rộng các ứng dụng trên nhiều máy chủ?

## The Container Networking Model

Kiến trúc Docker networking được xây dựng trên một tập hợp các giao diện được gọi là Container Networking Model (CNM). Triết lý của CNM là cung cấp tính di động ứng dụng trên các cơ sở hạ tầng đa dạng. Mô hình này tạo ra sự cân bằng để đạt được tính di động của ứng dụng và cũng tận dụng các tính năng và khả năng đặc biệt của cơ sở hạ tầng.

<img src=https://i.imgur.com/xdvNwlf.png>


## The Container Networking Model


## Tài liệu tham khảo
- https://success.docker.com/article/networking
