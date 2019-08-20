# TCPDUMP
## Mục lục
[I. Khái niệm](#khainiem)</br>
[II. Các OPTION](#cacoption)</br>
[III. Định dạng chung của một dòng giao thức TCPDUMP](#dinhdang)</br>
[IV. 11 Lệnh TCPDUMP hay được sử dụng](#haysudung)</br>
[V. Mở rộng](#morong)</br>
[VI. Tài liệu tham khảo](#tailieuthamkhao)</br>

<a name="khainiem"></a>
## I. Khái niệm

`tcpdump` à công cụ được phát triển nhằm mục đích phân tích các gói dữ liệu mạng theo dòng lệnh. Nó cho phép khách hàng chặn và hiển thị các gói tin được truyền đi hoặc được nhận trên 1 mạng mà máy tính tham gia.

`tcpdump` xuất ra màn hình nội dung các gói tin (chạy trên card mạng mà máy chủ đang lắng nghe) phù hợp với biểu thức logic chọn lọc mà khách hàng nhập vào. Với từng loại tùy chọn khác nhau khách hàng có thể xuất những mô tả về gói tin này ra 1 file `pcap` để phân tích sau. Và có thể đọc file `pcap` đó với `option -r` của lệnh `tcpdump`
<a name="cacoption"></a>
## II. Các OPTION

`-i` sử dụng tùy chọn này khi cần chụp các gói tin trên interfaces chỉ định.

`-D` khi sử dụng tùy chọn này tcpdump sẽ liệt kê ra tất cả các interface hiện hữu trên máy mà có thể capture được.

`-c N` sử dụng tùy chọn này nếu muốn bắt `N` gói tin.

`-n` khi sử dụng tùy chọn này tcpdump sẽ không phân giải địa chỉ IP sang hostname.

`-nn` khii sử dụng tùy chọn này tcpdump không phân giải địa chỉ sang host name và cũng không phân giải cả portname.

`-v` tăng khối lượng thông tin mà bạn mà gói tin có thể nhận được , thậm chí có thể tăng thêm với tùy chọn -vv và -vvv

`-X` hiển thị thông tin dưới dạng mã HEX hoặc ACSII.

`-XX` hiển thị thông tin dưới dạng mã HEX hoặc ACSII chuyển đôi luôn cả Ethernet header.

`-A` hiển thị các packet được capture dưới dạng ACSII.

`-S` Khi tcpdump capture packet, thì nó sẽ chuyển các số sequence number, ACK thành các relative sequense number, relative ACK. Nếu sử dụng option –S này thì nó sẽ không chuyển mà sẽ để mặc định.

`-F` filename Dùng để filter các packet với các luật đã được định trước trong tập tin filename.

`-e` Khi sử dụng option này, thay thì hiển thị địa chỉ IP của người gửi và người nhận, tcpdump sẽ thay thế các địa chỉ này bằng địa chỉ MAC.

`-t` Khi sử dụng option này, tcpdump sẽ bỏ qua thời gian bắt được gói tin khi hiển thị cho khách hàng.

`-tt` Khi sử dụng option này, thời gian hiển thị chính là thời gian chênh lệnh giữa thời gian tcpdump bắt được gói tin của gói tin và gói tin đến trước nó.

`-ttt` Khi sử dụng option này, sẽ hiển thị thêm ngày vào mỗi dòng lệnh.

`-tttt` Khi sử dụng option này, sẽ hiển thị thêm ngày vào mỗi dòng lệnh.

`-ttttt` Khi sử dụng option này, thời gian hiển thị trên mỗi dòng chính là thời gian chênh lệch giữa thời gian tcpdump bắt được gói tin của gói tin hiện tại và gói tin đầu tiên.

`-K` Với option này tcpdump sẽ bỏ qua việc checksum các gói tin.

`-N` Khi sử dụng option này tcpdump sẽ không in các quality domain name ra màn hình.

`-B` size Sử dụng option này để cài đặt buffer_size .

`-L` Hiển thị danh sách các datalink type mà interface hỗ trợ.

`-y` Lựa chọn datalinktype khi bắt các gói tin.
<a name="dinhdang"></a>
## III. Định dạng chung của một dòng giao thức `tcpdump`

| Trường | Mô tả |
|--------|-------|
| Time-stamp | Hiển thị thời gian gói tin được capture|
| SRC và DST | Địa chỉ IP nguồn và IP đích |
| Flag | S(SYN): Được sử dụng trong quá trình bắt tay của giao thức TCP.</br>(ACK): Được sử dụng để thông báo cho bên gửi biết là gói tin đã nhận được dữ liệu thành công.</br>F(FIN): Được sử dụng để đóng kết nối TCP.</br>P(PUSH): Thường được đặt ở cuối để đánh dấu việc truyền dữ liệu.</br>R(RST): Được sử dụng khi muốn thiết lập lại đường truyền.
| Data-sqeno | Số sequence number của gói dữ liệu hiện tại. |
| ACK |	Mô tả số sequence number tiếp theo của gói tin do bên gửi truyền (số sequence number mong muốn nhận được).|
| Window | Vùng nhớ đệm có sẵn theo hướng khác trên kết nối này.|
| Urgent | Cho biết có dữ liệu khẩn cấp trong gói tin.|
<a name="haysudung"></a>
## IV. 11 Lệnh `tcpdump` hay được sử dụng

### 1. Bắt gói tin từ một giao diện ethernet cụ thể thông qua `tcpdump -i`

Khi bạn thực thi lệnh `tcpdump` mà không có tùy chọn cụ thể, nó sẽ bắt tất cả các gói tin lưu thông qua card mạng. `Option -i` sẽ cho phép bạn lọc một Interface (giao diện/card mạng) ethernet cụ thể.
<img src="https://i.imgur.com/mLGL8Dc.png">
Trong ví dụ trên, `tcpdump` bắt tất cả các gói tin trong `enp3s0` và hiển thị theo chuẩn đầu ra.

### 2. Chỉ bắt số lượng `N` gói tin thông qua lệnh `tcpdump -c`

Khi bạn thực thi lệnh `tcpdump`, nó sẽ thực hiện đến khi bạn hủy bỏ lệnh. Sử dụng `option -c` bạn sẽ có thể lựa chọn cụ thể số lượng gói tin được bắt.
<img src="https://i.imgur.com/FcJWwE2.png">
### 3. Hiển thị các gói tin được bắt dưới dạng HEX và ASCII thông qua `tcpdump -XX`

<img src="https://i.imgur.com/9gOXHbY.png">

### 4. Bắt gói tin và ghi vào một file thông qua `tcpdump -w`
`tcpdump` cho phép bạn lưu gói tin thành một file, và sau đó bạn có thể sử dụng với mục đích phân tích khác.
<img src="https://i.imgur.com/lszlNWg.png">
Tùy chọn `-w` ghi các gói tin vào một file cho trước. Phần mở rộng của file nên là `.pcap` để có thể đọc được bởi các phần mềm phân tích giao thức mạng.

### 5. Đọc các gói tin từ một file thông qua `tcpdump -r`
Bạn có thể đọc được các file `.pcap` như sau:
<img src="https://i.imgur.com/sUZjJDE.png">

### 6. Bắt các gói tin với địa chỉ IP thông qua `tcpdump -n`
Trong các ví dụ phía trên hiển thị gói tin với địa chỉ DNS chứ không phải địa chỉ IP/ Ví dụ dưới đây bắt các gói tin và hiển thị địa chỉ IP của thiết bị liên quan.
<img src="https://i.imgur.com/XzE5LnI.png">

### 7. Bắt theo địa chỉ nguồn hoặc đích

- Địa chỉ nguồn: `tcpdump -i src ip`
- Địa chỉ đích: `tcpdump -i dst ip`
<img src="https://i.imgur.com/6yKCoaq.png">

### 8. Bắt các gói tin trên một PORT cụ thể thông qua `tcpdump port`
<img src="https://i.imgur.com/uiAPDxy.png">

### 9. Chỉ nhận những gói tin trong với một kiểu giao thức cụ thể.
VD: Giao thức `TCP`
<img src="https://i.imgur.com/syaSfGO.png">

### 10. Bắt tất cả các gói tin ngoại trừ `ARP`
<img src="https://i.imgur.com/bLgLgqw.png">

### 11. Bắt các gói tin kết nối `TCP` giữa 2 host

CD: Nếu hai tiến trình từ hai thiết bị kết nối thông qua giao thức `TCP`, chúng ta sẽ có thể bắt những gói tin thông qua lệnh dưới đây:

`tcpdump -i eth0 src 192.168.140.129 and port 22`

<img src="https://i.imgur.com/GHLtIpD.png">

<a name="morong"></a>
## V. Mở rộng</br>
### Các biểu thức</br>
Tiện ích `tcpdump` cũng hỗ trợ các biểu thức dòng lệnh, vẫn được sử dụng để định nghĩa các nguyên tắc lọc để bạn có được chính xác lưu lượng muốn xem, bỏ qua các gói không cần quan tâm đến. Các biểu thức gồm có một số các `primitive` (mẫu), các thuật ngữ `modifier` (từ bổ nghĩa) và tùy chọn. Các `primitive` và `modifier` không thiết lập một danh sách đầy đủ nhưng chúng chính là những gì hữu dụng nhất.</br>
### Primitive (mẫu)</br>
`dst foo`: Chỉ định một địa chỉ hoặc một hostname nhằm hạn chế các gói được `capture` về mặt lưu lượng gửi đến một HOST nào đó.</br>
`host foo`: Chỉ định một địa chỉ hoặc một hostname nhằm hạn chế các gói đã được `capture` về mặt lưu lượng đến và đi đối với một HOST nào đó.</br>
`net foo`: Chỉ định một MẠNG hoặc một ĐOẠN MẠNG sử dụng ghi chú CIDR để hạn chế sự `capture` gói.</br>
`proto foo`: Chỉ định một giao thức nhằm hạn chế các gói đã được `capture` về mặt lưu lượng mạng đang sử dụng GIAO THỨC đó.</br>
`src foo`: Chỉ định một địa chỉ hoặc một hostname nhằm hạn chế các gói được capture đối với lưu lượng được gửi bởi một HOST nào đó.</br>
### Modifiers (từ bổ nghĩa)</br>
`and`: Sử dụng modifier này nhằm trói buộc các mẫu cùng nhau khi bạn muốn hạn chế các gói đã được `capture` để có được các yêu cầu cần thiết của các biểu thức trên cả hai phía của `and`.</br>
`not`: Sử dụng từ bổ nghĩa này trước một mẫu khi bạn muốn hạn chế các gói đã được `capture` để không có được các yêu cầu của biểu thức theo sau.</br>
`or`: Sử dụng nhằm nhằm trói buộc các mẫu cùng nhau khi bạn muốn hạn chế các gói đã được capture để có được các yêu cầu cần thiết của một hoặc nhiều biểu thức trên phía của or.</br>
### Ví dụ</br>
Tất cả các tùy chọn, `primitive` và `modifier` này, cùng với một số tùy chọn khác được liệt kê trong trang chính của `tcpdump` có thể được sử dụng để xây dựng các lệnh rất cụ thể nhằm cung cấp đầu ra chính xác.</br>
- `tcpdump -c 50 dst foo`: Cho bạn các thông tin có thể nhận ra được nguồn của một lưu lượng nặng gửi đến và rất có thể làm quá tải máy chủ với hostname `foo`, kết xuất `50 gói đầu` tiên như đầu ra.</br>
- `tcpdump -c 500 -w date +"%Y%j%T".log`: Kết xuất 500 gói vào một file có tên tem time/date hiện hành (nghĩa là 2018112315:16:31.log) để chúng có thể được lọc sau theo các thông tin mà bạn muốn xem. Chúng tôi có lệnh `date +"%Y %j%T"`được lấy bí danh là stamp trong file rc của tiện ích, chính vì vậy có thể viết ngắn lệnh giống như vậy thành *tcpdump -c 500 -w `stamp`.log*, giảm việc phải nhớ tất cả các tùy chọn định dạng cho lệnh date.</br>
- `tcpdump proto ssh src or dst foo and src and dst not bar`: Làm cho hiển thị đầu ra đang được thực hiện hiển thị tất cả các hoạt động SSH được khởi đầu từ hoặc nhắm đến `host “foo”` trừ khi nó đang khởi đầu từ `host “bar”` hoặc nhắm đến `host “bar”`. Nếu `foo` chỉ được cho là được truy cập thông qua `SSH` bởi `bar`, thì lệnh này sẽ cho phép kiểm tra đang diễn ra đối với lưu lượng SSH chưa được thẩm định gửi đến và từ `foo`. Thậm chí bạn còn có thể bắt đầu một số các quá trình kiểm tra liên tục với `tcpdump` giống như vậy bên trong một phiên [tmux](https://en.wikipedia.org/wiki/Tmux) trên một máy chủ chuyên dụng.</br>

Như những gì bạn thấy, các biểu thức của `tcpdump` gần như tương đương với một ngôn ngữ lập trình ở phạm vi đơn giản, tạo được sự dễ hiểu cho người dùng. Với khả năng mạnh và sự linh động đó, bạn hoàn toàn có thể không cần đến các công cụ khác cho các nhiệm vụ phân tích lưu lượng tổng quát.

### Dùng `TCPDUMP` bắt gói tin và  Wireshark để đọc
- Bắt gói tin `ICMP` sử dụng lệnh `PING` như sau:
<img src="https://i.imgur.com/RKSO2El.png">
Đọc file sử dụng Wireshark Filter theo giao thức ICMP
<img src="https://i.imgur.com/UShswqq.png">

- Bắt gói tin `DHCP` và phân tích
<img src="https://i.imgur.com/DxLvrU2.png">
B1: Máy client có địa chỉ 0.0.0.0 gửi bản tin DHCP Discover tới địa chỉ Broadcast 255.255.255.255 đẻ xin cấp phất địa chỉ IP</br>
B2: IP 192.168.1.1 đóng vai trò là DHCP server gửi bản tin Offer địa chỉ IP 192.168.1.4 cho máy Client</br>
B3: Máy Client gửi bản tin DHCP Request tơi địa chỉ Broadcast để xin cấp phát địa chỉ 192.168.1.4 của bước 2</br>
B3: DHCP Server gửi bản tin ACK cấp địa chỉ 192.168.1.4 cho máy Client

<a name="tailieuthamkhao"></a>
## VI. Tài liệu tham khảo
- https://github.com/MinhKMA/meditech-thuctap/blob/master/MinhNV/Network%20Commands/docs/tcpdump.md
- https://securitydaily.net/phan-tich-goi-tin-15-lenh-tcpdump-duoc-su-dung-trong-thuc-te/
- https://www.diendanmaychu.vn/showthread.php/334-S%E1%BB%AD-d%E1%BB%A5ng-tcpdump-%C4%91%E1%BB%83-ph%C3%A2n-t%C3%ADch-l%C6%B0u-l%C6%B0%E1%BB%A3ng
