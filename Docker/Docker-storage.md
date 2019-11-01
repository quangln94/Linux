# Quản lí dữ liệu trong Docker

Mặc định tất cả các file được tạo bên trong container được lưu trữ trên một writable container layer. Nó có nhiều nhược điểm:
- Dữ liệu sẽ mất khi container đó bị xóa, khó có thể truy xuất dữ liệu nếu một container khác hoặc process khác cần dữ liệu này. 
- Container layer được gắn chặt với máy host khi mà container running. Khi đó chúng ta không dễ để chuyển dữ liệu được lưu trên container layer tới chỗ khác.
- Ghi dữ liệu trên container layer cần phải đi qua 1 lớp storage driver => giảm hiệu năng ghi dữ liệu so với data volume (ghi trực tiếp lên host filesystem).

Docker hỗ trợ 3 cách để lưu trữ dữ liệu của Docker container là: volume, bind mount và tmpfs volume (Docker on Linux). Volume thường là lựa chọn tốt nhất: 
- Dữ liệu trên volume được lưu trên filesystem của Docker host `/var/lib/docker/volumes/` và được quản lý bởi Docker deamon. Các process không liên quan đến Docker sẽ không sử dụng đến phần dữ liệu này. Volumes là cách lưu trữ dữ liệu tốt nhất trên Docker.
- Bind mount có thể được lưu ở bất cứ đâu trên máy host. Các process không liên quan đến Docker hoặc một container khác có thể chỉnh sửa các file này bất kỳ lúc nào.
- Tmpfs mount được lưu trên bộ nhớ (RAM) của máy host và không ghi lên trên host filesystem (không ghi lên disk).

## 1. Docker Storage
### 1.1 Volume

Được khởi tạo và quản lý bởi Docker. Có thể khởi tạo một volume bằng cách sử dụng lệnh `docker volume create` hoặc tạo volume khi khởi tạo một  container/service.

Khi khởi tạo một volume, volume này sẽ nằm trong một thư mục xác định trên Docker host. Khi mount volume này lên container tức là chúng ta mount thư mục đó vào container. Cách thức hoạt động của volume tương tự như bind mount, ngoại trừ việc volume được quản lý bởi Docker và được tách biệt (isolate) với các thành phần khác của máy host.

Một volume có thể được mount lên nhiều container cùng một lúc. Khi không có container nào sử dụng volume đó, volume này vẫn tồn tại và được quản lý bởi Docker mà không bị xóa đi như container layer. Có thể xóa tất cả các volume không sử dụng bằng cách dùng lệnh `docker volume prune`.

Có thể đặt tên cho một volume, nếu chúng ta không đặt tên thì Docker sẽ tự động đặt tên cho volume đó và tên này là duy nhất trên một Docker host.

Volume trên Docker hỗ trợ dùng nhiều loại volume drivers, cho phép lưu trữ dữ liệu trên remote host hoặc trên hạ tầng lưu trữ của các nhà cung cấp dịch vụ cloud.

### 1.2 Khi nào nên dùng volume

Volume là cách thường được dùng khi cần lưu trữ dữ liệu lâu dài trong container và services. Một số ứng dụng của volumes gồm:

Chia sẻ dữ liệu giữa nhiều container đang chạy cùng lúc. Nhiều container có thể đồng thời mount cùng 1 volume. (read-write hoặc read only). Volume không tự động xóa đi, cần phải gõ lệnh nếu muốn xóa volume.

Khi muốn lưu trữ dữ liệu của container trên remote host hoặc trên cloud provider (AWS, GCE, Azure…).

Hoạt động được trên cả Linux và Windows container.

Dữ liệu được lưu trên volume sẽ không làm tăng kích thước của container.

Khi cần backup, phục hồi hoặc di chuyển dữ liệu từ một Docker host này sang một host khác, volume là sự lựa chọn lý tưởng trong những trường hợp này. Ta có thể tạm dừng một container, backup volume của container này (thường nằm trong `/var/lib/docker/volumes/`)

### 2.1 Bind mounts

Có từ thời xửa thời xưa khi Docker mới ra đời. So với volume thì bind mount có ít chức năng hơn. Khi chúng ta dùng bind mount, chúng ta có thể mount 1 file hoặc một thư mục vào container. File hoặc thư mục này được truy cập theo đường dẫn tuyệt đối trên máy host. Bind mount có hiệu năng truy xuất rất cao, nhưng phụ thuộc vào file system của máy host.

Chú ý: khi dùng bind mount, các process trong container có thể thay đổi filesystem của máy host (tạo file, thêm xóa sửa các dữ liệu hoặc thư mục quan trọng của hệ thống). Tính năng này tuy mạnh nhưng có thể tạo ra nhiều nguy cơ về bảo mật, gây ảnh hưởng tới các process khác trên máy host.

### 2.2 Khi nào nên dùng bind mount

Chia sẻ các file cấu hình từ máy host sang container. Ví dụ: bind mount file `/etc/resolv.conf` từ máy host lên mỗi container.

Chia sẻ source code từ Docker host sang container.

Khi file container cần file và thư mục phải đồng bộ với Docker host.

### 3.1 tmpfs mounts

tmpfs mount không được lưu trên đĩa cứng. tmpfs mount thường được dùng để lưu dữ liệu khi container đang chạy (dữ liệu này không cần được lưu trữ lâu dài).

### 3.2 Khi nào nên dùng tmpfs mount

tmpfs mount được dùng khi chúng ta không muốn lưu dữ liệu lâu dài trên cả máy host hoặc trong container vì lý do an ninh. Hoặc do chúng ta muốn đảm bảo hiệu năng của container khi cần xử lý một lượng lớn dữ liệu tạm thời

## 2. Một số chú ý khi dùng bind mount hoặc volume

Khi dùng bind mount hoặc volume thì cần chú ý những điều sau:

Nếu mount một volume trống từ host lên container, và trong thư mục tương ứng trên container đã có sẵn dữ liệu thì các file trên đó sẽ được copy vào volume. Tương tự vậy, nếu chúng ta khởi động một container và yêu cầu một volume (volume này chưa tồn tại), Docker engine sẽ tạo ra một volume trống cho ta.

Nếu mount một bind mount hoặc một volume đã có dữ liệu vào một thư mục trên container và thư mục này cũng đã có dữ liệu, dữ liệu trên container sẽ bị “tạm thời thay thế” bởi dữ liệu mới mount. Khi unmount thì dữ liệu này sẽ hiện ra như cũ.

Khi dùng cờ `-v` hoặc `--volume` để bind-mount một file hay thư mục chưa tồn tại trên Docker host thì Docker sẽ tạo ra một thư mục mới.

Nếu chúng ta dùng cờ `--mount` để bind-mount một file hay thư mục chưa tồn tại trên Docker host thì Docker không tự động tạo thư mục mới mà sẽ thông báo lỗi.

## 3. Ví dụ về sử dụng docker storage

Giả sử cần develop một ứng dụng wordpress bao gồm 2 container:

wordpress: chứa mã nguồn và chạy ứng dụng wordpress

mariadb: chạy ứng dụng mariadb database (giống với mysql database)

Khi đó ta sẽ sử dụng bind mount mã nguồn của wordpress vào container wordpress, sử dụng volume để persist data của mariadb database. Sử dụng với docker compose ta có thể xem file docker-compose.yml sau. (các bạn có thể xem chi tiết file docker-compose.yml và cấu trúc thư mục [tại đây](https://github.com/cuongtransc/docker-training/tree/master/compose/wordpress):
```sh
services:
    wordpress:
        image: cuongtransc/wordpress:4.8
        ports:
            - "80:80"
        networks:
            - back
        volumes:
            - ./wordpress-data/:/var/www/html/ 

    mariadb:
        image: mariadb:10.1
        networks:
            - back
        volumes:
            - mariadb-data:/var/lib/mysql/

networks:
    back:
    
volumes:
    - mariadb-data
```

Với cách làm như trên, khi chúng ta sửa source code của wordpress trên máy host của chúng ta thì source code wordpress trong container cũng được thay đổi theo mà không cần build lại image. Còn với mariadb dữ liệu cũng được persistent và được Docker đảm bảo an toàn, không cho tiến trình khác có thể sửa đổi.

## Tài liệu tham khảo
- https://viblo.asia/p/docker-va-nhung-kien-thuc-co-ban-YWOZrp075Q0
- https://devopsz.com/manage-data-in-docker/
- https://docs.docker.com/storage/
- https://cloudcraft.info/nhap-mon-docker-phan-2-gioi-thieu-cac-kieu-luu-tru-du-lieu-tren-docker/
