# Deploying apps with Docker Stacks

Deploying và managing multi-service apps at scale là việc khó khăn.

Docker Stacks đơn giản hóa việc quản lý ứng dụng bằng cách desired state, rolling updates, simple, scaling operations, health checks...Tất cả được bọc trong một mô hình khai báo tốt đẹp.

Điều này rất đơn giản. Xác định app của bạn trong Compose file, sau đó deploy và manage nó với command `docker stack deploy`
