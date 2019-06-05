# Tìm Kiếm và Thay Thế Văn Bản Sử Dụng Câu Lệnh "sed" trong Linux
## Câu Lệnh `sed`
`sed` là một trong những công cụ mạnh mẽ trong Linux giúp chúng ta có thể thực hiện các thao tác với văn bản như tìm kiếm, chỉnh sửa, xóa... Khác với các `text editor` thông thường, `sed` chấp nhận văn bản đầu vào có thể là nội dung từ một file có trên hệ thống hoặc từ standard input hay stdin. Chính vì vậy `sed` còn được gọi là một `stream editor`.

Nếu bạn thường xuyên sử dụng terminal trên Linux, bạn sẽ thấy sử dụng câu lệnh `sed` giúp chúng ta có thể thực hiện các thao tác với văn bản diễn ra nhanh hơn. 

## Tạo File Văn Bản Mẫu

Trước khi chạy câu lệnh `sed` chúng ta sẽ tạo một tập tin với tên là `test.txt` trên máy tính với nội dung như sau:
```sh
vim test.txt
foo 1
sample text
Foo 2
sample text
foO 3
```
Tìm và Thay Thế Văn Bản Sử Dụng `sed`

Câu lệnh dưới đây sẽ thực hiện việc tìm kiếm cho foo và thay thế bởi bar có trong trong test.txt
```sh
$ sed -e "s/foo/bar/g" test.txt
```
Bạn sẽ thấy terminal hiển thị kết quả:
```sh
bar 1
sample text
Foo 2
sample text
foO 3
```
Trong câu lệnh trên:

Tùy chọn `-e` dùng để thêm vào biểu thức thực thi bởi `sed`
Biểu thức `"s/foo/bar/g"` là biểu thức regular expression dùng để thực hiện việc thay thế (subtitude) foo bởi bar và việc thay thế này được thực hiện cho tất cả các kết quả foo có trong `test.txt`

File `test.txt` là tập tin chứa nội dung văn bản

Bạn có thể bỏ qua tùy chọn `/g` trong biểu thức truyền vào câu lệnh sed:
```sh
$ sed -e "s/foo/bar/" test.txt
```
Sử dụng tùy chọn i trong biểu thức regular expression, nếu bạn muốn tìm kiếm và thay thế theo kiểu không phân biệt in hoa và in thường (nghĩa là cả foo, Foo, FoO... đều sẽ được thay thế bởi bar:
```sh
$ sed -e "s/foo/bar/i" test.txt
```
Bạn sẽ thấy terminal hiển thị kết quả:
```sh
bar 1
sample text
bar 2
sample text
bar 3
```
Để thực hiện việc thay thế trực tiếp trên nội dung của file (in-place substitution) bạn sử dụng tùy chọn -i trong câu lệnh:
```sh
$ sed -i -e "s/foo/bar/g" test.txt
```
Câu lệnh trên sẽ thực hiện việc thay thế nội dung của tập tin test.txt.

Nếu bạn không muốn thay đổi trực tiếp trên file test.txt bạn có thể thêm vào giá trị cho tùy chọn -i:
```sh
$ sed -i  ".back" -e "s/foo/bar/g" test.txt
```
Câu lệnh trên sẽ lưu kết quả ra tập tin `test.txt.back`.
## Tài liệu tham khảo 
- https://www.codehub.vn/Tim-Kiem-va-Thay-The-Van-Ban-Su-Dung-Cau-Lenh-sed-trong-Linux
