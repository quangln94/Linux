# Linux Namespace

## 1. Giới thiệu
Linux namespace bao gồm một số công nghệ cơ bản đằng sau hầu hết các triển khai container hiện đại. Ở cấp độ cao, chúng cho phép cô lập tài nguyên hệ thống. Ví dụ, namespace PID cô lập không gian số ID tiến trình. Điều này có nghĩa là hai tiến trình đang chạy trên cùng một máy chủ có thể có cùng một PID!

## 2. Các loại namespace

Mount - cô lập các filesystem mount point
UTS - cô lập hostname và domainname
IPC - cô lập tài nguyên giao tiếp liên tiến trình(IPC)
PID - cô lập vùng số cấp cho ID của tiến trình
Network - cô lập giao diện mạng
User - cô lập về UID/GID
Cgroup - cô lập về thư mục root của tính năng cgroups, chỉ mới xuất hiện từ Linux Kernel phiên bản 4.6 trở đi

### 2.5. Process Namespace - PID

Trong Linux duy trì một process tree. Tre tham chiếu đến mọi process đang chạy trong hệ thống phân cấp parent-child. Một process có đủ quyền và thỏa mãn một số điều kiện nhất định có thể kiểm tra một quy trình khác hoặc thậm chí có thể kill process đó.

Với Process namespace có thể có nhiều process tree lồng vào nhau. Mỗi process tree có thể có một bộ quy trình hoàn toàn độc lập. Điều này có thể đảm bảo rằng các process thuộc một process tree không thể kiểm tra hoặc kill hoặc thậm chí không thể biết được sự tồn tại của các process trong các sibling hoặc parent process trees khác.

Mỗi khời động Linux, nó khởi động chỉ bằng một process với PID=1. Quá trình này là gốc của process tree và nó khởi tạo phần còn lại của hệ thống. Tất cả các process khác bắt đầu bên dưới process này trong process tree. Namespace PID cho phép vào 1 proces tree mới với PID=1 của riêng nó. Quá trình này vẫn ở trong parent namespace, trong tree ban đầu, nhưng làm cho child trở thành gốc của process tree riêng của nó.

<img src=https://i.imgur.com/E3xgJ1H.png>

Với sự cô lập Process namespace PID, các tprocess trong child namespace không biết được sự tồn tại của parent process. Tuy nhiên, các process trong parent namespace có một cái nhìn đầy đủ về các process trong child namespace như thể chúng là những process khác trong parent namespace.

Trong mã nguồn Linux, chúng ta có thể thấy rằng một cấu trúc có tên pid, được sử dụng để theo dõi chỉ một PID, giờ đây theo dõi nhiều PID thông qua việc sử dụng một cấu trúc có upid:

### 2.6 Network Namespace

Tham khảo phần Network Namespace [tại đây](https://github.com/quangln94/Linux/blob/master/Overview/Content/24_Network_Namespaces.md)

# Tài liệu tham khảo
- https://www.toptal.com/linux/separation-anxiety-isolating-your-system-with-linux-namespaces
- https://blogd.net/linux/gioi-thieu-ve-linux-namespaces/
