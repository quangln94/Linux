# Apache là gì
Apache là phần mềm web server miễn phí mã nguồn mở. Nó đang chiếm đến khoảng 46% thị phần websites trên toàn thế giới. Tên chính thức của Apache là Apache HTTP Server, được điều hành và phát triển bởi Apache Software Foundation.</br>
Nó giúp chủ website đưa nội dung lên web – vì vậy có tên gọi là **web server**. Apache là một trong số những web server lâu đời và đáng tin cậy nhất, phiên bản đầu tiên đã được ra mắt từ hơn 20 năm trước, tận những năm 1995.</br>
Khi một người truy cập vào website của bạn, họ sẽ điền tên miền vào thanh địa chỉ. Sau đó, web server sẽ chuyển những files được yêu cầu xuống như là một nhân viên chuyển hàng ảo.
# Web Server là gì?
File servers, database servers, mail servers, và web servers sử dụng nhiều phần mềm server khác nhau. Từng ứng dụng sẽ truy cập files riêng lưu trên server vật lý và dùng chung cho các mục đích khác nhau.</br>
Nhiệm vụ của web server là đưa website lên internet. Để làm được điều đó, nó hoạt động giống như là một người đứng giữa server và máy khách (client). Nó sẽ kéo nội dung từ server về cho mỗi một truy vấn xuất phát từ máy khách để hiển thị kết quả tương ứng dưới hình thức là một website.</br>
Điểm khó khăn lớn nhất của một web server là kéo dữ liệu cho nhiều người dùng cùng một lúc – vì mỗi một người lại cũng đang truy vấn tới các trang web khác nhau. Web server xử lý các file này dưới ngôn ngữ lập trình như là PHP, Python, Java,....</br>
Những ngôn ngữ này biến chúng thành file HTML và file trên trình duyệt cho người dùng web thấy được. Khi bạn nghe tới cụm từ “web server”, hãy hiểu rằng nó là công cụ chịu trách nhiệm giao tiếp giữa server-client.
# Apache Web Server hoạt động như thế nào?
Mặc dù chúng ta gọi Apache là web server, nhưng nó lại không phải là server vật lý, nó là một phần mềm chạy trên server đó. Công việc của nó là thiết lập kết nối giữa server và trình duyệt người dùng (Firefox, Google Chrome, Safari,....) rồi chuyển file tới và lui giữa chúng (cấu trúc 2 chiều dạng client-server). Apache là một phần mềm đa nền tảng, nó hoạt động tốt với cả server Unix và Windows.</br>
Khi một khách truy cập tải một trang web trên website của bạn, ví dụ, trang chủ “About Us”,trình duyệt người dùng sẽ gửi yêu cầu tải trang web đó lên server và Apache sẽ trả kết quả với tất cả đầy đủ các file cấu thành nên trang About Us (hình ảnh, chữ, vâng vâng). Server và client giao tiếp với nhau qua giao thức HTTP và Apache chịu trách nhiệm cho việc đảm bảo tiến trình này diễn ra mượt mà và bảo mật giữa 2 máy.</br>
Apache là một nền tảng module có độ tùy biến rất cao. Moduels cho phép quản trị server tắt hoặc thêm chức năng. Apache có modules cho bảo mật caching, URL rewriting, chứng thực mật khẩu, vâng vâng.
# Apache vs Những Web Servers khác
Bên cạnh Apache, cũng có nhiều web server khác nữa. Mỗi một ứng dụng web server lại có mục tiêu khác nhau. Apache được sử dụng nhiều nhất nhưng các đối thủ cũng có thể mạnh riêng.
# Apache vs NGINX
Nginx, phát âm là Engine-X, là một ứng dụng web server được phát hành năm 2004. Ngày nay, nó đã phổ biến rất nhiều trong giới lập trình web. Nginx được tạo để xử lý các vấn đề được gọi là c10k problem (10,000 connections), có nghĩa là web server sử dụng threads để xử lý truy vấn của khách không thể thực hiện được hơn 10,000 kết nối cùng lúc.</br>
Vì Apache sử dụng cấu trúc dạng thread, chủ sở hữu các website nặng có traffic lớn sẽ gặp phải vấn đề hiệu xuất. Nginx là một trong các web server có thể xử lý vấn đề c10k và có lẽ là phần mềm thành công nhất làm việc này.</br>
Nginx có kiến trúc xử lý dạng “sự kiện” (event) không phải tạo process mới cho mỗi truy vấn. Thay vào đó, nó xử lý truy vấn trong một thread duy nhất. Master process sẽ quản lý nhiều worker processes mà thực sự quản lý việc xử lý truy vấn. Dạng quản lý sự kiện như vậy của Nginx phân tán truy vấn một cách hiệu quả để đạt hiệu quả quản lý tốt hơn.
Nếu bạn có một website có traffic lớn, Nginx là lựa chọn tối ưu, vì nó có thể xử lý nhiều tiến trình với tài nguyên thấp nhất có thể. Không phải ngẫu nhiên mà nhiều website lớn như Netflix, Hulu Pinterest, Airbnb đều đang sử dụng nó.
Tuy nhiên, đối với những doanh nghiệp vừa và nhỏ, Apache tỏ ra hiệu quả hơn Nginx, vì nó dễ cấu hình hơn, nhiều modules hơnv à là một môi trường thân thiện cho người mới bắt đầu hơn.
# Apache vs Tomcat
Tomcat là một web server cũng được phát triển bởi Apache Software Foundation, vì vậy tên chính thức của nó là Apache Tomcat. Nó cũng là một server HTTP, tuy nhiên, nó hỗ trợ mạnh cho ứng dụng Java thay vì website tĩnh. Tomcat có thể chạy nhiều bản Java chuyên biệt như Java Servlet, JavaServer Pages (JSP), Java EL, và WebSocket.

Tomcat được tạo đặc biệt riêng cho Java apps, mặc dù Apache là vẫn là một server HTTP. Bạn có thể sử dụng Apache với nhiều ngôn ngữ lập trình khác (PHP, Python, Perl, vâng vâng.) với sự giúp đỡ của module Apache phù hợp (mod_php, mod_python, mod_perl, etc.).
Mặc dù bạn có thể sử dụng Tomcat server để phục vụ trang web tĩnh, nhưng nó không hiệu quả như là khi sử dụng Apache. Ví dụ, Tomcat sẽ tải máy ảo Java lên trước và những thư viện Java liên quan khác, mà website thông thường thì không cần thiết.
Tomcat cũng khó cấu hình hơn các web server khác. Ví dụ, để chạy WordPress, hãy dùng các server dành cho HTTP như là Apache hoặc NGINX.
Ưu điểm và khuyết điểm của Apache
Apache web server là lựa chọn ưu việc để vận hành một website ổn định và có thể tùy chỉnh linh hoạt. Tuy nhiên, nó cũng có một số điểm bất lợi mà bạn nên biết.

# Ưu điểm:
Phần mềm mã nguồn mở và miễn phí, kể cả cho mục đích thương mại.
Phần mềm đáng tin cậy, ổn định.
Được cập nhật thường xuyên, nhiều bản vá lỗi bảo mật liên tục.
Linh hoạt vì có cấu trúc module.
Dễ cấu hình, thân thiện với người mới bắt đầu
Đa nền tảng (hoạt động được cả với server Unix và Windows).
Hoạt động cực kỳ hiệu quả với WordPress sites.
Có cộng đồng lớn và sẵn sàng hỗ trợ với bất kỳ vấn đề nào.
# Nhược điểm:
Gặp vấn đề hiệu năng nếu website có lượng truy cập cực lớn.
Quá nhiều lựa chọn thiết lập có thể gây ra các điểm yếu bảo mật.
# Reference
https://www.hostinger.vn/huong-dan/apache-la-gi-giai-thich-cho-nguoi-moi-bat-dau-hieu-ve-apache-web-server/
