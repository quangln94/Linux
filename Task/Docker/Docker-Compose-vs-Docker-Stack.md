# Docker Compose và Docker Stack

Swarm mode được tích hợp vào Docker Engine trong 1.12 và mang theo một số tool. Một trong số đó là có thể sử dụng of docker-compose.yml files để hiển thị stacks của Docker containers mà không cần phải cài đặt Docker Compose.

Lệnh được gọi là `docker stack`, và nó trông giống hệt với `docker-compose`. Đây là một so sánh:
```sh
## Docker-compose
$ docker-compose -f docker-compose up
## Docker-stack
$ docker stack deploy -c docker-compose.yml somestackname
```
Cả 2 sẽ cung cấp tất cả services, volumes, networks và mọi thứ khác, giống như được chỉ định trong `docker-compose.yml` files. 

## 2. Sự khác nhau

Docker stack đang bỏ qua các hướng dẫn `build`. Bạn không thể build image mới bằng cách sử dụng các lệnh `stack`. Nó cần pre-built images để tồn tại. Vì vậy `docker-compose` phù hợp hơn cho các kịch bản phát triển.

Ngoài ra còn có các phần của đặc tả compose-file bị bỏ qua bởi `docker-compose` hoặc các lệnh stack.

Docker Compose là một Python project. Ban đầu, có một Python project được gọi là fig được sử dụng để phân tích các tệp fig.yml để bring up - you guessed it - stacks of Docker containers. Mọi người đều yêu thích nó, đặc biệt là Docker folks, vì vậy nó đã được tái sinh thành docker compose để gần gũi hơn với product. Nhưng nó vẫn ở trong Python, hoạt động trên top of the Docker Engine.

Bên trong nó sử dụng Docker API để hiển thị các containers theo một đặc điểm kỹ thuật. Bạn vẫn phải cài đặt `docker-compose` riêng để sử dụng nó với Docker trên máy của bạn.

Chức năng Docker Stack được bao gồm Docker engine. Bạn không cần cài đặt các gói bổ sung để sử dụng nó Triển khai docker stack là một phần của swarm mode. Nó hỗ trợ các loại compose files tương tự, nhưng việc xử lý xảy ra trong Go code, bên trong Docker Engine. Bạn cũng phải tạo một máy `Swarm` trước khi có thể sử dụng lệnh stack, nhưng điều đó không phải là vấn đề lớn.

Docker stack không hỗ trợ docker-compose.yml files được viết theo đặc tả version 2. Nó phải là phiên bản gần đây nhất, là 3 tại thời điểm viết, trong khi Docker Compose vẫn có thể xử lý các version 2 và 3 mà không gặp vấn đề gì.

## Tài liệu tham khảo
- https://vsupalov.com/difference-docker-compose-and-docker-stack/
