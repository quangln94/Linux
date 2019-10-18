# Deploying apps with Docker Stacks

Deploying và managing multi-service apps at scale là việc khó khăn.

Docker Stacks đơn giản hóa việc quản lý ứng dụng bằng cách desired state, rolling updates, simple, scaling operations, health checks...Tất cả được bọc trong một mô hình khai báo tốt đẹp.

Điều này rất đơn giản. Xác định app của bạn trong Compose file, sau đó deploy và manage nó với command `docker stack deploy`

Compose file bao gồm toàn bộ chồng dịch vụ tạo nên ứng dụng. Nó cũng bao gồm tất cả volumes, networks, secrets và cơ sở hạ tầng khác mà ứng dụng cần

Bạn sử dụng command `docker stack deploy` để deploy app từ file

Để thực hiện tất cả điều này, stacks build on top của Docker Swarm, nghĩa là bạn có được tất cả các tính năng bảo mật và nâng cao đi kèm với Swarm.

## Deploying apps with Docker Stacks

Nếu bạn biết Docker Compose, bạn sẽ thấy Docker Stacks thực sự dễ dàng. Trên thực tế, theo nhiều cách, stacks là thứ mà chúng ta luôn mong muốn Compose - được tích hợp hoàn toàn vào Docker và có thể quản lý toàn bộ vòng đời của các ứng dụng.

Về mặt kiến trúc, stacks nằm ở đầu phân cấp ứng dụng Docker. Stacks build on top of services, service turn build on top of containers

<img src=https://i.imgur.com/25sn89a.png>




## Tài liệu tham khảo
- Docker Deep Dive Zero to Docker in a single book! - Nigel Poulton
