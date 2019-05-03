# 1. Giới thiệu chung
Zabbix được tạo ra bởi Alexei Vladishev và đang được phát triển bởi zabbix SIA. Đây là giải pháp giám sát mã nguồn mở. Có khả năng giám sát hệ các thông số trong hệ thống mạng. Nó có thể cài đặt để gửi các thông báo qua nhiều kênh để đến với người quản trị nhằm khắc phục nhanh nhất các sự cố.</br>
Zabbix cũng support web-based để có thể theo dõi trạng thái của các thiết bị. Điều này tạo điều kiện dễ dàng cho việc giám sát khi bạn ở bất kỳ đâu.</br>
# 2. Kiến trúc của Zabbix gồm các thành phần chính sau:
**Server**: Nơi xử lý tất cả các thông tin mà các thiết bị gửi về.</br>
**Database storage**: Tất cả các thông tin từ các thiết bị được thu thập sẽ được lưu trữ trong một database.</br>
**Web interface**: Web interface giúp ta có thể truy cập để theo dõi các thiết bị ở bất kỳ đâu. Nó là một phần của zabbix server.
**Proxy**: Zabbix Proxy có nhiệm vụ thu thập và phân tích dữ liệu thay cho Zabbix Server. Đây là một tùy chọn nên bạn có thể cài nó hoặc không nhưng nó sẽ rất hữu ích với hột hệ thống lớn. Nó sẽ giúp giảm tải cho Zabbix Server.
**Agent**: Zabbix Agent được cài đặt trên các thiết bị mà ta cần giám sát. Nó sẽ có nhiệm vụ thu thập thông tin và gửi nó về Zabbix Server.
# 3.Một số thuật ngữ
Dưới đây là một số thuật ngữ mà ta hay gặp khi làm việc với Zabbix.
**host**: Là một thiết bị mạng mà ta muốn giám sát sử dụng địa chỉ IP/DNS</br>
**host group**: Là một nhóm các host, nó có thể bao gồm các host và các template. Host group được sử dụng khi ta gán quyên truy cập host cho các nhóm người dùng khác nhau.</br>
**item**: Các thông số mà bạn muốn thu thập từ các host để giám sát.
**value preprocessing**: Các dữ liệu được các host gửi về zabbix server sẽ được xử lý trước khi lưu và database.</br>
**trigger**: Là ngưỡng mà ta đặt ra để xuất hiện cảnh báo. VD như ta đặt một trigger là số RAM free < 200M sẽ xuất hiện cảnh báo.
**event**: Là sự thay đổi của một cái gì đó đáng chú ý ví dụ như trạng thái của trigger có sự thay đổi.
**event tag**: </br>
**event corelation**: </br>
**problem**: một trạng thái của trigger.</br>
**problem update**: Các tùy chọn quản lý sự cố do zabbix cung cấp như thêm comment,...</br>
**action**: Một phương tiện xác định trước để phản ứng với một event. VD như một hành động gửi thông báo và các điều kiện của nó khi một event xảy ra.</br>
**escalation**: Một kịch bản các hoạt động bên trong một hành động.</br>
**media**: Cách thức gửi thông báo vd như qua mail hoặc telegram. </br>
**notification**: Một thông báo về một số event gửi tới người quản trị thông qua các kênh thông báo.</br>
**remote command**: Các lệnh được xác định trước và được thực hiện trên các host mà ta giám sát.</br>
**template**: Nnhững items, trigger, graphs, screens, application,... được tạo trong 1 template là có thể áp dụng nó với các host khác mà ko cần tạo lại.</br>
**application**: Một nhóm các items trong một logical group</br>
**web scenario**: Một hoặc một số requests HTTP dùng để check hoạt động của môt web site.</br>
**frontend**: Giao diện web được cung cấp bởi zabbix</br>
**dashboard**: Một mục trên giao diện web hiển thị tóm tắt và trực quan một số thông tin quan trọng</br>
**zabbix API**:</br>
**Zabbix server**: Một quy trình trung tâm của phần mềm zabbix, tương tác với zabbix proxy và zabbix agent, tính toán các trigger và gửi đi thông báo. Là nơi xử ly trung tâm.</br>
**Zabbix agent**: Là một process được cài đặt trên host có nhiệm vụ thu thập dữ liệu.</br>
**Zabbix proxy**: Một process thay mặt cho zabbix server thu thập dữ liệu và xử lý nó. Nó giúp giảm tải cho zabbix server.</br>
**netwwork discovery**:</br>
**item prototype**:</br>
**trigger prototype**:</br>
