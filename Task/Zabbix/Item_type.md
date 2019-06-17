# I. Item type

Để lây dữ liệu từ hệ thống ta sử dụng các loại `item` khác nhau.</br>
Các loại `item` được cung cấp bởi Zabbix:

- Zabbix agent checks
- SNMP agent checks
- SNMP traps
- IPMI checks
- Simple checks
- VMware monitoring
- Log file monitoring
- Calculated items
- Zabbix internal checks
- SSH checks
- Telnet checks
- External checks
- Aggregate checks
- Trapper items
- JMX monitoring
- ODBC checks
- Dependent items
- HTTP checks

Nếu một `item` cụ thể yêu cầu một giao diện cụ thể (như IPMI check cần IPMI interface trên host) thì giao diện đó phải tồn tại trên máy chủ.</br>
Nhiều Interface có thể được set trên host: Zabbix agent, SNMP agent, JMX and IPMI. Nếu một `item` có thể sử dụng nhiều Interface, nó sẽ tìm kiếm interface của host có sẵn (theo thứ tự: Agent→SNMP→JMX→IPMI) cho Interface thích hợp đầu tiên được liên kết.</br>
Tất cả các mục trả về text (character, log, text types of information) chỉ có thể trả về khoảng trắng (nếu có).
## 1. Zabbix agent checks

Cách kiểm tra này sử dụng giao tiếp với Zabbix-agent để thu thập dữ liệu.,/br>

Có passive and active agent checks. Khi cấu hình `item`, bạn có thể chọn loại yêu cầu:
- Zabbix agent - for passive checks
- Zabbix agent (active) - for active checks

Các tham số không có dấu <> là bắt buộc. Các tham số được đánh dấu bằng dấu <> là tùy chọn.
## 2. SNMP agent checks
Bạn có thể muốn sử dụng giám sát SNMP trên các thiết bị như  printers, network switches, routers hoặc UPS thường được kích hoạt SNMP và trên đó sẽ không thực tế khi thử thiết lập hệ điều hành và Zabbix-agnet hoàn chỉnh.</br>
Để có thể truy xuất dữ liệu được cung cấp bởi các SNMP-agent trên các thiết bị này, máy chủ Zabbix phải được cấu hình với sự hỗ trợ SNMP.</br>
SNMP checks chỉ được thực hiện qua giao thức UDP.
## 3. SNMP Trap

Nhận SNMP  Trap ngược lại với truy vấn các thiết bị hỗ trợ SNMP.
 
Trong trường hợp này, thông tin được gửi từ một thiết bị hỗ trợ SNMP và được Zabbix thu thập hoặc "trapped" bởi Zabbix.

Thông thường traps được gửi khi có một số thay đổi điều kiện và agent kết nối với máy chủ trên cổng 162 (trái ngược với cổng 161 ở phía agent được sử dụng cho các truy vấn). Sử dụng traps có thể phát hiện một số vấn đề ngắn xảy ra giữa khoảng thời gian truy vấn và có thể bị mất bởi dữ liệu truy vấn.

Nhận SNMP traps trong Zabbix được thiết kế để hoạt động với **snmptrapd** và một trong những cơ chế tích hợp để chuyển traps đến Zabbix - có thể là tập lệnh perl hoặc SNMPTT.

Quy trình nhận trap:

- **snmptrapd** nhận được một trap
- **snmptrapd** chuyển trap đến SNMPTT hoặc gọi Perl trap receiver
- trap SNMPTT hoặc Perl phân tích cú pháp, định dạng và ghi trap vào một tệp
- Zabbix SNMP trapper đọc và phân tích file trap
- Đối với mỗi trap, Zabbix tìm tất cả các items "SNMP trapper" với host interfaces khớp với địa chỉ trap nhận được. Lưu ý rằng chỉ có các lựa chọn IP hoặc DNS trong host interface được sử dụng trong quá trình matching.
- Đối với mỗi item tìm thấy, trap được so sánh với regrec trong “snmptrap[regexp]”. Trap được đặt là giá trị của tất cả các item phù hợp. Nếu không tìm thấy item phù hợp nào và có một item “snmptrap.fallback”, thì trap được đặt là giá trị của item đó.
- Nếu trap không được đặt làm giá trị của bất kỳ item nào, Zabbix theo mặc định sẽ ghi lại trap chưa có. (Điều này được cấu hình bởi "Log unmatched SNMP traps" trong Administration → General → Other.)
