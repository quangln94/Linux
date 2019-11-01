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
Một image `REPOSITORY` cụ thể có thể có nhiều tags. Ví dụ: `lates`  và `3.1.2` là cả 2 tags trên image `mongo`. 1 image publisher có thể build 1 image và thay đổi tag nhiều lần với mỗi lẫn build.

DCT được liên kết với phần `TAG` của image. Mỗi image repository có 1 bộ keys mà image publishers sử dụng để ký 1 image tag. Image publishers có toàn quyền quyết định những tag họ ký.

1 image repository có thể chứa 1 image với 1 tag được ký và các tag khác thì không. Ví dụ, hãy xem xét [the Mongo image repositor](). Tag `lastest` có thể không được ký trong khi tag `3.1.6` có thể được ký. Image publisher có trách nhiệm quyết định xem nếu 1 image tag có được ký hay không. Trong đại diện này, một số image tag được ký, một số khác thì không:

<img src=https://i.imgur.com/pIqWRGb.png>

Publishers có thể chọn để ký 1 tag hoặc không. Do đó nội dung của 1 unsigned tag và của 1 signed tag với cùng tên có thế không khớp. Ví dụ: 1 publisher có thể push 1 tagged image `someimage:latest` và ký nó. Sau đó publisher đó có thể push 1 unsigned `someimage:latest` image. push thứ 2 sẽ thay thế last unsigned tag `latest` nhưng không ảnh hướng đến signed latest version.

Người dùng image có thể kích hoạt DCT để đảm bảo rằng image họ sử dụng đã được ký. Nếu người dùng kích hoạt DCT, họ chỉ có thể pull, run hoặc build với image tin  cậyy. Việc kích hoạt DCT cũng giống như áp dụng filter vào registry của bạn. Người dùng chỉ có thể xem các signed image tags, unsigned image tags invisible với họ.

<img src=https://i.imgur.com/JQVgjqE.png>

Đối với người chưa kích hoạt DCT, không có gì về cách họ làm việc với Docker image thay đổi. Mọi image đều có thể nhìn thấy bất kể nó có được ký hay không.

## 3. Docker Content Trust Keys

Trust 1 image tag được quản lý thông qua việc sử dụng signing keys. 1 bộ key được tạo khi 1 hoạt động sử dụng lần đầu tiên. 1 bộ key bao gồm các lớp sau:
- 1 offline key là root của DCT cho 1 image tag
- repository hoặc tagging keys ký tags
- server quản lý keys như timestamp key đảm bảo, cung cấp mới cho repository của bạn

Hình ảnh sau đây mô tả các signing keys và các mối quan hệ của chúng:


Bạn nên back up root key ở một nơi an toàn.

## 4. Signing Images with Docker Content Trust

Với Docker CLI ta có thể ký và push 1 container image với command `$ docker trust`. This is built on top of the Notary feature set, more information on Notary can be found here.

Một điều kiện tiên quyết để ký 1 image là 1 Docker Registry với 1 Notary-server được đính kèm (Chẳng hạn như Docker Hub hoặc Docker Trusted Registry).

Để ký 1 Docker Image, bạn sẽ cần 1 cặp khóa ủy quyền. Các khóa này có thể được tạo cục bộ bằng cách sử dụng ` $$ docker trust key generate`, được tạo bởi certificate authority hoặc nếu bạn đang sử dụng Docker Enterprise’s Universal Control Plane (UCP).

Đầu tiên, chúng ta sẽ thêm private key ủy quyền vào Docker trust repository local. (Mặc định, được lưu trữ trong `~/.docker/trust/`). Nếu bạn tạo khóa ủy quyền với `$ docker trust key generate`, private key sẽ tự động được thêm vào local trust store. Nếu bạn đang  import 1 key riêng, chẳng hạn như từ 1 UCP Client Bundle, bạn sẽ cần sử dụng lệnh `$ docker trust key load`.

```sh
[root@server03 ~]# docker trust key generate quangln
Generating key for quangln...
Enter passphrase for new quangln key with ID bec9962:
Passphrase is too short. Please use a password manager to generate and store a good random passphrase.
Enter passphrase for new quangln key with ID bec9962:
Repeat passphrase for new quangln key with ID bec9962:
Successfully generated and loaded private key. Corresponding public key available: /root/quangln.pub
```
Hoặc nếu bạn đã có key:
```sh
docker trust key load key.pem --name quangln
```
Tiếp theo chúng ta sẽ cần thêm public key cho Notary-server; đây là đặc trưng cho image repository trong Notary được gọi là Global Unique Name (GUN). Nếu đây là lần đầu tiên bạn thêm một ủy quyền vào repository, lệnh này cũng sẽ khởi tạo repository.








## Tài liệu tham khảo
- https://docs.docker.com/engine/security/trust/content_trust/
