# Working with Docker Content Trust
## 1. Tổng quan
Notary là nền tảng của Docker để cung cấp phân phối nội dung đáng tin cậy bằng cách signing images published. Sau đó, 1 content publisher có thể cung cấp signing keys tương ứng cho phép người dùng xác minh nội dung đó khi nó được sử dụng. Artifactory hỗ trợ đầy đủ khi làm việc với Docker Notary để đảm bảo rằng Docker images được tải lên Artifactory có thể được ký, và sau đó được xác thực khi tải xuống sử dụng. Khi Docker client được cấu hình để hoạt động với Docker Notary, sau khi pushing 1 image sang Artifactory, client sẽ thông báo cho Notary để ký vào image trước khi gán tag.

Artifactory hỗ trợ lưu trữ image đã ký mà không cần bất kỳ cấu hình bổ sung nào.

## Configuring Docker Notary and Docker Client
Không có cấu hình cần thiết trong Artifactory để hoạt động với Docker images đáng tin cậy. Tuy nhiên, trong hướng dẫn thiết lập bên dưới, chúng tôi khuyên bạn nên kiểm tra cấu hình của mình bằng cách ký Artifactory và chạy nó trong 1 container.

Để cấu hình Docker-notary và clienr hoạt động với Artifactory, thực hiện các bước sau:
- Configure your hosts file
- Configure the Notary server and run it as a container
- Configure the Docker client

## Configuring Your Hosts File
Nếu bạn không làm việc với DNS, hãy thêm các mục sau vào tệp `/etc/hosts` của bạn:
```sh

sudo sh -c 'echo "<Host IP> <Notary Server Name>" >> /etc/hosts'
sudo sh -c 'echo "<Host IP> <Artifactory Server Name>" >> /etc/hosts'
```
## Configuring the Notary Server
Tạo 1 thư mục cho Notary-server của bạn. Trong đoạn mã dưới đây, chúng tôi sẽ sử dụng `notarybox`.

Tạo một `dockerfile` với nội dung sau:
```sh
FROM debian:jessie
 
ADD https://get.docker.com/builds/Linux/x86_64/docker-1.9.1 /usr/bin/docker
RUN chmod +x /usr/bin/docker \
    && apt-get update \
    && apt-get install -y \
    tree \
    vim \
    git \
    ca-certificates \
    --no-install-recommends
 
WORKDIR /root
RUN git clone https://github.com/docker/notary.git && \
    cp /root/notary/fixtures/root-ca.crt /usr/local/share/ca-certificates/root-ca.crt && \
    update-ca-certificates
 
ENTRYPOINT ["bash"]
```
**Use a private certificate**

Cấu hình này chạy với 1 public certificate. Bất kỳ Docker client nào chạy với cùng public certificate đều có thể truy cập Notary server của bạn.

Để thiết lập secure, chúng tôi khuyên bạn nên thay thế nó bằng organization's private certificate của bạn bằng cách thay thế public `root-ca.crt` certificate file bằng chứng chỉ riêng dưới `/root/notary/fixtures` trên Notary server của bạn và dưới `/usr/local/share/ca-certificates` trên máy chạy Docker client của bạn.

**Build the test image:**

```sh
docker build -t [image name] [path to dockerfile]
```
Nếu bạn đang chạy build trong thư mục dockerfile của mình, bạn có thể sử dụng "." như đường dẫn đến dockerfile

**Start the Notary server:**

Để khởi động Notary server, trước tiên bạn cần cài đặt `Docker Compose`.
```sh
cd notarybox 
git clone -b trust-sandbox https://github.com/docker/notary.git
cd notary
docker-compose build
docker-compose up -d
```
**Configuring the Docker Client**

Để kết nối Notary server với Docker client, bạn cần bật Docker content trust flag và Notary server URL như sau:
```sh

export DOCKER_CONTENT_TRUST=1
export DOCKER_CONTENT_TRUST_SERVER=https://notaryserver:4443
```
**Test Your Setup**

Ví dụ dưới đây cho thấy việc thiết lập Notary server và Docker client, signing 1 image và pushing nó lên Artifactory , với các giả định sau:

- Artifactory đã khởi động và chạy trong 1 Docker container
- Đã cấu hình Notary-server
- Notary server và Artifactory run trên localhost (127.0.0.1)
- Notary server là trong directory `notarybox`
- Làm việc mà không dùng DNS (nên cần cấu hình file hosts)
- Notary server tên là `notaryserver`
- Artifactory server tên là `artifactory-registry`
- Docker Compose đã được installed

**Set up the IP mappings**
```sh
sudo sh -c 'echo "127.0.0.1 notaryserver" >> /etc/hosts'
sudo sh -c 'echo "127.0.0.1 artifactory-registry" >> /etc/hosts'
```

**Pull an image for testing**
```sh
docker pull docker/trusttest
```
Sau khi pull image, bạn cần `docker login to artifactory-registry:5002/v2`

**Configure the Docker client**
```sh
export DOCKER_CONTENT_TRUST=1
export DOCKER_CONTENT_TRUST_SERVER=https://notaryserver:4443
```
Tag image bạn pull để kiểm tra và đẩy nó lên Artifactory
```sh
docker tag docker/trusttest artifactory-registry:5002/test/trusttest:latest
docker push artifactory-registry:5002/test/trusttest:latest
```
Bạn sẽ được yêu cầu nhập cụm mật khẩu root key. Điều này sẽ cần thiết mỗi khi bạn push 1 image mới trong khi `DOCKER_CONTENT_TRUST` flag được set.

root key được generated at: `/root/.docker/trust/private/root_keys`

Bạn cũng sẽ được yêu cầu nhập cụm mật khẩu mới  cho image. Điều này được tạo tại `/root/.docker/trust/private/tuf_keys/[registry name] /[imagepath]`

Docker-image được signed sau khi nó được pushed lên Artifactory.

## Tài liệu tham khảo
- https://www.jfrog.com/confluence/display/RTF/Working+with+Docker+Content+Trust

