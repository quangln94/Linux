# Section 1.1: Hello World
## Interactive Shell
Bash Shell thường được sử dụng tương tác: Nó cho phép bạn nhập và chỉnh sửa các lệnh, sau đó thực thi chúng khi
bạn nhấn phím Return. Nhiều hệ điều hành dựa trên Unix và Unix sử dụng Bash làm shell mặc định của chúng
(Linux và macOS). Thiết bị đầu cuối tự động nhập một quá trình Bash shell tương tác khi khởi động.
Output Hello World by typing the following:
```sh
echo "Hello World"
#> Hello World  # Output Example
```
## Note: 
- Bạn có thể thay đổi shell bằng cách gõ tên của shell trong terminal. Ví dụ: sh, bash, v.v.
- `echo` là một lệnh dựng sẵn Bash ghi các đối số mà nó nhận được vào đầu ra tiêu chuẩn. Nó nối thêm một
dòng mới đến đầu ra, theo mặc định.
## Non-Interactive Shell
Bash Shell cũng có thể được chạy không tương tác từ một tập lệnh, làm cho shell không yêu cầu tương tác của con người.
Hành vi tương tác và hành vi theo kịch bản phải giống hệt nhau - một cân nhắc thiết kế quan trọng của Unix V7
Bourne shell và Bash quá cảnh. Do đó, bất cứ điều gì có thể được thực hiện tại dòng lệnh đều có thể được đặt trong một tập lệnh
ﬁle để tái sử dụng.</br>
Follow these steps to create a Hello World script: 
- Create a new ﬁle called hello-world.sh
```sh
Create a new ﬁle called hello-world.sh 1.
```
- Make the script executable by running 
```
chmod +x hello-world.sh
```
- Add this code:
```sh
#!/bin/bash
echo "Hello World"
```
Dòng 1: Dòng đầu tiên của tập lệnh phải bắt đầu bằng chuỗi ký tự #!, Được gọi là shebang1. Các shebang hướng dẫn hệ điều hành chạy `/bin/bash`, Bash shell, truyền cho nó đường dẫn của tập lệnh dưới dạng một argument.
```sh
E.g. /bin/bash hello-world.sh
```
Dòng 2: Sử dụng lệnh `echo` để ghi `Hello World` vào đầu ra tiêu chuẩn.
4. Execute the hello-world.sh script from the command line using one of the following: 
- ./hello-world.sh – most commonly used, and recommended
- /bin/bash hello-world.sh
- bash hello-world.sh – assuming /bin is in your $PATH
- sh hello-world.sh
