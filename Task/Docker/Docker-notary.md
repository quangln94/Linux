# Docker notary
## Notary là gì
Notary là một công cụ để xuất bản và quản lý các nội dung đáng tin cậy. Các nhà xuất bản có thể ký điện tử các bộ sưu tập và người dùng có thể xác minh tính toàn vẹn và nguồn gốc của nội dung. Tính năng này được xây dựng trên giao diện ký và quản lý khóa đơn giản để tạo các bộ sưu tập đã ký và cấu hình các nhà xuất bản đáng tin cậy.

Với Notary, bất cứ ai cũng có thể cung cấp sự tin tưởng đối với các bộ sưu tập dữ liệu tùy ý. Sử dụng The Update Framework (TUF) làm khung bảo mật cơ bản, Notary đảm nhiệm các hoạt động cần thiết để tạo, quản lý và phân phối metadata cần thiết để đảm bảo tính toàn vẹn và mới mẻ của nội dung của bạn.

## Understand Notary naming

Notary sử dụng Globally Unique Names (GUN) để xác định các bộ sưu tập tin cậy. Để cho phép Notary chạy theo kiểu nhiều người thuê, bạn phải sử dụng định dạng này khi tương tác với Docker Hub thông qua Notary-client. Khi chỉ định tên Docker-image cho Notary-client, định dạng GUN như sau:
- Đối với official images, tên image được hiển thị trên Docker Hub, có tiền tố là `docker.io/library/`. Ví dụ: nếu bạn dùng `docker pull ubuntu`, bạn phải nhập `notary {cmd} docker.io/library/ubuntu`.
- Đối với tất cả các image khác, tên image được hiển thị trên Docker Hub, có tiền tố là `docker.io`.

Docker Engine client sẽ quan tâm tên các bản mở rộng này cho bạn để không thay đổi tên bạn sử dụng với ứng dụng khách hoặc API của Engine. Đây chỉ là một yêu cầu khi tương tác với Docker Hub repositories tương tự thông qua Notary client

## Inspect a Docker Hub repository

Hoạt động cơ bản nhất là liệt kê các thẻ đã ký có sẵn trong một repository. Notary client được sử dụng trong sự cô lập không biết repositories tin cậy được đặt ở đâu. Vì vậy, bạn phải cung cấp flag `-s` (hoặc `--server`) để báo cho client biết repository server nào cần liên lạc.

Các official Docker Hub Notary servers được đặt tại `https://notary.docker.io`. Nếu bạn muốn sử dụng Notary server của riêng mình, điều quan trọng là sử dụng phiên bản Notary tương tự hoặc mới hơn, vì để client tương thích tính năng (ví dụ: phiên bản client 0.2, phiên bản server/signer >= 0.2). Ngoài ra, Notary lưu trữ khóa ký của riêng bạn và cache của metadata tin cậy đã tải xuống trước đó trong một thư mục, được cung cấp với flag `-d`. Khi tương tác với Docker Hub repositories, bạn phải hướng dẫn client sử dụng thư mục tin cậy được liên kết, theo mặc định được tìm thấy tại `.docker/trust` trong thư mục home của user (không sử dụng thư mục này có thể dẫn đến lỗi khi xuất bản cập nhật lên trust data của bạn):
```sh
notary -s https://notary.docker.io -d ~/.docker/trust list docker.io/library/alpine
   NAME                                 DIGEST                                SIZE (BYTES)    ROLE
------------------------------------------------------------------------------------------------------
  2.6      e9cec9aec697d8b9d450edd32860ecd363f2f3174c8338beb5f809422d182c63   1374           targets
  2.7      9f08005dff552038f0ad2f46b8e65ff3d25641747d3912e3ea8da6785046561a   1374           targets
  3.1      e876b57b2444813cd474523b9c74aacacc238230b288a22bccece9caf2862197   1374           targets
  3.2      4a8c62881c6237b4c1434125661cddf09434d37c6ef26bf26bfaef0b8c5e2f05   1374           targets
  3.3      2d4f890b7eddb390285e3afea9be98a078c2acd2fb311da8c9048e3d1e4864d3   1374           targets
  edge     878c1b1d668830f01c2b1622ebf1656e32ce830850775d26a387b2f11f541239   1374           targets
  latest   24a36bbc059b1345b7e8be0df20f1b23caa3602e85d42fff7ecd9d0bd255de56   1377           targets
  ```
Output cho chúng ta thấy tên của các tag có sẵn, mã hóa hex sha256 digest của imagec được liên kết với tag đó, kích thước của manifest và Notary đã ký thẻ này vào repository. "targets" role là role chung nhất trong repository đơn giản. Khi một repository có (hoặc mong muốn) có cộng tác viên, bạn có thể thấy các vai trò khác được ủy quyền của những người khác được liệt kê là những người ký tên, dựa trên sự lựa chọn của quản trị viên về cách họ tổ chức các cộng tác viên của họ.

Khi bạn chạy lệnh `docker pull`, Docker Engine đang sử dụng thư viện Notary tích hợp (giống như Notary CLI) để yêu cầu ánh xạ thẻ tới sha256 digest cho một tag bạn quan tâm (hoặc nếu bạn đã vượt qua flag `--all`, client sử dụng thao tác list để lấy tất cả các ánh xạ). Sau khi xác thực các chữ ký trên dữ liệu tin cậy, client hướng dẫn Engine thực hiện thao tác `pull by digest`. Trong lần pull này, Engine sử dụng sha256 checksum làm địa chỉ nội dung để yêu cầu và xác thực bản kê khai image từ Docker registry.

## Delete a tag

Notary tạo và lưu trữ các khóa ký trên máy chủ lưu trữ mà nó đang chạy. Điều này có nghĩa là Docker Hub không thể xóa các tag khỏi dữ liệu tin cậy, chúng phải được xóa bằng cách sử dụng Notary client. Bạn có thể làm điều này với lệnh `notary remove`. Một lần nữa, bạn phải hướng nó đến Notary server chính xác. Cả bạn và tác giả đều không có quyền xóa các tag khỏi official `alpine` repository, vì vậy output dưới đây chỉ dành cho trình diễn:
```sh
$ notary -s https://notary.docker.io -d ~/.docker/trust remove docker.io/library/alpine 2.6
Removal of 2.6 from docker.io/library/alpine staged for next publish.
```
Trong ví dụ trước, output message chỉ ra rằng chỉ loại bỏ được tổ chức. Khi thực hiện bất kỳ thao tác ghi nào, chúng được sắp xếp thành một danh sách thay đổi. Danh sách này được áp dụng cho phiên bản mới nhất của repository ủy thác vào lần tiếp theo `notary publish` cho repository đó.

Bạn có thể thấy một thay đổi đang chờ xử lý bằng cách sử dụng `notary status` cho  repository đã sửa đổi. `status` là một hoạt động ngoại tuyến và do đó, không yêu cầu cờ `-s`, tuy nhiên, nó sẽ âm thầm bỏ qua cờ nếu được cung cấp. Không cung cấp giá trị chính xác cho cờ `-d` có thể hiển thị danh sách thay đổi (có thể trống):
```sh
$ notary -d ~/.docker/trust status docker.io/library/alpine
Unpublished changes for docker.io/library/alpine:

action    scope     type        path
----------------------------------------------------
delete    targets   target      2.6
$ notary -s https://notary.docker.io publish docker.io/library/alpine
```

## Configure the client

Thật dài dòng và tẻ nhạt khi luôn cung cấp các cờ `-s` và `-d` theo cách thủ công cho hầu hết các lệnh. Một cách đơn giản để tạo các phiên bản cấu hình sẵn của lệnh Notary là thông qua các bí danh. Thêm phần sau vào `.bashrc` hoặc tương đương:
```sh
alias dockernotary="notary -s https://notary.docker.io -d ~/.docker/trust"
```
Các phương pháp cấu hình nâng cao hơn và các tùy chọn bổ sung có thể được tìm thấy trong tài liệu cấu hình và bằng cách chạy `notary --help`.




## Tài liệu tham khảo
- https://docs.docker.com/notary/getting_started/
