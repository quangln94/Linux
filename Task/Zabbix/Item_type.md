Các loại mục bao gồm các phương pháp khác nhau để lấy dữ liệu từ hệ thống của bạn. Mỗi loại mặt hàng đi kèm với bộ khóa vật phẩm được hỗ trợ riêng và các tham số bắt buộc.

Các loại mặt hàng sau hiện đang được cung cấp bởi Zabbix:

Kiểm tra đại lý Zabbix
Kiểm tra đại lý SNMP
Bẫy SNMP
Kiểm tra IPMI
Kiểm tra đơn giản
Giám sát VMware
Giám sát tệp nhật ký
Mục tính toán
Kiểm tra nội bộ của Zabbix
Kiểm tra SSH
Kiểm tra Telnet
Kiểm tra bên ngoài
Kiểm tra tổng hợp
Vật phẩm
Giám sát JMX
Kiểm tra ODBC
Các mặt hàng phụ thuộc
Kiểm tra HTTP
Chi tiết cho tất cả các loại mặt hàng được bao gồm trong các trang con của phần này. Mặc dù các loại mặt hàng cung cấp rất nhiều tùy chọn để thu thập dữ liệu, vẫn có các tùy chọn khác thông qua các tham số người dùng hoặc các mô-đun có thể tải .

Một số kiểm tra được thực hiện bởi máy chủ Zabbix một mình (dưới dạng giám sát không có tác nhân) trong khi các kiểm tra khác yêu cầu tác nhân Zabbix hoặc thậm chí cổng Zabbix Java (có giám sát JMX).

Nếu một loại mặt hàng cụ thể yêu cầu một giao diện cụ thể (như kiểm tra IPMI cần giao diện IPMI trên máy chủ) thì giao diện đó phải tồn tại trong định nghĩa máy chủ.
Nhiều giao diện có thể được đặt trong định nghĩa máy chủ: tác nhân Zabbix, tác nhân SNMP, JMX và IPMI. Nếu một mục có thể sử dụng nhiều giao diện, nó sẽ tìm kiếm các giao diện máy chủ có sẵn (theo thứ tự: Tác nhân → SNMP → JMX → IPMI) cho giao diện thích hợp đầu tiên được liên kết.

Tất cả các mục trả về văn bản (ký tự, nhật ký, loại thông tin văn bản) chỉ có thể trả về khoảng trắng (nếu có), đặt giá trị trả về thành một chuỗi trống (được hỗ trợ từ 2.0).
