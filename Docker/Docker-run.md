# Lệnh `docker run` cơ bản: 
```sh
docker run [OPTIONS] IMAGE[:TAG|@DIGEST] [COMMAND] [ARG...]
```
Image sử dụng định dạng image v2 trở lên có định danh địa chỉ nội dung được gọi là digest. Miễn là đầu vào được sử dụng để tạo image không thay đổi.

```sh
docker run alpine@sha256:9cacb71397b640eca97488cf08582ae4e4068513101088e9f96c9814bfda95e0 date
```
