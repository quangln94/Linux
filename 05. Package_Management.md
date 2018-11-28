# PACKAGE MANAGEMENT  
## Mục lục
[I. Package management](#packagemanagement)</br>
[II. Tài liệu tham khảo](#tailieuthamkhao)

<a name="packagemanagement"></a>
## I. Package management
### 1. Khái niệm
- Phần core của các bản phân phối linux và hầu hết các add-on software đều được cài đặt qua hệ thống quản lý package.</br>
- Mỗi package gồm files và các thành phần cần thiết để tạo lên một thành phần làm việc trên hệ thống.
- Có hai loại gói cài đặt một là source code, chưa được biên dịch nên khi sử dụng cần phải biên dịch để cho máy hiểu, cái này thường dùng cho dev nếu họ muốn đọc source code. Cái thứ hai là file binary (.deb, .rpm,...) file này đã được nhà phân phối biên dịch và và đóng gói cho user nên máy có thể hiểu được.

### 2. Các cách cài đặt
#### Cài đặt Package từ Repositoties

- Khi bạn biết tên của một gói, bạn có thể cài đặt nó và các gói phụ thuộc của nó với một câu lệnh duy nhất. Ngoài ra bạn có thể cài đặt nhiều gói cùng lúc thật đơn giản bằng cách liệt kê chúng. Sử dụng các lệnh `yum`, `apt-get`,.. để cài đặt

- Cài đặt gói từ Local Filesystem
Cài đặt các gói manual
Các gói này sẽ được cài đặt từ mã nguồn, khi tải từ trên mạng về nó sẽ được nén dưới dạng `.gz` hoặc `.bz2` sử dụng `tar` để giải nén:</br>
`tar -zxvf foo.gz`</br>
`tar -jxvf foo.bz2`</br>
Sau khi giải nén xong, tìm tệp tin INSTALL để đọc phần hướng dẫn cài đặt. Thông thường đều theo các bước sau:</br>
`./configure`</br>
`make`</br>
`make install`

Trong đó, thực chất `./configure` là một `shell script` để kiểm tra hệ thống của bạn xem có đáp ứng đủ các yêu cầu để cài đặt gói hay không. Nếu thiếu các gói phụ thuộc thì cần phải tìm và cài đặt nó rồi mới tiếp tục cài đặt được. Nếu đã sẵn sàng thì `Makefile` sẽ được tạo ra. `Makefile` là một file đặc biệt của tiện ích `make` nhằm hướng dẫn biên dịch mã nguồn của gói ra dạng thực thi

Sau khi thực hiện xong lệnh `make` thì toàn bộ mã nguồn của gói đã được biên dịch, nhưng các file thực thi này vẫn đang nằm trên thư mục hiện hành, do đó lệnh `make install` để chép nó sang đúng vị trí trên hệ thống.

Nếu muốn gỡ bỏ thì cần vào lại thư mục mã nguồn để thực hiện lệnh:

`make uninstall`</br>
`make clean`</br>
`make distclean`</br>
`make distclean` để xóa tất cả các tệp tin biên dịch ở thư mục nguồn và đồng thời xóa `Makefile`

# Package Management System

Các phần cốt lõi của bản phân phối Linux và phần lớn các phần mềm bổ sung của nó được cài đặt thông qua Hệ thống quản lý gói. Mỗi gói chứa các tệp và các hướng dẫn khác cần thiết để làm cho một thành phần phần mềm hoạt động trên hệ thống. Các gói có thể phụ thuộc vào nhau. Có hai họ quản lý gói: những người dựa trên `dpkg` và những người sử dụng `rpm` làm người quản lý gói cấp thấp của họ. Hai hệ thống không tương thích, nhưng cung cấp các tính năng tương tự ở mức độ rộng.

| High Level Tool | Low Level Tool | Family |
|-----------------|----------------|--------|
|apt-get| dpkg | Debian |
|zypper | rpm | SUSE |
|yum | rpm | Red Hat |

Cả hai hệ thống quản lý gói cung cấp hai cấp độ công cụ: một công cụ cấp thấp (như `dpkg` hoặc `rpm`), quản lý các chi tiết giải nén các gói riêng lẻ, chạy tập lệnh, cài đặt phần mềm chính xác, trong khi công cụ cấp cao (chẳng hạn như `apt-get`, `yum` hoặc `zypper`) hoạt động với các nhóm gói, tải xuống các gói từ nhà cung cấp và tìm ra các phụ thuộc.

|Operation|RPM|Debian|
|---------|---|------|
|Install a package|rpm –i foo.rpm|dpkg --install foo.deb|
|Install a package with dependencies from repository|yum install foo|apt-get install foo|
|Remove a package|rpm –e foo.rpm|dpkg --remove foo.deb|
|Remove a package and dependencies using repository|yum remove foo|apt-get remove foo|
|Update package to a newer version|rpm –U foo.rpm|dpkg --install foo.deb|
|Update package using repository and resolving dependencies|yum update foo|apt-get upgrade foo|
|Update entire system|yum update|apt-get dist-upgrade|
|Show all installed packages|yum list installed|dpkg --list|
|Get information about an installed package including files|rpm –qil foo|dpkg --listfiles foo|
|Show available package with "foo" in name|yum list foo|apt-cache search foo|
|Show all available packages|yum list|apt-cache dumpavail|
|Show packages a file belong to|rpm –qf file|dpkg --search file|

#### Update Package

| System |	Command |
|--------|---------|
|Debian/Ubuntu |	sudo apt-get update</br> sudo apt update |
|CentOS | yum check-update |
|Fedora | dnf check-update |

#### Find package

| System | Command | Notes |
|--------|---------|-------|
| Debian/Ubuntu	| apt-cache search search_string | |
| | apt search search_string |	|
| CentOS | yum search search_string | |
| | yum search all search_string | Searches tất cả các gói có tên chứa search_string |
| Fedora | dnf search search_string | |
| | dnf search all search_string | Searches all fields, including description. |

#### View info about a specific Package

| System | Command | Notes |
|--------|---------|-------|
| Debian/Ubuntu	| apt-cache show package | Hiển thị thông tin của package được lưu trữ cục bộ.|
| | apt show package | |
| | dpkg -s package | Shows the current installed status of a package. |
| CentOS | yum info package | |	
| |yum deplist package | Lists dependencies for a package.|
| Fedora | dnf info package | |	
| |dnf repoquery --requires package | Lists dependencies for a package.|

<a name="tailieuthamkhao"></a>
## II. Tài liệu tham khảo
- https://github.com/trangnth/Report_Intern/edit/master/Linux-note/5.%20Package_management.md
- https://github.com/MinhKMA/Linux-Tutorial/blob/master/content/package_management.md
