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


