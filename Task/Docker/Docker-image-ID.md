# Docker image ID

Trước Docker v1.10, khi 1 Layer mới được tạo ra thông qua `commit`, Docker sẽ tạo ra 1 ần tạo một image tương ứng được xác định bởi UUID 256 bit được tạo ngẫu nhiên thường được gọi là image-ID được trình bày trong UI dưới dạng chuỗi hex ngắn 12 chữ số ngắn hoặc chuỗi hex dài 64 chữ số).

Docker lưu trữ nội dung Layer trong một thư mục có tên giống với image-ID. Bên trong image gồm cấu hình object, chứa các đặc điểm của image bao gồm ID của nó và ID của image gốc. Theo cách này, Docker có thể xây dựng một hệ thống tập tin cho một container với mỗi image  lần lượt tham chiếu đến image's parent của nó và nội dung layer tương ứng.

<img src=https://i.imgur.com/Joh7fkv.png>

```sh
$ docker inspect my_image:1.0
[
    {
        "Id": "ca1f5f48ef431c0818d5e8797dfe707557bdc728fe7c3027c75de18f934a3b76",
        "Parent": "91bac885982d2d564c0e1869e8b8827c435eead714c06d4c670aaae616c1542c"
        ...
        ...
```
Phương pháp này phục vụ Docker tốt trong một thời gian dài, nhưng theo thời gian được coi là không tối ưu vì nhiều lý do. Một trong những trình điều khiển lớn để thay đổi, xuất phát từ việc thiếu phương tiện phát hiện xem nội dung của image có bị giả mạo trong quá trình pull hoặc push từ registry chẳng hạn như Docker Hub. Điều này dẫn đến sự chỉ trích mạnh mẽ từ cộng đồng nói chung, và dẫn đến một loạt thay đổi, đỉnh điểm là nội dung ID.

Từ Docker v1.10 xuất hiện, có một sự thay đổi với cách Docker Engine xử lý image. nó không ảnh hưởng nhiều đến việc sử dụng Docker (image migration, aside), có một số thay đổi UI gây ra một số nhầm lẫn. Vậy, sự thay đổi là gì và tại sao lệnh `docker history`hiển thị một số ID là `<missing>` ?

<img src=https://i.imgur.com/4ph0oCa.png>

Từ Docker v1.10 image và layer không còn sự tương đương. Thay vào đó, một iamge trực tiếp tham chiếu một hoặc nhiều lớp mà cuối cùng đóng góp vào container's filesystem.

Các Layer được xác định bởi một thông báo, có dạng
```sh
sha256:fc92eec5cac70b0c324cec2933cd7db1c0eae7c9e2649e42d02e77eb6da0d15f
```

Nội dung của Layer được tính bằng cách áp dụng thuật toán SHA256. Nếu nội dung thay đổi, thì thông báo tính toán cũng sẽ thay đổi, có nghĩa là Docker có thể kiểm tra nội dung được truy xuất của một layer với thông báo đã đưa ra để xác minh nội dung của nó. Các layer không có khái niệm về một image hoặc thuộc về một image, chúng chỉ là tập hợp các file thư mục.

Một Docker-image bao gồm một configuration object, trong đó chứa một danh sách các bản tóm tắt layer được sắp xếp, cho phép Docker Engine lắp ráp một container's filesystem chứa tham chiếu đến các bản tóm tắt layer thay vì image's parent. image-ID cũng là một bản tóm tắt và sử dụng hàm băm SHA256, trong đó có các bản tóm tắt của các layer đóng góp vào định nghĩa filesystem của image. Sơ đồ sau mô tả mối quan hệ giữa iamge và các layer:

<img src=https://i.imgur.com/IdLy1s4.png>

## Tài liệu tham khảo
- https://windsock.io/explaining-docker-image-ids/
