# Database Management System - DBMS
## 1. Khái niệm
Hệ quản trị cơ sở dữ liệu (Database Management System – DBMS), là phần mềm hay hệ thống được thiết kế để quản trị một cơ sở dữ liệu. Cụ thể, các chương trình thuộc loại này hỗ trợ khả năng lưu trữ, sửa chữa, xóa và tìm kiếm thông tin trong một cơ sở dữ liệu (CSDL). Có rất nhiều loại hệ quản trị CSDL khác nhau: từ phần mềm nhỏ chạy trên máy tính cá nhân cho đến những hệ quản trị phức tạp chạy trên một hoặc nhiều siêu máy tính.</br>
Tuy nhiên, đa số hệ quản trị CSDL trên thị trường đều có một đặc điểm chung là sử dụng ngôn ngữ truy vấn theo cấu trúc mà tiếng Anh gọi là Structured Query Language(SQL). Các hệ quản trị CSDL phổ biến được nhiều người biết đến là MySQL, Oracle, PostgreSQL, SQL Server, DB2, Infomix, v.v. Phần lớn các hệ quản trị CSDL kể trên hoạt động tốt trên nhiều hệ điều hành khác nhau như Linux, Unix và MacOS ngoại trừ SQL Server của Microsoft hiện nay đã chạy trên hệ điều hành Linux.

***Ưu điểm của DBMS:***
* Quản lý được dữ liệu dư thừa.
* Đảm báo tính nhất quán cho dữ liệu.
* Tạo khả năng chia sẻ dữ liệu nhiều hơn.
* Cải tiến tính toàn vẹn cho dữ liệu.

***Nhược điểm Hệ quản trị cơ sở dữ liệu***:
* HQTCSDL tốt thì khá phức tạp.
* HQTCSDL tốt thường rất lớn chiếm nhiều dung lượng bộ nhớ.
* Giá cả khác nhau tùy theo môi trường và chức năng.
* HQTCSDL được viết tổng quát cho nhiều người dùng thì thường chậm.

## MySQL
MySQL  là  một  hệ  quản  trị  cơ  sở  dữ  liệu  đa  luồng  mã  nguồn  mở  theo  mô  hình 
client/server, và ở mức độ chuyên dụng  cho doanh nghiệp. MySQL được phát triển bởi một 
công ty tư vấn và phát triển ứng dụng của Thuỵ Điển có tên là TcX.</br> 
MySQL là một hệ quản trị cơ sở dữ liệu có tốc độ truy xuất rất nhanh và uyển chuyển. 
MySQL được phát triển phổ biến cho hệ điều hành Linux, tuy nhiên, với các phiên bản mới 
hiện nay, nó đã có thể sử dụng tốt trên của hệ điều hành Windows.</br>
Chúng ta cần phân biệt giữa MySQL và SQL, SQL là ngôn ngữ dùng để truy xuất cơ sở 
dữ liệu được hãng phần mềm IBM phát triển và được sử dụng ở đa số các hệ quản trị CSDL 
hiện  nay  như  MySQL,  Microsoft  SQL  Server,  DB2,  Sysbase  Adapter  Server,  SQL 
Lite,Oraccle… 

## MariaDB
MariaDB là một nhánh của MySQL( một trong những CSDL phổ biến trên thế giới ), là máy chủ cơ sở dữ liệu cung cấp các chức năng thay thế cho MySQL. MariaDB được xây dựng bởi một số tác giả sáng lập ra MySQL được sự hỗ trợ của đông đảo cộng đồng các nhà phát triển phần mềm mã nguồn mở. Ngoài việc kế thừa các chức năng cốt lõi của MySQL, MariaDB cung cấp thêm nhiều tính năng cải tiến về cơ chế lưu trữ, tối ưu máy chủ.
MariaDB phát hành phiên bản đầu tiên vào 11/2008 bởi Monty Widenius, người đồng sáng lập MySQL. Widenius sau khi nghỉ công tác cho MySQL ( sau khi Sun mua lại MySQL ) đã thành lập công ty Monty Program AB và phát triển MariaDB.
Chúng ta có thể tìm hiểu rõ hơn tại https://mariadb.org/ , MariaDB có các phiên bản cho các hệ điều hành khác nhau: Windows, Linux,.. với các gói cài đặt tar, zip, MSI, rpm cho cả 32bit và 64bit. Hiện tại phiên bản mới nhất của MariaDB là 10.1.
 
## MariaDB và MySQL
Do sự tương thích giữa MariaDB và MySQL nên trong hầu hết trường hợp chúng ta có thể xóa bỏ MySQL và cài đặt MariaDB để thay thế mà hệ thống vẫn hoạt động bình thường. Trên MariaDB và MySQL có:
     + Data and table definition files (.frm) files hoàn toàn tương thích
     + Tất cả client APIs, protocols and structs hoàn toàn giống nhau
     + Tất cả filenames, binaries, paths, ports, sockets,... hoàn toàn giống nhau
     + Tất cả MySQL connectors (PHP, Perl, Python, Java, .NET, MyODBC, Ruby, MySQL C connector etc) đều hoạt động bình thường khi đổi qua MariaDB
     + Gói mysql-client cũng hoạt động khi dùng với MariaDB
 
Ngoài việc hỗ trợ các storage engines cơ bản như MyISAM, BLACKHOLE, CSV, MEMORY, ARCHIVE, and MERGE thì trên MariaDB còn bổ sung thêm các storage engines sau:
     + Aria (được xem như một phiên bản cập nhập của MyISAM)
     + XtraDB (thay thế cho InnoDB)
     + FederatedX
     + OQGRAPH
     + SphinxSE
     + IBMDB2I
     + TokuDB
     + Cassandra
     + CONNECT
     +SEQUENCE
     + Spider
     + PBXT
 
Ngoài ra trên MariaDB còn cải thiện hiệu năng và cung cấp thêm một số chức năng mới. Chúng ta có thể tham khảo chi tiết tại: https://mariadb.com/kb/en/mariadb/mariadb-vs-mysql-features/
