# Item type

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
