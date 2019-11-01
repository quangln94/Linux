# Docker image
Docker images được tạo thành từ một loạt các layers. Mỗi layers sẽ đại diện cho một chỉ thị trong Dockerfile

Docker file bên trên bao gồm các commands và mỗi command sẽ tạo ra một layer.

Mỗi một layer chỉ là một phần khác biệt so với layer phía trước nó. Mỗi layer sẽ được xếp lên trên layer trước nó. Điều quan trong ở đây là khi tạo một container mới thì một `writeable layer on top of the underlying layers` - một layer có thể ghi được đặt trên cùng so với những layer thuộc images mà container này được tạo ra. 

<img src=https://i.imgur.com/U11x7Iw.png>

Điểm khác biệt lớn giữa một container và image đó chính là `writeable layer` ở trên cùng này.

Tất cả những thay đổi thực hiện bên trong container sẽ được lưu lại vào layer có thể ghi này. Khi container bị xóa chúng cũng bị xóa theo và quay trở lại trạng thái unchanged (chính là bản mới sau khi vừa được build ra từ image).

Nhiều container có thể truy cập vào cùng một image nếu chúng được tạo ra từ image này và mỗi container sẽ có một layer để lưu trạng thái của riêng nó.

## 1. Dockerfile là gì ?
Dockerfile là một file dạng text không có extension, và tên bắt buộc phải là Dockerfile

Dockerfile là một file kịch bản sử dụng để tạo mới một image

## 2. Cấu trúc một Dockerfile

Dockerfile gồm các command. Mỗi command sẽ tạo ra 1 layer.

Một số command cơ bản

**FROM**
```sh
FROM ubuntu:18.04
```
FROM: chỉ định rằng image build này sẽ base trên image gốc nào

**LABEL**
```sh
LABEL "image-type"="huy-test"
LABEL "image-type1"="huy-test1"
LABEL "image-type2"="huy-test2"
```
LABEL: Chỉ định label metadata của image. Để xem được các label này sử dụng câu lệnh `docker inspect <IMAGE ID>`

**MAINTAINER**
```sh
MAINTAINER author
```
MAINTERNER: là author (tác giả) build image đó.

**RUN**
```sh
RUN yum update -y
```
RUN thực hiện một câu lệnh Linux. Tùy vào image gốc mà có các câu lệnh tương ứng (ví dụ Ubuntu sẽ là `RUN apt-get update -y`)

**COPY**
```sh
COPY start.sh /start.sh
```
COPY Copy một file từ Dockerhost vào image trong quá trình build image

**ENV**
```sh
ENV source /var/www/html/
COPY index.html ${source}
```
ENV là biến môi trường sử dụng trong quá trình build image.

ENV chỉ có thể được sử dụng trong các command sau:

**ADD**

**COPY**

**ENV**

**EXPOSE**

**FROM**

**LABEL**

**STOPSIGNAL**

**USER**

**VOLUME**

**WORKDIR**


**CMD**
```sh
CMD ["./start.sh"]
```
CMD dùng để truyền một Linux command khi khởi tạo container từ image

**VOLUME**
```sh
VOLUME ["/etc/http"]
```
VOLUME Tạo một volume nằm trong folder `/var/lib/docker/volumes` của docker host và mount với folder chẳng hạn `/etc/http` khi khởi chạy container

**EXPOSE**
```sh
EXPOSE 80 443
```
EXPOSE Chỉ định các port sẽ Listen trong container khi khởi chạy container từ image

## Tạo `image` từ `Dockerfile`
```sh
docker build -t image .
```

***Nơi lưu trữ `image`: `/var/lib/docker/image/overlay2/imagedb/content`***

***Nơi lưu trữ `container`: `/var/lib/docker/containers***

## Tài liệu tham khảo
- https://neo4j.com/blog/neo4j-containers-docker-azure/
- https://blog.cloud365.vn/container/tim-hieu-docker-phan-4/
