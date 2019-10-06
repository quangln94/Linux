# Run a service for testing or development

Cách nhanh nhất để tạo ra một dịch vụ Notary đầy đủ cho mục đích thử nghiệm và phát triển là sử dụng Docker compose file trong Notary project.
```sh
$ git clone https://github.com/docker/notary.git
$ cd notary
$ docker-compose up
```

Điều này xây dựng Notary-server và Notary signer images và start up containers Notary server, Notary signer, và the MySQL database mà cả hai cùng chia sẻ. Dữ liệu MySQL được lưu trữ trong 1 volume.

Notary-server và Notary signer giao tiếp thông qua xác thực TLS (sử dụng self-signed testing certs trong repository) và Notary-server lắng nghe lưu lượng HTTPS trên cổng 4443.

Theo mặc định, phát triển Notary server container này chạy với testing self-signed TLS certificates. Trước khi bạn có thể kết nối thành công với nó, bạn phải sử dụng root CA file `fixtures/root-ca.crt`.

Ví dụ: để kết nối sử dụng OpenSSL:
```sh
$ openssl s_client -connect <docker host>:4443 -CAfile fixtures/root-ca.crt -no_ssl3 -no_ssl2
```
Để kết nối sử dụng Notary Client CLI, xem[Getting Started](https://docs.docker.com/notary/getting_started/). Phiên bản của Notary-server và signer cần phải lớn hơn hoặc bằng phiên bản của Notary Client CLI để đảm bảo tính tương thích của tính năng. Chẳng hạn, nếu bạn sử dụng Notary Client CLI 0.2, thì phiên bản của server và signer phải là 0.2 hoặc cao hơn.

Subject name và subject alternative name self-signed certificate là `notary-server`, `notaryserver` và `localhost`, vì vậy nếu Docker-host của bạn không có trên localhost (ví dụ: nếu bạn đang sử dụng Docker Machine), hãy cập nhật file hosts của bạn sao cho tên `notary-server` được liên kết với địa chỉ IP của Docker-host của bạn.



## Tài liệu tham khảo 
- https://docs.docker.com/notary/running_a_service/
