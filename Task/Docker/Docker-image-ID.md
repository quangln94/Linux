# Docker image ID

Trước Docker v1.10, khi 1 Layer mới được tạo ra thông qua `commit`, Docker sẽ tạo ra 1 một image tương ứng được xác định bởi UUID 256 bit được tạo ngẫu nhiên thường được gọi là image-ID được trình bày trong UI dưới dạng chuỗi hex ngắn 12 chữ số ngắn hoặc chuỗi hex dài 64 chữ số).

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

Thư mục diff để lưu trữ nội dung layer, được đặt tên theo 'cache ID' được tạo ngẫu nhiên và Docker Engine duy trì liên kết giữa layer và cache ID của nó để nó biết vị trí của nội dung của layer trên disk.

Vì vậy, khi Docker-image được pull từ registry và lệnh `docker history` được sử dụng:

<img src=https://i.imgur.com/4ph0oCa.png>

Do các layer không còn đồng đơng với image-ID tương ứng

## Build image local

Image được build trên máy chủ Docker host được xử lý hơi khác nhau. Image vẫn giữ nguyên vẫn bao gồm các layer.

Tuy nhiên, khi một layer được commit trong quá trình build image trên Docker host, image trung gian sẽ được tạo. Cũng giống như tất cả các image khác, nó gồm các layer được kết hợp như một phần của image và ID. Image trung gian không được gắn với tên nhưng chúng có khóa 'Parent', chứa ID của image gốc.

Mục đích của các hình ảnh trung gian và tham chiếu đến hình ảnh gốc là để tạo thuận lợi cho việc sử dụng bộ đệm xây dựng của Docker. Build cache là một tính năng quan trọng khác của Docker và được sử dụng để giúp Docker Engine sử dụng nội dung layer có sẵn, thay vì tái tạo nội dung một cách không cần thiết cho một lệnh build giống hệt nhau. Nó làm cho quá trình build hiệu quả hơn. Khi một image được build local, lệnh `docker history` có thể như sau:
```sh
$ docker history jbloggs/my_image:latest 
IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
26cca5b0c787        52 seconds ago      /bin/sh -c #(nop) CMD ["/bin/sh" "-c" "/bin/b   0 B                 
97e47fb9e0a6        52 seconds ago      /bin/sh -c apt-get update &&     apt-get inst   16.98 MB            
1742affe03b5        13 days ago         /bin/sh -c #(nop) CMD ["/bin/bash"]             0 B                 
<missing>           13 days ago         /bin/sh -c #(nop) ADD file:5d8521419ad6cfb695   125.1 MB
```

Trong ví dụ này, hai layer trên cùng được tạo trong quá trình build image local, trong khi các layer dưới cùng xuất phát từ base image. Có thể sử dụng lệnh `docker inspect` để xem các layer liên quan đến image:
```sh
$ docker inspect jboggs/my_image:latest 
[
    {
        ...
        ...
        "RootFS": {
            "Type": "layers",
            "Layers": [
                "sha256:4dcab49015d47e8f300ec33400a02cebc7b54cadd09c37e49eccbc655279da90",
                "sha256:5f70bf18a086007016e948b04aed3b82103a36bea41755b6cddfaf10ace3c6ef",
                "sha256:f22bfbc1df820c465d94215e45bf9b1f0ae0fe3435a90dc5296a4b55712f46e7"
            ]
        }
    }
]
```

Lệnh `docker history` cho thấy image có bốn layer, nhưng `docker inspect` cho thấy chỉ có ba layer. Điều này là do hai hướng dẫn của CMD tạo ra metadata cho image, không thêm bất kỳ nội dung nào và do đó 'diff' trống. `5f70bf18a08a` là hàm băm SHA256 của một layer trống và được chia sẻ bởi cả hai layer.

Khi một local build image được đẩy đến một registry, đó chỉ là lead image được tải lên cùng với các layer của nó và một lần pull tiếp theo bởi một Docker host khác sẽ không mang lại bất kỳ image's parent trung gian nào. Điều này là do một khi image được cung cấp cho những người dùng khác trên các Docker host thông qua registry, nó sẽ chỉ đọc và các thành phần hỗ trợ build cache không còn cần thiết nữa. Thay vì image-ID, <missing> được chèn đó.
    
## Pushing image lên registry:
```sh
$ docker push jbloggs/my_image:latest
The push refers to a repository [docker.io/jbloggs/my_image]
f22bfbc1df82: Pushed 
5f70bf18a086: Layer already exists 
4dcab49015d4: Layer already exists 
latest: digest: sha256:7f63e3661b1377e2658e458ac1ff6d5e0079f0cfd9ff2830786d1b45ae1bb820 size: 3147
```

Trong ví dụ này, chỉ có một layer push, vì hai trong số các layer đã tồn tại trong registry, được tham chiếu bởi một hoặc nhiều image khác sử dụng cùng một nội dung.

## Tài liệu tham khảo
- https://windsock.io/explaining-docker-image-ids/
- https://github.com/moby/moby/issues/20131
- https://stackoverflow.com/questions/35310212/docker-missing-layer-ids-in-output
