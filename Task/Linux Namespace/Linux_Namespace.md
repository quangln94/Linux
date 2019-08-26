# Linux Namespace

## 1. Giới thiệu
Linux namespace bao gồm một số công nghệ cơ bản đằng sau hầu hết các triển khai container hiện đại. Ở cấp độ cao, chúng cho phép cô lập tài nguyên hệ thống.
## 2. Mục tiêu 

Cung cấp một môi trường an toàn để tránh rủi ro.

Trên 1 máy thông thường một môi trường hệ thống duy nhất có thể ổn. Nhưng trên một máy chủ chạy nhiều dịch vụ tính bảo mật và ổn định là điều cần thiết nên các dịch vụ càng độc lập càng tốt. Hãy tưởng tượng một máy chủ chạy nhiều dịch vụ và một trong số đó bị xâm nhập bởi hacker. Trong trường hợp đó, hacker có thể khai thác dịch vụ đó và tìm đường đến các dịch vụ khác và thậm chí có thể xâm nhập toàn bộ máy chủ. Namespace Isolation có thể cung cấp một môi trường an toàn để loại bỏ rủi ro này.

Các công cụ namespace như Docker cho phép kiểm soát tốt hơn các quy trình sử dụng tài nguyên hệ thống, làm cho các công cụ đó trở nên cực kỳ phổ biến để các nhà cung cấp PaaS sử dụng. Các dịch vụ như Heroku và Google App Engine sử dụng các công cụ như vậy để cô lập và chạy nhiều ứng dụng máy chủ web trên cùng một phần cứng. Các công cụ này cho phép họ chạy từng ứng dụng (có thể được triển khai bởi bất kỳ người dùng nào khác) mà không phải lo lắng về việc một trong số họ sử dụng quá nhiều tài nguyên hệ thống hoặc can thiệp gây xung đột với các dịch vụ được triển khai khác trên cùng một máy. 

## 3. Các loại namespace

***Mount*** - cô lập các filesystem mount point

***UTS*** - cô lập hostname và domainname

***IPC*** - cô lập tài nguyên giao tiếp liên tiến trình

***PID*** - cô lập vùng số cấp cho ID của tiến trình

***Network*** - cô lập giao diện mạng

***User*** - cô lập về UID/GID

***Cgroup*** - cô lập về thư mục root của tính năng cgroups

### 3.1 Mount Namespace

Mount Namespace cô lập danh sách các mountpoint được nhìn thấy bởi các process trong mỗi namespace. Do đó, các process trong mỗi trường hợp Mount Namespace sẽ thấy các cấu trúc thư mục đơn riêng biệt.

Mục tiêu của Mount Namespace là để tránh tiết lộ bất kỳ thông tin nào về cấu trúc hệ thống cơ bản.

Linux cũng duy trì cấu trúc dữ liệu cho tất cả các mountpoint của hệ thống. Nó bao gồm thông tin như những phân vùng được mount, nơi mount. Mount Namespace có thể nhân bản cấu trúc dữ liệu này, do đó các process dưới các namespace khác nhau có thể thay đổi các mountpoint mà không ảnh hưởng lẫn nhau.

Ban đầu, process con nhìn thấy các mountpoint giống như process cha của nó nhìn thấy. Tuy nhiên, trong Mount namespace mới, process con có thể mount hoặc umount hay đại loại là thay đổi cấu trúc file hệ thống mà không ảnh hưởng đến các Child Mount Namespace  khác hay chính Parent Mount Namespace của nó (độc lập và không có sự đồng bộ giữa các Mount Namespace).

<img src=https://i.imgur.com/Zz4eDtP.png>

Hình trên mô tả việc tạo ra 3 Child Mount Namespace có cấu trúc File khác hoặc tương tự như Parent Namespace.

<img src=https://i.imgur.com/s00Ltb0.png>

Sau đó thực hiện thay đổi Mountpoint cho 1 hoặc nhiều Mount Namespace thậm chí thay đổi cả Paren Mount Namespace.

Việc thay đổi Mountpoint của mỗi Mount Namespace không anh hương các Mount Namespace còn lại.

### 3.2 UTS Namespace

UTS Namespace là một namespace để cô lập các thiết lập liên quan đến hostname và domainname nhận diện của hệ thống

Lệnh `unshare` cho phép chạy một chương trình với một số namespace và "không chia sẻ" với parent của nó, có nghĩa là unshare sẽ chạy bất kỳ chương trình nào trong một namespace.

Sự cô lập này có thể được kiểm tra bằng cách chạy `hostname my-new-hostname` bên trong UTS namespace `/bin/sh` và xác nhận thay đổi `hostname` không được phản ánh bên ngoài process đó.
```
[root@client01 ~]# hostname
client01
[root@client01 ~]# unshare -u /bin/sh
sh-4.2# hostname client02
sh-4.2# hostname
client02
sh-4.2# exit
exit
[root@client01 ~]# hostname
client01
[root@client01 ~]#
```

### 3.3 IPC Namespace

<img src=https://i.imgur.com/zJ2cSCu.png>

Hãy nhìn vào hình trên để hiểu thế nào là IPC Namespace.

IPC là gì? IPC là inter-process communication có nghĩa là Giáo tiếp giữa các process nội miền. Vậy IPC Namespace là việc cô lập các giao tiếp giữa các process này của các IPC Namespace khác nhau. 

### 3.4. Process Namespace - PID

Trong Linux duy trì một process tree. Process tre tham chiếu đến mọi process đang chạy trong hệ thống phân cấp parent-child. Một process có đủ quyền và thỏa mãn một số điều kiện nhất định có thể kiểm tra một quy trình khác hoặc thậm chí có thể kill process đó.

Với Process namespace có thể có nhiều process tree lồng vào nhau. Mỗi process tree có thể có một bộ quy trình hoàn toàn độc lập. Điều này có thể đảm bảo rằng các process thuộc một process tree không thể kiểm tra hoặc kill hoặc thậm chí không thể biết được sự tồn tại của các process trong các sibling hoặc parent process trees khác.

Mỗi khời động Linux, nó khởi động chỉ bằng một process với PID=1. Quá trình này là gốc của process tree và nó khởi tạo phần còn lại của hệ thống. Tất cả các process khác bắt đầu bên dưới process này trong process tree. PID Namespace cho phép vào 1 proces tree mới với PID=1 của riêng nó. Quá trình này vẫn ở trong parent namespace, trong tree ban đầu, nhưng làm cho child trở thành gốc của process tree riêng của nó.

<img src=https://i.imgur.com/E3xgJ1H.png>

Để hiểu rõ hơn về PID Namespace, hãy cùng phân tích hình trên như sau:

- Khi Linux khởi động, nó khởi động bằng 1 process với PID=1
- Sau đó, từ PID=1 nó sinh ra các PID=2,3,4,5,6,7,8.
- Ở đây ta thấy 1 Process có 2 giá trị là 8-1, 9-2, 10-3 tức là nó sẽ có PID=1,2,3 trong vùng child PID Namespace được tạo ra nhưng bên ngoài vùng Namespace này Process tree gốc sẽ coi nó với PID=8,9,10 và sẽ không biết được sự hình thành và tồn tại của child PID Namesapce hay process tree này.
- Ngược lại process tree trong child PID Namespace này sẽ không biết được sự tồn tại của các PID bên ngoài Namespace của nó và nó coi nó là 1 process tree duy nhất.

Tóm lại: với sự cô lập PID namespace, các process trong child namespace không biết được sự tồn tại của parent process. Tuy nhiên, các process trong parent namespace có một cái nhìn đầy đủ về các process trong child namespace như thể chúng là những process khác trong parent namespace.

Trong Linux, chúng ta có thể thấy rằng một cấu trúc có tên pid, được sử dụng để theo dõi chỉ một PID, giờ đây theo dõi nhiều PID thông qua việc sử dụng một cấu trúc có upid

### 3.5 Network Namespace

Tham khảo phần Network Namespace [tại đây](https://github.com/quangln94/Linux/blob/master/Overview/Content/24_Network_Namespaces.md)

### 3.6 User namespace

User Namespace được sử dụng để cô lập UID và GID giữa máy chủ và containers làm tăng tính bảo mật: Nó có thể là root của Namespace này nhưng lại là non-root  ngoài namespace.

User Namespace cô lập các định danh và thuộc tính liên quan đến bảo mật, đặc biệt là User ID Group ID. User ID và Group ID của một process có thể khác nhau giữa bên trong và bên ngoài một User Namespace. 

User namespace được lồng vào nhau tương tự PID Namespace

<img src=https://i.imgur.com/FOwUGt5.png>

Hinh trên thể hiện 1 ví dụ về User Namespace

- Trong Namespace 1 có Process 1 với UID=0 và GID=0 (user root) , Process 2 có UID=1000, GID=1000 (user non-root)
- Process 2 tạo ra 1 Namespace 2 và đóng vai trò là user root trong Namespace này với UID=0, GID=0.

### 3.7 Control Group

Control groups thường được gọi là `Cgroups`. `Cgroups` cho phép bạn có thể cấp phát tài nguyên – như thời gian sử dụng CPU, RAM, Network. Bạn có thể theo dõi `Cgroups`, từ chối `Cgroups` sử dụng tài nguyên nhất định và ngay cả việc cấu hình lại `Cgroups` trên một hệ thống đang chạy.

Tài nguyên phần cứng sẽ được chia sẽ hiệu quả giữa các người dùng và tăng khả năng ổn định của hệ thống. Tài nguyên phần cứng ở đây là:
- ***memory:*** giới hạn việc sử dụng bộ nhớ hệ thống.
- ***cpu:*** sử dụng OS scheduler để cấp phát CPU cho các “task”.
- ***net_prio:*** giới hạn băng thông mạng theo độ ưu tiên.

Ví dụ như khi hệ thống của bạn có 10GB RAM và bạn có 2 người dùng. Khi đó, bạn cấp cho mỗi người dùng 3GB RAM thì mỗi người được giới hạn sử dụng tối đã là 3GB mà không thể sử dụng hơn phần mình được cấp. Do đó sẽ không ảnh hưởng đến tài nguyên của người khác hay toàn bộ hệ thống.

Ngoài ra còn 1 số tính năng khác như: 

- ***cpuacct:*** báo cáo về trình trạng sử dụng CPU của các `task`.
- ***cpuset:*** giới hạn việc sử dụng số lượng CPU trên hệ thống nhiều CPU.
- ***blkio:*** giới hạn việc truy cập nhập/xuất(I/O) đến các thiết bị như ổ đĩa cứng.
- ***net_cls:*** đánh số classid cho từng gói tin nhằm giúp Linux Traffic Controller(tc) có thể biết gói tin đến từ cgroup nào.

Các tính năng của `Cgroup` xem thêm [tại đây](https://www.server-world.info/en/note?os=CentOS_7&p=cgroups&f=1)

Tương tự như các process, `Cgroups` có cấu trúc phân cấp, các Child Cgroups sẽ thừa hưởng các thuộc tính từ Parent Cgroups. Trong `Cgroups`, các tài nguyên hệ thống được gọi bằng thuật ngữ `subsystem` hay `resource controller` và các process trên hệ thống được gọi là `task`.

# Tài liệu tham khảo
- https://www.toptal.com/linux/separation-anxiety-isolating-your-system-with-linux-namespaces
- https://blogd.net/linux/gioi-thieu-ve-linux-namespaces/
- http://man7.org/linux/man-pages/man7/namespaces.7.html
- https://medium.com/@teddyking/linux-namespaces-850489d3ccf
- https://wvi.cz/diyC/namespaces/#namespaces
- https://minhkma.github.io/2019/01/cgroup/
- https://mrhien.info/blog/gioi-thieu-ve-linux-control-groups-cgroups/
