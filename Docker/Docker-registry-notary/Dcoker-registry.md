# Docker Registry

Registry là một ứng dụng trên server, có khả năng mở rộng cao, lưu trữ và cho phép bạn phân phối Docker images. Registry is  open-source.

Registry là 1 hệ thống lưu trữ và phân phối nội dung, chứa named Docker images, có sẵn trong các tagged versions khác nhau.

Ví dụ: the image `distribution/registry`, với tags `2.0` và `2.1`.

Người dùng tương tác với `registry` bằng cách sử dụng các lệnh `docker push`  và `docker pull`.

Ví dụ:
```sh
docker pull registry-1.docker.io/distribution/registry:2.1
```
Lưu trữ được ủy quyền cho drivers. Default storage driver là local posix filesystem, phù hợp cho việc phát triển hoặc triển khai nhỏ. Cloud-based storage drivers như S3, Microsoft Azure, OpenStack Swift và Aliyun OSS cũng được hỗ trợ. Những người đang tìm cách sử dụng các storage backends khác có thể làm bằng cách viết triển khai driver Storage API riêng của họ.

Đảm bảo quyền truy cập vào image được lưu trữ của bạn là việc quan trọng, Registry thực sự hỗ trợ TLS và xác thực cơ bản.

Registry GitHub repository bao gồm thông tin bổ sung về các phương thức xác thực và ủy quyền nâng cao. Chỉ có các triển khai rất lớn hoặc công khai được dự kiến sẽ mở rộng Registry theo cách này.

Cuối cùng, Registry cung cấp một hệ thống thông báo mạnh mẽ, gọi webhooks để phản hồi hoạt động và cả ghi nhật ký và báo cáo mở rộng, chủ yếu hữu ích cho các cài đặt lớn muốn thu thập số liệu.

Image-name được sử dụng trong các lệnh docker điển hình phản ánh nguồn gốc của chúng:
- `docker pull ubuntu` hướng dẫn docker pull 1 image có tên ubuntu từ official Docker Hub. Đây chỉ đơn giản là viết tắt cho lệnh `docker pull docker.io/library/ubuntu`
- `docker pull myregistrydomain:port/foo/bar` hướng dẫn docker liên hệ với registry located at `myregistrydomain:port` để tìm image `foo/bar`


Bạn nên sử dụng Registry nếu bạn muốn:
- Kiểm soát chặt chẽ nơi image của bạn đang được lưu trữ
- hoàn toàn sở hữu đường ống phân phối image của bạn
- tích hợp lưu trữ và phân phối image chặt chẽ vào quy trình phát triển nội bộ của bạn

Người dùng đang tìm kiếm một giải pháp bảo trì sẵn sàng, ready-to-go được khuyến khích truy cập vào Docker Hub, nơi cung cấp một Registry miễn phí, được lưu trữ, cùng với các tính năng bổ sung (tài khoản tổ chức, xây dựng tự động và hơn thế nữa).

Người dùng đang tìm kiếm một phiên bản Registry được hỗ trợ thương mại nên xem xét Docker Trusted Registry.

Registry tương thích với Docker engine version 1.6.0 hoặc higher.

## Basic commands

Start your registry
```sh
docker run -d -p 5000:5000 --name registry registry:2
```
Pull (or build) some image from the hub
```sh
docker pull ubuntu
```
Tag the image so that it points to your registry
```sh
docker image tag ubuntu localhost:5000/myfirstimage
```
Push it
```sh
docker push localhost:5000/myfirstimage
```
Pull it back
```sh
docker pull localhost:5000/myfirstimage
```
Now stop your registry and remove all data
```sh
docker container stop registry && docker container rm -v registry
```

## 3. Deploy a registry server

Trước khi bạn có thể triển khai registry, bạn cần cài đặt Docker trên host. 1 registry là một phiên bản của `registry` image và chạy trong Docker.

### 3.1 Run a local registry
Use 1 command như dưới đây để start registry container:
```sh
$ docker run -d -p 5000:5000 --restart=always --name registry registry:2
```
Bạn có thể pull 1 image từ Docker Hub và push nó lên registry của bạn. Ví dụ dưới đây pulls image `ubuntu:16.04` từ Docker Hub và re-tags nó thành `my-ubuntu` sau đó pushes nó lên local registry. Cuối cùng image `ubuntu:16.04` và image `my-ubuntu` đều deleted trên locally và image `my-ubuntu` được pulled từ local registry.

1. Pull the ubuntu:16.04 image from Docker Hub.
```
$ docker pull ubuntu:16.04
```
2. Tag the image as localhost:5000/my-ubuntu. This creates an additional tag for the existing image. When the first part of the tag is a hostname and port, Docker interprets this as the location of a registry, when pushing.
```sh
$ docker tag ubuntu:16.04 localhost:5000/my-ubuntu
```
3. Push the image to the local registry running at localhost:5000:
```sh
$ docker push localhost:5000/my-ubuntu
```
4. Remove the locally-cached ubuntu:16.04 and localhost:5000/my-ubuntu images, so that you can test pulling the image from your registry. This does not remove the localhost:5000/my-ubuntu image from your registry.
```sh
$ docker image remove ubuntu:16.04
$ docker image remove localhost:5000/my-ubuntu
```
5. Pull the localhost:5000/my-ubuntu image from your local registry.
```sh
$ docker pull localhost:5000/my-ubuntu
```
### 3.3. Stop a local registry
To stop the registry, use the same docker container stop command as with any other container.
```sh
$ docker container stop registry
```
To remove the container, use docker container rm.
```sh
$ docker container stop registry && docker container rm -v registry
```

### 3.4 Start the registry automatically
If you want to use the registry as part of your permanent infrastructure, you should set it to restart automatically when Docker restarts or if it exits. This example uses the --restart always flag to set a restart policy for the registry.
```sh
$ docker run -d \
  -p 5000:5000 \
  --restart=always \
  --name registry \
  registry:2
```
### 4. Storage customization



## Tài liệu tham khảo 
- https://docs.docker.com/registry/
- https://docs.docker.com/registry/introduction/
- https://docs.docker.com/registry/deploying/
