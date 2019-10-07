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
