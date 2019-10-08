# Content trust in Docker
Khi truyền dữ liệu giữa các hệ thống nối mạng, trust là mối quan tâm chính. Đặc biệt, khi liên lạc qua một phương tiện không tin cậy như internet, điều quan trọng là phải đảm bảo tính toàn vẹn và publisher của tất cả dữ liệu mà hệ thống vận hành. Bạn sử dụng Docker Engine để push và pull image (dữ liệu) đến 1 public hoặc private registry. Content trust cung cấp cho bạn khả năng xác minh cả tính toàn vẹn và publisher của tất cả dữ liệu nhận được registry over any channel.

## 1. Giới thiệu về Docker Content Trust (DCT)
Docker Content Trust (DCT) cung cấp khả năng sử dụng chữ ký số cho dữ liệu được gửi và nhận từ Docker registries. Các chữ ký này cho phép xác minh phía client hoặc thời gian chạy của tính toàn vẹn và publisher của các image tags cụ thể.

Thông qua DCT, image publishers có thể ký image và người dùng có thể đảm bảo rằng image họ sử dụng đã được ký. Publishers có thể là các cá nhân hoặc tổ chức ký thủ công nội dung của họ hoặc chuỗi cung ứng phần mềm tự động ký nội dung như một phần của quy trình phát hành.

## 2. Image tags and DCT
Một bản ghi image cá nhân có định dạng sau:
```sh
[REGISTRY_HOST[:REGISTRY_PORT]/]REPOSITORY[:TAG]
```


## Tài liệu tham khảo
- https://docs.docker.com/engine/security/trust/content_trust/
