# MONITOR ZABBIX 
## 1. Tổng quan zabbix
+ Zabbix là một công cụ để  giám sát hệ thống mạng, các thiết bị mạng, giám sát khả năng sẵn sàng và hiệu năng của mạng và thiết bị mạng. Nếu có xảy ra lỗi thì sẽ có cảnh báo gửi tới người quản trị mạng qua sms, email...
+ Là công cụ mã nguồn mở miễn phí. 
+ Được phát hành theo giấy phép GPlv2, không giới hạn về sức chứa và số lượng thiết bị được giám sát
+ Hỗ trợ bất kỳ kích thước của mô hình mạng nào. Có thể là mô hình nhỏ hoặc mô hình lớn, thường xuyên cập nhật và phát hành phiên bản mới.
+ Zabbix được viết năm 1998, là dự án của Alexei Vladishev (Alexei Vladishev dùng để monitor hệ thống database)
## 2. Zabbix Features 
Zabbix cũng cấp những tính năng quan trọng và cần thiết cho việc monitor hệ thống và các thiết bị mạng.</br>
Zabbix dựa trên các agent và agentless để giám sát hệ thống mạng và các thiết bị mạng. Các thiết bị mạng phải hỗ trợ giao thức SNMP.</br>
Zabbix giám sát hiệu suất, hiệu năng của máy chủ vật lý cũng như máy ảo.</br>
Trong TH có lỗi xảy ra zabbix cảnh báo cho người quản trị, tuy nhiên zabbix không có khả năng phát hiện hay dự đoán lỗi có thể xảy ra.</br>
**2.1. Open source**</br>
**2.2. Agent-based vs Agentless**</br>
* Agent-based

Đây là một phần mềm được gọi là agent được cài đặt trên máy chủ local và các thiết bị cần monitor. Mục tiêu của nó là thu thập thông tin gửi về zabbix-server và có thể cảnh báo tới người quản trị.</br>
Agent được cài đặt đơn giản nhẹ nhàng, tiêu thụ ít tài nguyên của server.</br>
Lợi ích của việc sử dụng agent là phân tích sâu hơn, ngoài ra có thể chuẩn đoán được hiệu suất phần cứng, cung cấp khả năng cảnh bảo và report.
* Agentless

Agentless là một giải pháp không yêu cầu bất kỳ cài đặt agent riêng biệt nào. Phân tích mạng dựa trên giám sát package trực tiếp. Nó được sử dụng để giám sát tính sẵn sàng của mạng và hiệu suất. Tuy nhiên, nó không cung cấp bất kỳ thông tin chi tiết nào về lỗi.</br>
Dựa trên giao thức SNMP hoặc WMI, được dựa trên một trạm quản lý trung tâm, giám sát tất cả các thiết bị mạng khác.</br>
Việc cài đặt không ảnh hưởng đến hiệu suất của server. Quá trình triển khai dễ dàng hơn, không phải cập nhật thường xuyên từ các agent. Tuy nhiên lại không đi sâu thu thập được các số liệu, không cung cấp khả năng phân tích và báo cáo.</br>
Trong khi zabbix-agent cung cấp những tính năng tuyệt vời trên một số nền tảng, nhưng cũng có trường hợp có những nên tảng không thể cài đặt được nó. Đối với trường hợp này phương thức agentless được cung cấp bới zabbix server
- Tính năng của Agentless

Network Services Check: Zabbix server có thể kiểm tra một service đang lắng nghe trên port nào hoặc chúng phản hồi có đúng không. Phương thức này hiện tại support cho một số service như: FTP, IMAP, HTTP, HTTPS, LDAP, NNTP, POP3, SMTP, SSH, TCP and Telnet. Đối với các trường hợp không được xử lý bởi mục trước đó, Zabbix server có thể kiểm tra xem có gì đang lắng nghe trên cổng TCP hay không, thông báo nếu một dịch vụ có sẵn hay không.
```sh
TCP port availability
TCP port response time
Service check
```        
ICMP Ping: Mặc dù đơn giản nhưng quan trọng, Zabbix có thể kiểm tra xem máy chủ có đang phản hồi các gói ping ICMP hay không. Vì vậy, nó có thể kiểm soát sự sẵn có của một máy chủ, cũng như thời gian phản hồi và mất gói tin.
Kiểm tra có thể được tùy chỉnh bằng cách thiết lập kích thước và số lượng gói tin, thời gian chờ và độ trễ giữa mỗi gói.
```sh
Server availability
ICMP response time
Packet loss
```
Remote Check: Khi cấu hình agent zabbix không hỗ trợ, nhưng truy cập thông qua SSH hoặc Telnet sẵn sàng, một máy chủ Zabbix có thể chạy bất kỳ lệnh tùy chỉnh nào và sử dụng lệnh trả về của nó như là một giá trị được thu thập. Từ giá trị này có thể, ví dụ, để tạo ra các đồ thị và alert.
```sh
Executing commands via SSH or Telnet
```
**2.3 Auto discovery**</br>
Hệ thống được cập nhật khi hệ thông có sự thay đổi Các thiết bị mới được thêm cần được tự động phát hiện. Để theo dõi việc tự động thay đổi môi trường liên tục thay đổi được sử dụng tính năng Auto discovery.</br>
Đây là một tính năng cho phép thực hiện tìm kiếm các phần tử mạng. Ngoài ra, nó sẽ tự động thêm các thiết bị mới và loại bỏ các thiết bị không còn là một phần của mạng. Nó cũng thực hiện việc khám phá các network interface, các port và các hệ thống file.</br>
Auto discovery có thể được sử dụng để tìm ra trạng thái hiện tại trong mạng. Những thiết bị và dịch vụ nào hiện có trên mạng. Ngoài ra, nó giúp trong các vấn đề bảo mật. Nó giúp xác minh những cổng nào được kích hoạt.</br>
Auto discovery có thể ping hoặc truy vấn mọi thiết bị trên mạng. Nếu mạng có Hệ thống Phát hiện xâm phạm (IDS), tính năng phát hiện tự động có thể kích hoạt báo động xâm nhập.</br>
Phát hiện tự động đóng một phần thiết yếu trong giám sát mạng, một số công cụ khác không cung cấp tính năng này. Đó là lý do tại sao các quản trị mạng nên chú ý auto discovery khi chọn công cụ giám sát mạng.</br>
**2.4. Low-level discovery**</br>
Low-level discovery (LLD) được sử dụng để giám sát các hệ thống file và interface mà không cần tạo và thêm thủ công từng phần tử. LLD là một tính năng động tự động thêm và xóa các phần tử. Nó cũng tự động tạo ra triggers, graphs cho file systems, network interfaces và SNMP tables.</br>
**2.5. Trend Prediction**</br>
Một số công cụ theo dõi mạng có một tính năng dự đoán. Nó được sử dụng để phát hiện một lỗi trước khi nó xảy ra. Điều này được thực hiện bằng cách thu thập dữ liệu về băng thông mạng và trạng thái của các thiết bị theo mức độ hoạt động. Tất cả các thông tin được lưu trữ trong cơ sở dữ liệu SQL. Các kết quả giám sát tiếp theo được so sánh với thông tin được lưu trữ trong cơ sở dữ liệu. Nếu một số thay đổi giữa dữ liệu đã được tìm thấy, giám sát mạng sẽ tạo ra một cảnh báo.</br>
Dự đoán xu hướng cho phép phát hiện vấn đề trước, để quản trị viên có thể giải quyết nó trước khi người dùng cuối nhận thấy nó. Mặc dù tính năng này hay nhưng hầu hết các sản phẩm vẫn không hỗ trợ tính năng này.</br>
**2.6. Logical grouping**</br>
Trong các mạng lớn bao gồm nhiều thiết bị, khó để theo dõi và khắc phục tất cả các thiết bị trong quá trình giám sát mạng. Logical grouping cho phép kết hợp cùng một loại thiết bị lại với nhau. Kết quả là logical grouping giúp việc giám sát các mạng cấp doanh nghiệp dễ dàng hơn đáng kể.</br>
Logical grouping cho phép kết hợp cùng một loại thiết bị mạng thành các nhóm. Đối với mỗi nhóm có thể được xác định những gì cần được theo dõi và những hành động nên được thực hiện trong trường hợp xảy ra lỗi. Ngoài ra, với việc Logical grouping có thể định cấu hình cài đặt hợp nhất cho tất cả phần tử của nhóm. Nếu một hoặc nhiều phần tử của nhóm ngừng hoạt động một cảnh báo sẽ được hiển thị.</br>
Có thể tạo các nhóm lồng nhau cho các mạng lớn. Điều này có nghĩa là các nhóm có thể được tạo bên trong một nhóm khác. Kết quả là, việc quản lý các thiết bị mạng bên trong một mạng lớn trở nên dễ dàng hơn.
## 3. Zabbix architecture
![](https://i.imgur.com/pJk3TPx.png)

Zabbix bao gồm các thành phần sau: abbix Server, Zabbix Proxy, Zabbix Agent và Web Interface.
+ Zabbix server: Đây là thành phần trung tâm của phần mềm Zabbix. Zabbix Server có thể kiểm tra các dịch vụ mạng từ xa thông qua các báo cáo của Agent gửi về cho Zabbix Server và từ đó nó sẽ lưu trữ tất cả các cấu hình cũng như là các số liệu thống kê.
+ Zabbix Proxy: Là phần tùy chọn của Zabbix có nhiệm vụ thu nhận dữ liệu, lưu trong bộ nhớ đệm và chuyển đến Zabbix Server.
+ Zabbix Agent: Để giám sát chủ động các thiết bị cục bộ và các ứng dụng (ổ cứng, bộ nhớ…) trên hệ thống mạng. Zabbix Agent sẽ được cài lên trên Server và từ đó Agent sẽ thu thập thông tin hoạt động từ Server mà nó đang chạy và báo cáo dữ liệu này đến Zabbix Server để xử lý.
+ Web interface: Để dễ dàng truy cập dữ liệu theo dõi và sau đó cấu hình từ giao diện web cung cấp.
![](https://i.imgur.com/3Wz2NkO.png)

**4. Ưu điểm của zabbix**</br>
Zabbix đáp ứng các yêu cầu của công cụ giám sát mạng đáng tin cậy tới 90%. Nó thực hiện cả giám sát agent-based, agentless. Hỗ trợ Low level Discovery, Auto-Discovery Logical grouping. Tất cả các tính năng nêu trên làm cho Zabbix trở thành một công cụ giám sát mạng hoàn hảo, đáp ứng đầy đủ các yêu cầu của bất kỳ mạng kích thước nào. Tuy nhiên Zabbix không hỗ trợ dự đoán TH xấu xảy ra.

Zabbix là một công cụ giám sát mạng đáng tin cậy. Nếu Zabbix cảnh báo người dùng về một lỗi nào đó, có tin tưởng 100% rằng vấn đề như vậy tồn tại. Ngoài ra, một trong những lợi thế chính của Zabbix là khả năng mở rộng của nó vì nó là khả năng áp dụng cho các môi trường có kích thước bất kỳ.


**5. Vấn đề cần cải thiện trong zabbix**

**5.1. Web Interface**
Thao tác sử dụng hiện tại của giao diện người dùng quá phức tạp. Người dùng cho Zabbix mới có thể gặp sự cố với Giao diện web. Một số thao tác cơ bản có thể tốn thời gian ngay cả đối với người dùng có kinh nghiệm. Phải thao tác quá nhiều cho một hoạt động cơ bản.

**5.2. API**
API có thể có hiện tượng rất chậm, đặc biệt là khi nói đến các hoạt động template linking. Ví dụ, có 10000 host và quản lý một mạng muốn liên kết chúng thành một template đơn giản. Nó sẽ mất khoảng 10-20 phút, tùy thuộc vào phần cứng. Ngoài ra, nó sẽ tạo ra quá nhiều truy vấn SQL. Số lượng họ thậm chí có thể đạt đến hàng triệu.

**5.3. Reporting**

**5.4. Scalability**

**5.5. Security**
# Reference
https://github.com/domanhduy/zabbix-monitor/blob/master/L%C3%BD%20thuy%E1%BA%BFt%20Zabbix.md
